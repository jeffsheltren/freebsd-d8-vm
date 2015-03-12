/usr/local/sbin/staticalize_site.sh:
  file.managed:
    - source: salt://static/staticalize_site.sh
    - user: root
    - group: root
    - mode: 755
