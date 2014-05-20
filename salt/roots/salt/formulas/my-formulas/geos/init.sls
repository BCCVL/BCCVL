include:
  - elgis

geos:
  pkg:
    - installed
    - require:
      - pkg: elgis-release

geos-devel:
  pkg:
    - installed
    - require:
      - pkg: elgis-release
