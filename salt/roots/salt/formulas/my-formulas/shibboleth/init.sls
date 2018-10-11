
shibboleth:
  pkg:
    - installed

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
    - source:  https://md.aaf.edu.au/aaf-metadata-certificate.pem
    - source_hash: sha256=00ec963039ca877b7111db3188d3d646e071c4c84ab8201fc35ad62a77ffa1a1
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
