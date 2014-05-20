include:
  - elgis

gdal:
  pkg:
    - installed
    - require:
      - pkg: elgis-release

gdal-devel:
  pkg:
    - installed
    - require:
      - pkg: elgis-release
