maria_packages:
  pkg.installed:
    - pkgs:
      - mariadb100-server
      - mariadb100-client
  service.running:
    - name: mysql-server
    - enable: True
    - require:
      - pkg: mariadb100-server
    - watch:
      - file: /usr/local/etc/my.cnf

/usr/local/etc/my.cnf:
  file.managed:
    source: salt://mariadb/my.cnf
  
