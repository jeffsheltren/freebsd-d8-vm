varnish:
  pkg.installed:
    - name: varnish
  service.running:
    - name: varnish
    - enable: True
    - reload: True
    - require:
      - pkg: varnish
      - file: /usr/local/etc/varnish/default.vcl
    - watch:
      - file: /usr/local/etc/varnish/default.vcl

/usr/local/etc/varnish/default.vcl:
  file.managed:
    - source: salt://varnish/default.vcl
