

include:
  - perl516
  - subversion

Install Biodiverse deps:
  pkg:
    - installed
    - pkgs:
      - armadillo-devel
      - poppler-devel
      - freexl-devel
      - expat-devel
      - jasper-devel
      - netcdf-devel
      - giflib-devel
      - libgeotiff-devel
      - libgta-devel
      - cfitsio-devel
      - postgresql-devel
      - xz-devel
      - libdap-devel
      - libspatialite-devel
      - CharLS-devel
      - mysql-devel

Install biodiverse:
  cmd:
    - script
    - source: salt://worker/install_biodiverse.sh
    - cwd: /home/bccvl
    - user: bccvl
    - group: bccvl
    #- stateful?
    - unless: test -d /home/bccvl/biodiverse
    - require:
      - pkg: perl516-perl
      - pkg: Install Biodiverse deps

# TODO: maybe require subversion, make, gcc, etc... here as well
