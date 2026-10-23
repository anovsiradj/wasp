
https://wiki.debian.org/AdditionalPHPVersions

```sh
php8.4 -m
php8.4 --ini

sudo apt install php8.4-bcmath
sudo apt install php8.4-common
sudo apt install php8.4-curl
sudo apt install php8.4-exif
sudo apt install php8.4-gd
sudo apt install php8.4-intl
sudo apt install php8.4-mysql
sudo apt install php8.4-pgsql
sudo apt install php8.4-phar
sudo apt install php8.4-sqlite3
sudo apt install php8.4-xml
sudo apt install php8.4-zip

sudo phpenmod mbstring

sudo subl /etc/php/8.4/cli/php.ini

sudo systemctl restart php8.4-fpm

php8.4 ~/wasp/composer/composer.phar install
```
