
https://wiki.debian.org/Apache

```sh
sudo apachectl configtest
sudo systemctl restart apache2

# yolo
sudo usermod -a -G anoop www-data
sudo usermod -a -G www-data anoop
# make shit easy
chmod g+rx /home/anoop

sudo ln -sf /home/anoop/srvp/php.ini /etc/php/7.4/fpm/conf.d/99-srvp.ini
sudo ln -sf /home/anoop/srvp/php.ini /etc/php/8.0/fpm/conf.d/99-srvp.ini
sudo ln -sf /home/anoop/srvp/php.ini /etc/php/8.1/fpm/conf.d/99-srvp.ini
sudo ln -sf /home/anoop/srvp/php.ini /etc/php/8.2/fpm/conf.d/99-srvp.ini
sudo ln -sf /home/anoop/srvp/php.ini /etc/php/8.3/fpm/conf.d/99-srvp.ini
sudo ln -sf /home/anoop/srvp/php.ini /etc/php/8.4/fpm/conf.d/99-srvp.ini
sudo ln -sf /home/anoop/srvp/php.ini /etc/php/8.5/fpm/conf.d/99-srvp.ini

ls -l /etc/php/*/fpm/conf.d/99-srvp.ini

id www-data
id anoop

find /srv/sagara/ -type d -exec chmod 755 {} +
find /srv/sagara/ -type f -exec chmod 644 {} +

sudo subl /etc/apache2/sites-available/000-default.conf
```
