include:
  - pgdg

proj:
  pkg:
    - installed
    - require:
      - pkg: pgdg-release

proj-devel:
  pkg:
    - installed
    - require:
      - pkg: pgdg-release

proj-epsg:
  pkg:
    - installed
    - require:
      - pkg: pgdg-release

proj-nad:
  pkg:
    - installed
    - require:
      - pkg: pgdg-release
