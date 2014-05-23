


######################### logstash

java-1.7.0-openjdk:
  pkg.installed


elasticsearch-1.1:
  pkgrepo.managed:
    - humanname: Elasticsearch repository for 1.1.x packages
    - baseurl: http://packages.elasticsearch.org/elasticsearch/1.1/centos
    - gpgcheck: 1
    - gpgkey: http://packages.elasticsearch.org/GPG-KEY-elasticsearch
    - enabled: 1

logstash-1.4:
  pkgrepo.managed:
    - humanname: Logstash repository for 1.5.x packages
    - baseurl: http://packages.elasticsearch.org/logstash/1.4/centos
    - gpgcheck: 1
    - gpgkey: http://packages.elasticsearch.org/GPG-KEY-elasticsearch
    - enabled: 1

elasticsearch:
  pkg:
    - installed
    - require:
      - pkgrepo: elasticsearch-1.1
  service:
    - running
    - enable: True
    - require:
      - pkg: elasticsearch

# listen only on localhost
/etc/elasticsearch/elasticsearch.yml:
  file:
    - append
    - text: |
        network.host: 127.0.0.1
    - require:
      - pkg: elasticsearch
    - watich_in:
      - service: elasticsearch


logstash:
  pkg:
    - installed
    - require:
      - pkgrepo: logstash-1.4
  service:
    - running
    - enable: True
    - require:
      - pkg: logstash

/etc/logstash/conf.d/monitor.conf:
  file.managed:
    - user: root
    - group: root
    - file_mode: 600
    - source: salt://monitor/logstash_monitor.conf
    - require:
      - pkg: logstash
    - watch_in:
      - service: logstash

/tmp/kibana-3.0.1.tar.gz:
  file.managed:
    - source: https://download.elasticsearch.org/kibana/kibana/kibana-3.0.1.tar.gz
    - source_hash: sha1=dd6c51735dfdf129c1f0dd5fd38893cc1459cbb2

/var/www/kibana:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
  cmd.run:
    - name: tar xz --strip=1 -C /var/www/kibana -f /tmp/kibana-3.0.1.tar.gz
    - unless: test -f /var/www/kibana/config.js
    - require:
      - file: /var/www/kibana
      - file: /tmp/kibana-3.0.1.tar.gz

/var/www/kibana/config.js:
  file.replace:
    - pattern: "^(\\s*)elasticsearch:.*,$"
    - repl: "\\1elasticsearch: \"https://192.168.100.100\","
    - require:
      - cmd: /var/www/kibana
