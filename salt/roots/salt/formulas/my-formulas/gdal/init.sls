include:
  - pgdg

gdal:
  pkg:
    - installed
    - require:
      - pkg: pgdg-release

gdal-devel:
  pkg:
    - installed
    - require:
      - pkg: pgdg-release
