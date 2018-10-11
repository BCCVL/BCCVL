

erlang-solutions:
  pkgrepo.managed:
    - humanname: Centos $releasever - $basearch - Erlang Solutions
    - baseurl: http://packages.erlang-solutions.com/rpm/centos/$releasever/$basearch
    - gpgcheck: 0
    - gpgkey: http://packages.erlang-solutions.com/rpm/erlang_solutions.asc
    - enabled: 1

allow-obsolete:
  file.replace:
    - append_if_not_found: True
    - name: /etc/yum.conf
    - pattern: 'obsoletes=.*'
    - repl: 'obsoletes=0'

erlang:
  pkg.installed:
    - version: "20.3.8.7-1.el6"
    - require:
      - pkgrepo: erlang-solutions
      - file: allow-obsolete
