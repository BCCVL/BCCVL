

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

erlang-examples:
  pkg.removed:
    - version: "18.1-1.el6"

erlang-gs:
  pkg.removed:
    - version: "18.1-1.el6"

erlang-percept:
  pkg.removed:
    - version: "18.1-1.el6"

erlang-ose:
  pkg.removed:
    - version: "18.1-1.el6"

erlang:
  pkg.installed:
    - version: "20.3.8.7-1.el6"
    - require:
      - pkgrepo: erlang-solutions
      - file: allow-obsolete
      - pkg: erlang-examples
      - pkg: erlang-gs
      - pkg: erlang-percept
      - pkg: erlang-ose
