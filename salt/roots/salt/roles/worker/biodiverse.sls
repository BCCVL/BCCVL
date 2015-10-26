

include:
  - perl516
  - git

/home/bccvl/.cpan:
  file.directory:
    - user: bccvl
    - group: bccvl
    - mode: 750
    - require:
      - user: bccvl

/home/bccvl/.cpan/CPAN:
  file.directory:
    - user: bccvl
    - group: bccvl
    - mode: 750
    - require:
      - file: /home/bccvl/.cpan


/home/bccvl/.cpan/CPAN/MyConfig.pm:
  file.managed:
    - source: salt://worker/MyConfig.pm
    - user: bccvl
    - group: bccvl
    - mode: 0644


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

# Clone Biodiverse
biodiverse_source:
  file.directory:
    - name: /home/bccvl/biodiverse
    - user: bccvl
    - group: bccvl
    - require:
      - user: bccvl
  git.latest:
    - name: https://github.com/shawnlaffan/biodiverse.git
    - rev: r1.0
    - target: /home/bccvl/biodiverse
    - user: bccvl
    - require:
      - user: bccvl
      - file: biodiverse_source
      - pkg: git
    - watch_in:
      - cmd: Install biodiverse

Install biodiverse:
  cmd:
    - wait_script
    - source: salt://worker/install_biodiverse.sh
    - cwd: /home/bccvl
    - user: bccvl
    - group: bccvl
    #- stateful?
    - require:
      - file: /home/bccvl/.cpan/CPAN/MyConfig.pm
      - pkg: perl516-perl
      - pkg: Install Biodiverse deps

