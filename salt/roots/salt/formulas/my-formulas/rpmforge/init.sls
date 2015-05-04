
rpmforge-release:
  pkg.installed:
    - sources:
      - rpmforge-release: http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm


rpmforge:
  pkgrepo.managed:
    - repo: rpmforge
    - enabled: 0
    - require:
        - pkg: rpmforge-release
