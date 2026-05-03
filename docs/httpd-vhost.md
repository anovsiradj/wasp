# Apache HTTPD Virtual Hosts

This file documents best practices for Apache virtual hosts in this project.

## Notes

1. Each `<VirtualHost>` can use a different `DocumentRoot`.
   - This repository may use the same root value in examples, but the configuration must support distinct roots per host.
   - Keeping vhosts separate allows multiple applications or versions to coexist on different ports or names.

2. Log file locations can also differ per host.
   - Use a dedicated `ErrorLog` and `CustomLog` for each virtual host.
   - Naming logs after the port or hostname makes them easier to identify.

3. Separate the vhost file when possible.
   - Keeping `httpd_hosts.conf` modular or splitting host definitions into dedicated files reduces maintenance overhead.
   - This is especially useful when multiple sites or environments are defined.

4. Add `ServerName` for each host.
   - `ServerName` reduces warnings and improves host identification.
   - Example: `ServerName localhost:5080`

5. Document `Listen` rules clearly.
   - Use one `Listen` directive for each port and explain the port mapping.
   - This is important for local-only setups where ports represent PHP versions or separate sites.

## Official documentation

- Apache Virtual Hosts: https://httpd.apache.org/docs/current/vhosts/
- Name-based virtual hosts: https://httpd.apache.org/docs/current/vhosts/name-based.html
- Port-based virtual hosts: https://httpd.apache.org/docs/current/vhosts/examples.html#ipbased
