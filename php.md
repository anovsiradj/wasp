# php

copas dari `./php.ini.stub` jadi `./php.ini`,
itu digunakan sebagai shared-config untuk semua versi.

file `./php.ini` akan dimuat oleh httpd:fcgi ketika server dijalankan,
yang bisa dicek lewat `phpinfo()`.

### persiapan

- akses `https://windows.php.net/download/`
- unduh binary setiap versi yang dibutuhkan, pilih yang NTS (non-thread-safe).
- ekstrak ke `./` dengan penamaan folder `php` atau dengan tambahan suffix versinya (contoh `php74`).
- copas dari `./php/php.ini-development` jadi `./php/php.ini`  lalu atur setiap versinya
- hapus komen `extension_dir` setiap versinya

### kebutuhan extension

- `curl`
- `intl`
- `gd` atau `gd2`
- `exif`
- `fileinfo`
- `mbstring`
- `openssl`
- `odbc`
- `pgsql`
- `mysql`
- `mysqli`
- `sqlite3`
- `pdo`
- `pdo_odbc`
- `pdo_mysql`
- `pdo_pgsql`
- `pdo_sqlite`
- `zip`

### catatan

- pada `./php.ini` penulisan konfigurasi, jangan pake spasi sebelum dan sesudah "=" karena tidak jalan di php5.
- pada `./php.ini` awalan file jangan kasih komen, entah kenapa jadi gak jalan.
- khusus php5 untuk windows 10 keatas, harus pasang `winget install -e --id Microsoft.VCRedist.2012.x64`
- khusus php8 keatas atau windows 11 keatas, harus pasang `winget install -e --id Microsoft.VCRedist.2015+.x64`

### referensi

- https://windows.php.net/downloads/releases/archives/
- https://museum.php.net/
- https://mlocati.github.io/articles/php-windows-imagick.html
