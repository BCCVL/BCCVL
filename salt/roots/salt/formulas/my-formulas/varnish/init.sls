
varnish_repository:
  pkg.installed:
    - sources:
      - varnish-release: http://repo.varnish-cache.org/redhat/varnish-3.0/el6/noarch/varnish-release/varnish-release-3.0-1.el6.noarch.rpm

varnish:
  pkg.installed:
    - require:
      - pkg: varnish_repository
  service:
    - running
    - enable: True
    - require:
      - pkg: varnish
