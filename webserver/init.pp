apache24:
  pkg:
    - installed
  file.managed:
    - name: /usr/local/etc/apache24/httpd.conf
    - source: salt://webserver/httpd.conf
  service.running:
    enabled: true

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
      - php56-imap
      - php56-interbase
      - php56-json
      - php56-ldap
      - php56-mbstring
      - php56-mcrypt
      - php56-mysql
      - php56-mysqli
      - php56-opcache
      - php56-openssl
      - php56-pcntl
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
      - php56-snmp
      - php56-soap
      - php56-sockets
      - php56-sqlite3
      - php56-sysvmsg
      - php56-sysvsem
      - php56-sysvshm
      - php56-tidy
      - php56-tokenizer
      - php56-wddx
      - php56-xml
      - php56-xmlreader
      - php56-xmlrpc
      - php56-xmlwriter
      - php56-xsl
      - php56-zip
      - php56-zlib
