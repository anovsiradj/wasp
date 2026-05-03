## Clean up Apache config — detailed suggestion

The current httpd_hosts.conf is functional, but it is overly repetitive and hard to maintain. The goals are:

1. reduce duplication
2. make the config portable
3. make PHP-version switching easier
4. keep Apache directives minimal and readable

---

### **[NOPE]** 1. Remove duplicated `DocumentRoot` / `<Directory>` blocks

Each virtual host currently has the same `DocumentRoot` and identical `<Directory>` block repeated twice in some hosts.

Suggested structure:

- one `DocumentRoot` per `<VirtualHost>`
- one `<Directory>` block per host
- no duplicate duplicate content

Example:
```apache
<VirtualHost *:5080>
    ServerName localhost:5080
    ErrorLog "${LOG_ROOT}/5080.log"
    CustomLog "${LOG_ROOT}/5080-custom.log" common

    UnsetEnv PHPRC
    FcgidInitialEnv PHPRC "${PHP80_ROOT}"
    FcgidWrapper "${PHP80_ROOT}/php-cgi.exe" .php

    DocumentRoot "${PROJECT_ROOT}"
    <Directory "${PROJECT_ROOT}">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

---

### **[NOPE]** 2. Use shared defines for common values

Put repeat values into httpd_envs.conf:

```apache
Define _ROOT "C:/waap"
Define HTTPD_ROOT "${_ROOT}/httpd"
Define PROJECT_ROOT "C:/projects"
Define LOG_ROOT "${HTTPD_ROOT}/logs"
```

Then use `${PROJECT_ROOT}` and `${LOG_ROOT}` everywhere. This makes path changes much easier.

---

### **[MAYBE]** 3. Convert repeated host blocks into a template pattern

Instead of hardcoding seven almost-identical vhosts, use a simpler pattern or split them into smaller files:

- `conf/vhosts/php5.conf`
- `conf/vhosts/php7.conf`
- `conf/vhosts/php80.conf`
- etc.

Or generate them from one template if you build automation later.

This is cleaner than one huge httpd_hosts.conf.

---

### 4. Keep httpd_fcgi.conf generic and only set version-specific wrapper in hosts

Right now httpd_fcgi.conf loads `mod_fcgid` and sets environment defaults. That is fine.

Then each vhost should only override:
- `FcgidInitialEnv PHPRC`
- `FcgidWrapper`

This isolates PHP version selection to the host config and avoids repeating FCGI global settings.

---

### 5. Use safer, less broad directory options

`Options All` is very permissive. For a development stack, prefer explicit options:

```apache
Options Indexes FollowSymLinks
AllowOverride All
Require all granted
```

This is clearer and reduces accidental behavior.

---

### 6. Add `ServerName` for each host

Even if you use `localhost`, adding:
```apache
ServerName localhost:5080
```
is useful for debugging and avoids warnings.

---

### 7. Simplify `Listen` rules if possible

If all ports are only for local dev, document them clearly and consider grouping them:

```apache
Listen 5080
Listen 5081
Listen 8200
...
```

But if several ports point to the same document root, ask whether you need all of them or just one per PHP version.

---

### Why this is useful

- Less repetition means fewer copy/paste mistakes.
- Fewer hardcoded blocks means easier future changes.
- Shared `Define` values improve portability from waap to another folder.
- Per-version vhosts become easier to add/remove.
- The config becomes readable for someone learning Apache on Windows.

If you want, I can also write a cleaned-up version of httpd_hosts.conf and httpd_envs.conf using these principles.