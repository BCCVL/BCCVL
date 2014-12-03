include:
  - pgdg

geos:
  pkg:
    - installed
    - require:
      - pkg: pgdg-release

geos-devel:
  pkg:
    - installed
    - require:
      - pkg: pgdg-release
