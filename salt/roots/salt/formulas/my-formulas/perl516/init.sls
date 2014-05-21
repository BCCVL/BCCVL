include:
  - SCL

perl516-perl:
  pkg:
    - installed
    - require:
      - pkg: centos-release-SCL


perl516-perl-CPAN:
  pkg:
    - installed
    - require:
      - pkg: centos-release-SCL


perl516-perl-ExtUtils-MakeMaker:
  pkg:
    - installed
    - require:
      - pkg: centos-release-SCL


perl516-perl-Test-Simple:
  pkg:
    - installed
    - require:
      - pkg: centos-release-SCL
