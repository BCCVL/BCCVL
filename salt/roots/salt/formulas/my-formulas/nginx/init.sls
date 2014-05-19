


# make sure we install latest from nginx-release site
nginx-release-centos:
  pkg:
    - installed
    - sources:
      - nginx-release-centos: http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm


nginx:
  pkg.installed:
    - require:
      - pkg: nginx-release-centos
  service:
    - running
    - enable: True
    - restart: True
    - require:
      - pkg: nginx
    # - watch:
    #   - file: /etc/nginx/nginx.conf
    #   - file: /etc/nginx/conf.d/default.conf
    #   - file: /etc/nginx/conf.d/example_ssl.conf

# remove default configs

{% for filename in ('default', 'example_ssl') %}
/etc/nginx/conf.d/{{ filename }}.conf:
  file.absent:
  - require:
    - pkg: nginx
{% endfor %}
