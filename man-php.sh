#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
REPO_ROOT="$SCRIPT_DIR"
TMP_DIR="$REPO_ROOT/tmp"
RELEASES_JSON_URL="https://downloads.php.net/~windows/releases/releases.json"

print_help() {
  cat <<'EOF'
Usage: ./php-man.sh <command> [args]

Commands:
  list-available          List PHP versions available for download (NTS only).
  list-installed          List installed php* folders with detected versions.
  install <version> [folder]
                          Download and extract PHP NTS binary.

Options:
  --arch <x64|x86|arm64>  Force architecture. Default: auto (x64, arm64, x86).
  --force                 Overwrite target folder if it exists.

Examples:
  ./php-man.sh list-available
  ./php-man.sh list-installed
  ./php-man.sh install 8.5
  ./php-man.sh install 8.5.4 php85
  ./php-man.sh install --arch x86 8.4 php84custom
  ./php-man.sh install --force 8.5
EOF
}

get_releases_json() {
  local cache_file="$TMP_DIR/releases.json"
  mkdir -p "$TMP_DIR"
  local cache_age=0
  if [ -f "$cache_file" ]; then
    cache_age=$(( $(date +%s) - $(stat -c %Y "$cache_file" 2>/dev/null || echo $(date +%s)) ))
  fi
  if [ ! -f "$cache_file" ] || [ $cache_age -gt 604800 ]; then
    echo "Fetching releases.json..."
    curl -fsSL "$RELEASES_JSON_URL" -o "$cache_file" || {
      echo "Error: failed to fetch $RELEASES_JSON_URL" >&2
      exit 1
    }
  fi
  cat "$cache_file"
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Error: required command '$1' not found." >&2
    exit 1
  fi
}

list_available() {
  require_cmd curl grep sed sort
  
  local json
  json=$(get_releases_json)
  
  echo "Available PHP NTS versions:"
  echo "$json" | grep -oE '"[0-9]+\.[0-9]+\.[0-9]+"' | sed 's/"//g' | sort -V -u | while read -r ver; do
    archs=$(echo "$json" | grep -c "php-$ver-nts-Win32" || true)
    if [ "$archs" -gt 0 ]; then
      printf "  %s\n" "$ver"
    fi
  done | tail -50
}

resolve_version() {
  local requested="$1"
  require_cmd curl grep sed
  
  local json
  json=$(get_releases_json)

  if [[ "$requested" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    if echo "$json" | grep -q "php-$requested-nts-Win32"; then
      printf '%s' "$requested"
      return 0
    fi
    echo "Error: PHP version '$requested' not found." >&2
    exit 2
  fi

  if [[ "$requested" =~ ^[0-9]+\.[0-9]+$ ]]; then
    local matched
    matched=$(echo "$json" | grep -oE "php-$requested\.[0-9]+-nts-Win32" | sed 's/php-//;s/-nts-Win32//' | sort -V | tail -n1)
    if [ -n "$matched" ]; then
      printf '%s' "$matched"
      return 0
    fi
    echo "Error: no releases match version '$requested'." >&2
    exit 2
  fi

  echo "Error: invalid version format '$requested'. Use 8.5 or 8.5.4." >&2
  exit 2
}

detect_arch() {
  local system_arch
  system_arch=$(uname -m 2>/dev/null || echo "x86_64")
  
  case "$system_arch" in
    x86_64|amd64) echo "x64" ;;
    aarch64|arm64) echo "arm64" ;;
    i386|i686|x86) echo "x86" ;;
    *) echo "x64" ;;
  esac
}

find_download_url() {
  local version="$1"
  local arch="${2:-auto}"
  require_cmd curl grep sed
  
  if [ "$arch" = "auto" ]; then
    local detected
    detected=$(detect_arch)
    arch="$detected"
  fi

  local json
  json=$(get_releases_json)

  local archs_to_try=()
  if [ "$arch" = "x64" ]; then
    archs_to_try=(x64 arm64 x86)
  elif [ "$arch" = "arm64" ]; then
    archs_to_try=(arm64 x64 x86)
  elif [ "$arch" = "x86" ]; then
    archs_to_try=(x86 x64 arm64)
  else
    archs_to_try=(x64 arm64 x86)
  fi

  for try_arch in "${archs_to_try[@]}"; do
    local filename
    filename=$(echo "$json" | grep -oE "php-$version-nts-Win32-[^\"]*-$try_arch\.zip" | head -n1)
    if [ -n "$filename" ]; then
      printf '%s' "$filename"
      return 0
    fi
  done

  echo "Error: no NTS package found for PHP $version." >&2
  exit 3
}

download_and_extract() {
  local filename="$1"
  local target="$2"
  local url="https://downloads.php.net/~windows/releases/$filename"
  
  require_cmd curl unzip
  
  mkdir -p "$TMP_DIR"
  local zip_file="$TMP_DIR/$filename"
  
  if [ ! -f "$zip_file" ]; then
    echo "Downloading $filename..."
    curl -fL -o "$zip_file" "$url" || {
      echo "Error: failed to download." >&2
      exit 1
    }
  else
    echo "Using cached $filename..."
  fi
  
  local tmpdir="" tmpfile=""
  tmpdir=$(mktemp -d) || exit 1
  local tmpdir_escaped
  tmpdir_escaped=$(printf '%q' "$tmpdir")
  trap "rm -rf $tmpdir_escaped" EXIT

  echo "Extracting..."
  unzip -oq "$zip_file" -d "$tmpdir" || {
    echo "Error: failed to extract archive." >&2
    exit 1
  }

  local source_dir
  local entry
  local entries=("$tmpdir"/* "$tmpdir"/.[!.]* "$tmpdir"/..?*)
  local count=0

  for entry in "${entries[@]}"; do
    [ -e "$entry" ] || continue
    count=$((count + 1))
    source_dir="$entry"
  done

  if [ "$count" -eq 1 ] && [ -d "$source_dir" ]; then
    source_dir="$source_dir"
  else
    source_dir="$tmpdir"
  fi

  mkdir -p "$target"
  shopt -s dotglob nullglob
  mv "$source_dir"/* "$target/" || {
    shopt -u dotglob nullglob
    echo "Error: failed to move files." >&2
    exit 1
  }
  shopt -u dotglob nullglob

  if [ ! -f "$target/php.ini" ] && [ -f "$target/php.ini-development" ]; then
    cp "$target/php.ini-development" "$target/php.ini"
    echo "Created php.ini from php.ini-development"
  fi

  echo "Installed into $target"
}

install_php() {
  local arch="auto"
  local force=0
  local version=""
  local folder=""

  while [ $# -gt 0 ]; do
    case "$1" in
      --arch)
        shift
        arch="$1"
        shift
        ;;
      --force)
        force=1
        shift
        ;;
      *)
        if [ -z "$version" ]; then
          version="$1"
        else
          folder="$1"
        fi
        shift
        ;;
    esac
  done

  if [ -z "$version" ]; then
    echo "Error: install requires <version>" >&2
    print_help
    exit 1
  fi

  version=$(resolve_version "$version")
  
  if [ -z "$folder" ]; then
    folder="php$(printf '%s' "$version" | cut -d. -f1-2 | tr -d '.')"
  fi

  local target="$REPO_ROOT/$folder"

  if [ -d "$target" ] && [ "$force" -ne 1 ]; then
    echo "Error: $target already exists. Use --force to overwrite." >&2
    exit 1
  fi

  local filename
  filename=$(find_download_url "$version" "$arch")
  download_and_extract "$filename" "$target"
  
  echo "✓ PHP $version installed to $folder"
}

list_installed_versions() {
  local found=0
  printf '%-20s %s\n' "FOLDER" "VERSION"
  printf '%-20s %s\n' "------" "-------"
  
  shopt -s nullglob
  for dir in "$REPO_ROOT"/php*; do
    [ -d "$dir" ] || continue
    found=1
    local folder="${dir##*/}"
    local version="unknown"
    
    if [ -x "$dir/php.exe" ]; then
      version=$("$dir/php.exe" -v 2>/dev/null | head -n1 | awk '{print $2}' || echo "unknown")
    elif [ -x "$dir/php" ]; then
      version=$("$dir/php" -v 2>/dev/null | head -n1 | awk '{print $2}' || echo "unknown")
    fi
    
    printf '%-20s %s\n' "$folder" "$version"
  done
  shopt -u nullglob
  
  if [ "$found" -eq 0 ]; then
    echo "No installed php* folders found."
  fi
}

main() {
  if [ $# -lt 1 ]; then
    print_help
    exit 0
  fi

  case "$1" in
    list-available)
      list_available
      ;;
    list-installed)
      list_installed_versions
      ;;
    install)
      shift
      install_php "$@"
      ;;
    help|-h|--help)
      print_help
      ;;
    *)
      echo "Error: unknown command '$1'" >&2
      print_help
      exit 1
      ;;
  esac
}

main "$@"
