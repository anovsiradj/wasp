
https://wiki.debian.org/Apache

```sh
sudo apachectl configtest
sudo systemctl restart apache2

sudo usermod -a -G anoop www-data
sudo usermod -a -G www-data anoop

sudo ln -sf /home/anoop/wasp/php.ini /etc/php/7.4/fpm/conf.d/99-wasp.ini
sudo ln -sf /home/anoop/wasp/php.ini /etc/php/8.0/fpm/conf.d/99-wasp.ini
sudo ln -sf /home/anoop/wasp/php.ini /etc/php/8.1/fpm/conf.d/99-wasp.ini
sudo ln -sf /home/anoop/wasp/php.ini /etc/php/8.2/fpm/conf.d/99-wasp.ini
sudo ln -sf /home/anoop/wasp/php.ini /etc/php/8.3/fpm/conf.d/99-wasp.ini
sudo ln -sf /home/anoop/wasp/php.ini /etc/php/8.4/fpm/conf.d/99-wasp.ini
sudo ln -sf /home/anoop/wasp/php.ini /etc/php/8.5/fpm/conf.d/99-wasp.ini

ls -l /etc/php/*/fpm/conf.d/99-wasp.ini

id www-data
id anoop

find /srv/sigap/ -type d -exec chmod 755 {} +
find /srv/sigap/ -type f -exec chmod 644 {} +

sudo subl /etc/apache2/sites-available/000-default.conf
```
