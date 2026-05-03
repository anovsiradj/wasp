# Apache HTTPD FastCGI (mod_fcgid)

This file documents FastCGI configuration and options for Apache in this project.

## Notes

1. Keep the `httpd_fcgi.conf` settings generic.
   - Load `mod_fcgid` once, and set common FastCGI options globally.
   - Version-specific PHP selection should remain in the virtual host definitions.

2. `mod_fcgid` settings to document:
   - `FcgidInitialEnv PHP_FCGI_CHILDREN 0`
   - `FcgidInitialEnv PHP_FCGI_MAX_REQUESTS 0`
   - `FcgidInitialEnv PHPIniDir "${_ROOT}"`
   - `FcgidInitialEnv PHP_INI_SCAN_DIR "${_ROOT}"`
   - `FcgidInitialEnv TMP "${_ROOT}/tmp"`
   - `FcgidInitialEnv TEMP "${_ROOT}/tmp"`
   - `FcgidMaxRequestLen` controls the maximum request body size.
   - `FcgidIOTimeout` and `FcgidConnectTimeout` control request and connection timeouts.
   - `FcgidOutputBufferSize` controls buffering of PHP output.

3. In the host config, override only the PHP wrapper and environment:
   - `UnsetEnv PHPRC`
   - `FcgidInitialEnv PHPRC "${PHP80_ROOT}"`
   - `FcgidWrapper "${PHP80_ROOT}/php-cgi.exe" .php`

4. Why this separation matters
   - Global FastCGI settings define runtime behavior for all PHP hosts.
   - Host-specific `FcgidWrapper` allows multiple PHP versions to run side by side.
   - This keeps PHP version switching simple and avoids duplicate global settings.

## Official documentation

- mod_fcgid documentation: https://httpd.apache.org/mod_fcgid/
- mod_fcgid configuration directives: https://httpd.apache.org/mod_fcgid/mod/mod_fcgid.html
- Apache modules overview: https://httpd.apache.org/docs/current/mod/
