
include:
  - erpel

shibboleth:
  pkg:
    - installed
    - require:
      - pkgrepo: erpel

shibd:
  service:
    - running
    - enable: True
    - reload: True
    - require:
      - pkg: shibboleth

/etc/shibboleth/shibboleth2.xml:
  file.managed:
    - source: salt://shibboleth/shibboleth2.xml
    - user: shibd
    - group: shibd
    - mode: 644
    - template: jinja
    - require:
      - pkg: shibboleth
    - watch_in:
      - service: shibboleth

/etc/shibboleth/attribute-map.xml:
  file.managed:
    - source: salt://shibboleth/attribute-map.xml
    - user: shibd
    - group: shibd
    - mode: 644
    - require:
      - pkg: shibboleth

/etc/shibboleth/aaf-metadata-cert.pem:
  file.managed:
    - source: https://ds.aaf.edu.au/distribution/metadata/aaf-metadata-cert.pem
    - source_hash: sha256=18de1f447181033c2b91726919f51d21214f36bb450eb5988d3ebb19cd2e9ec5
    - user: shibd
    - group: shibd
    - mode: 644
    - require:
      - pkg: shibboleth

/etc/shibboleth/sp-cert.pem:
  file.managed:
    - contents_pillar: shibboleth:sp_crt
    - user: shibd
    - group: shibd
    - mode: 644
    - require:
      - pkg: shibboleth
    - require_in:
      - service: shibboleth

/etc/shibboleth/sp-key.pem:
  file.managed:
    - name:
    - contents_pillar: shibboleth:sp_key
    - user: shibd
    - group: shibd
    - mode: 600
    - require:
      - pkg: shibboleth
    - require_in:
      - service: shibboleth
