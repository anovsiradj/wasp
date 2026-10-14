
https://wiki.debian.org/AdditionalPHPVersions

```sh
php8.5 -m
php8.5 --ini

sudo apt install php8.5-bcmath
sudo apt install php8.5-common
sudo apt install php8.5-curl
sudo apt install php8.5-exif
sudo apt install php8.5-gd
sudo apt install php8.5-intl
sudo apt install php8.5-mysql
sudo apt install php8.5-pgsql
sudo apt install php8.5-phar
sudo apt install php8.5-sqlite3
sudo apt install php8.5-xml
sudo apt install php8.5-zip

sudo phpenmod mbstring

sudo subl /etc/php/8.5/cli/php.ini

sudo systemctl restart php8.5-fpm

php8.5 ~/wasp/composer/composer.phar install
```
