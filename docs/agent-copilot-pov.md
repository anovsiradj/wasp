## What this project is

This is a Windows-focused local server environment repository for PHP/web development, not a normal web app.

It is basically a portable Windows stack:
- php.md, httpd.md, nginx.md, composer.md, caddy.md are setup docs.
- httpd, nginx, `php*/`, `node-v*`, composer, npm contain server binaries/configs.
- php.ini.stub is the shared PHP configuration template.
- conf has an Apache config framework with httpd_envs.conf, httpd_fcgi.conf, and httpd_hosts.conf.
- composer.json exists, but it is metadata only and not the main project driver.

## What it does

The repo is designed to let you run:
- Apache HTTPD with mod_fcgid and multiple PHP versions
- Nginx
- Caddy
- Composer with its own `COMPOSER_HOME` and cert settings
- Multiple PHP versions installed side-by-side

The Apache config is set up to expose multiple virtual hosts on different ports, with hardcoded roots like projects and waap.

## Strengths

- Good practical focus: manual Windows server setup without XAMPP/Laragon.
- Clear intent to support legacy PHP versions and multiple PHP versions concurrently.
- Useful documentation for Windows PHP binary setup and required extensions.
- Includes a real Apache httpd_fcgi.conf that configures `mod_fcgid`.
- The repo appears intended as a learning resource for “how Windows web servers work”.

## Honest criticisms

1. **[NOPE]** composer.json is almost meaningless here
   - It just declares package metadata and Symfony VarDumper, but the repo is mostly config/docs/binaries.
   - That makes the PHP package file feel disconnected from the actual project purpose.

2. **[YES]** There is no automation yet
   - TODOs.md mentions `./install php version=8.5 folder=php85` etc.
   - But there is no actual install script in the repo to perform those tasks.
   - This means the workflow is still very manual.

3. **[NOPE]** Hardcoded absolute paths
   - httpd_envs.conf defines waap, and php.ini.stub points to `C:/wasp/cacert.pem`.
   - This reduces portability and makes it harder to move the project.

4. **[NOPE]** Large binary content in repo
   - The repo contains `node-v*` folders, PHP zip files and full binaries.
   - That is fine for a portable archive, but it makes the repo heavy and hard to manage in Git.

5. **[NOPE]** Apache config is redundant / could be cleaned
   - httpd_hosts.conf duplicates `DocumentRoot` and `<Directory>` blocks.
   - `Options All` and `Require all granted` are very permissive, which is okay for local dev but not good practice.
   - The vhosts all point to the same root; if the goal is version switching, it could be simplified to one template.

6. **[YES]** Incomplete documentation
   - caddy.md is essentially empty.
   - phpmyadmin.md is mentioned but the main README doesn’t describe how to wire it in.
   - There is little or no documentation for actual start/stop commands or Windows service management beyond Apache.

## Useful suggestions

- **[TODO]** Add the missing install/automation layer
  - Create a PowerShell or batch script to download, extract, and configure PHP/HTTPD/Nginx/Caddy automatically.
  - Make commands like `install php version=8.5 folder=php85` actually work.

- **[NOPE]** Move away from hardcoded roots
  - Use environment variables or relative paths in configs.
  - Allow the repo to live in any Windows folder, not just waap.

- **[MAYBE]** Improve README and workflow docs
  - Add “how to start Apache”, “how to start Nginx”, “how to use multiple PHP versions”.
  - Document Windows service installation for Apache and any startup shortcuts.

- **[NOPE]** Clean up Apache config
  - Reduce repeated blocks and use a templated per-version vhost if needed.
  - Consider using `SetEnvIf` or `Define` for PHP roots more cleanly.

- **[MAYBE]** Consider standardizing this as a “portable Windows web server environment”
  - If that is the goal, the repo should lean into scripts + templates instead of storing large binaries directly.
  - If the goal is to teach, it should include a clear “this is how to use it” guide and maybe a single `start` command wrapper.

## Overall impression

This is a solid Windows dev stack playground and reference project,
especially for someone who wants control over Apache/PHP on Windows.
It is currently more of a manual setup repository than a polished product,
so the biggest improvement would be automating the installation/configuration and tightening the docs/configs.
