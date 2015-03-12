apache24:
  pkg:
    - installed
  service.running:
    - enable: true

apache24_main_config:
  file.managed:
    - name: /usr/local/etc/apache24/httpd.conf
    - source: salt://webserver/httpd.conf

deflate_config:
  file.managed:
    - name: /usr/local/etc/apache24/Includes/mod_deflate.conf
    - source: salt://webserver/Includes/mod_deflate.conf

mpm_config:
  file.managed:
    - name: /usr/local/etc/apache24/extra/httpd-mpm.conf
    - source: salt://webserver/extra/httpd-mpm.conf

vhost_default_remove:
  file.absent:
    - name: /usr/local/etc/apache24/extra/httpd-vhosts.conf

tag1_site:
  file.managed:
    - name: /usr/local/etc/apache24/Includes/d8dev.conf
    - source: salt://webserver/Includes/d8dev.conf

php_packages:
  pkg.latest:
    - pkgs:
      - mod_php56
      - php56
      - php56-bcmath
      - php56-bz2
      - php56-ctype
      - php56-curl
      - php56-dom
      - php56-exif
      - php56-extensions
      - php56-fileinfo
      - php56-filter
      - php56-gd
      - php56-gettext
      - php56-gmp
      - php56-hash
      - php56-iconv
      - php56-json
      - php56-mbstring
      - php56-mcrypt
      - php56-mysql
      - php56-mysqli
      - php56-opcache
      - php56-openssl
      - php56-pdo
      - php56-pdo_mysql
      - php56-pdo_sqlite
      - php56-phar
      - php56-posix
      - php56-pspell
      - php56-readline
      - php56-session
      - php56-shmop
      - php56-simplexml
      - php56-sqlite3
      - php56-sysvmsg
      - php56-sysvsem
      - php56-sysvshm
      - php56-tokenizer
      - php56-wddx
      - php56-xml
      - php56-xmlreader
      - php56-xmlrpc
      - php56-xmlwriter
      - php56-xsl
      - php56-zip
      - php56-zlib

php_module_config:
  file.managed:
    - name: /usr/local/etc/php/opcache.ini
    - source: salt://webserver/php/opcache.ini

php_config:
  file.managed:
    - name: /usr/local/etc/php.ini-production
    - source: salt://webserver/php.ini-production

/usr/local/etc/php.ini:
  file.symlink:
    - target: /usr/local/etc/php.ini-production

