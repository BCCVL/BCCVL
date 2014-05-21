

include:
  - perl516

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


Enable Perl SCL:
  file.append:
    - name: /home/bccvl/.bashrc
    - text: |
        # BCCVL: enable perl 5.16 for this user
        source /opt/rh/perl516/enable
        export X_SCLS="$(scl enable perl516 'echo $X_SCLS')"


Install biodiverse:
  cmd:
    - script
    - source: salt://worker/install_biodiverse.sh
    - cwd: /home/bccvl
    - user: /home/bccvl
    - group: /home/bccvl
    #- stateful?
    - unless: test -d /home/bccvl/biodiverse
    - require:
      - pkg: perl516-perl
      - pkg: Install Biodiverse deps
      - file: Enable Perl SCL
