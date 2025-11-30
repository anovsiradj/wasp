# httpd (Apache HTTP Server)

### persiapan

- unduh `httpd.zip` dari https://www.apachelounge.com/download/
- lalu ekstrak ke dalam folder `./httpd/`
- unduh `mod_fcgid.zip` dari https://www.apachelounge.com/download/
- lalu ekstrak `mod_fcgid.so` ke dalam folder ke `./httpd/modules/`

### kebutuhan module

- `access_compat_module` (opsional), supaya bisa pake fitur lawas `[deny,allow]` pada httpd terbaru, untuk kebutuhan legacy project.
- `rewrite_module`
- `expires_module`
- `headers_module`
- `cache_module`
- `http2_module` (opsional), untuk performa dan optimasi.

(untuk kebutuhan module bisa disesuaikan kasuka)

### konfigurasi utama `./httpd/conf/httpd.conf`

- awalan tambah `Include conf/httpd_envs.conf`
- cari dan ubah jadi `Define SRVROOT "${HTTPD_ROOT}"`
- cari dan ubah jadi `ServerAdmin "${SERVER_MAIL}"`
- cari dan ubah jadi `ServerName "${SERVER_HOST}"`
- cari dan ubah jadi `LogLevel notice`
- cari dan ubah jadi `DirectoryIndex index.html index.php`
- cari dan komen `Listen 80`
- akhiran tambah `Include conf/httpd_fcgi.conf`
- akhiran tambah `Include conf/httpd_hosts.conf`

### konfigurasi http2 `./httpd/conf/httpd.conf`

semua akhiran dibawah dilakukan sebelum akhiran `Include */*.conf` dari konfigurasi utama.

- akhiran tambah `Protocols h2c http/1.1 h2`
- akhiran tambah `ProtocolsHonorOrder On`

### eksekusi console

httpd bisa dieksekusi langsung melalui console secara manual

```cmd
C:\wasp\httpd\bin\httpd.exe -t
C:\wasp\httpd\bin\httpd.exe
```

### instalasi service

supaya httpd bisa dieksekusi otomatis, perlu dilakukan instalasi service.
kemungkinan perlu dijalankan dengan `runAsAdmin`.

```cmd
C:\wasp\httpd\bin\httpd.exe -k install -n "wasp_httpd"
C:\wasp\httpd\bin\httpd.exe -n "wasp_httpd" -t
C:\wasp\httpd\bin\httpd.exe -k uninstall -n "wasp_httpd"

C:\wasp\httpd\bin\httpd.exe -k start -n "wasp_httpd"
C:\wasp\httpd\bin\httpd.exe -k restart -n "wasp_httpd"
C:\wasp\httpd\bin\httpd.exe -k stop -n "wasp_httpd"
```

(untuk penamaan service `wasp_httpd` bisa disesuaikan kasuka)

### pustaka

penyedia binary disarankan menggunakan apachelounge, dikarenakan apachehaus sedang hiatus.

- https://forum.apachehaus.com/announcements/apache-haus-project-is-on-hold/msg4727/#msg4727
- https://forum.apachehaus.com/index.php?topic=1761.msg4799#msg4799

panduan http2, sayangnya belum http3.

- https://httpd.apache.org/docs/2.4/howto/http2.html
- https://httpd.apache.org/docs/current/platform/windows.html#winsvc
- https://gist.github.com/cmbaughman/0e14f5796e7f73616e0c9824d0901135
