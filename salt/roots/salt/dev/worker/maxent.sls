

/home/bccvl/maxent.jar:
  file.managed:
    - source: salt://worker/maxent.jar
    - user: bccvl
    - group: bccvl
    - mode: 440

Add MAXENT env:
  file.append:
    - name: /home/bccvl/.bashrc
    - text: |
        # BCCVL: set MAXENT env var for
        export MAXENT=$HOME/maxent.jar
