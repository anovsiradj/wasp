# Apache HTTPD Directory Options

This file documents `Directory` and access control options for Apache in this project.

## Notes

1. `Options All` is convenient for local development, but it is broad.
   - For documentation, it is useful to note that `Options All` enables all directory options, including some that may not be needed.
   - When writing configs for production or more controlled environments, explicit options are safer.

2. Recommended local development options
   - `Options Indexes FollowSymLinks`
   - `AllowOverride All`
   - `Require all granted`

3. What each option means
   - `Indexes`: allows directory listings when no index file is present.
   - `FollowSymLinks`: allows following symbolic links.
   - `AllowOverride All`: allows `.htaccess` files to override directory-level settings.
   - `Require all granted`: allows all clients to access this directory.

4. Use these notes for documentation, not to enforce stricter local rules.
   - For this repo, local-only setup is acceptable.
   - Documentation should still explain the risks and alternatives.

## Official documentation

- `<Directory>` directive: https://httpd.apache.org/docs/current/mod/core.html#directory
- `Options` directive: https://httpd.apache.org/docs/current/mod/core.html#options
- `AllowOverride` directive: https://httpd.apache.org/docs/current/mod/core.html#allowoverride
- `Require` directive: https://httpd.apache.org/docs/current/mod_authz_core.html#require
