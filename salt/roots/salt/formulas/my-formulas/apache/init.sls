

httpd:
  pkg:
    - installed
  service:
    - running
    - enable: True

mod_ssl:
  pkg.installed:
    - watch_in:
      - service: httpd


