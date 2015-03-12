maria_packages:
  pkg.installed:
    - pkgs:
      - mariadb100-server
      - mariadb100-client

maria:
  service.running:
    - name: mysql-server
    - enable: True
    - require:
      - pkg: maria_packages
    - watch:
      - file: /usr/local/etc/my.cnf

/usr/local/etc/my.cnf:
  file.managed:
    - source: salt://mariadb/my.cnf
  
