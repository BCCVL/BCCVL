

erlang-solutions:
  pkgrepo.managed:
    - humanname: Centos $releasever - $basearch - Erlang Solutions
    - baseurl: http://packages.erlang-solutions.com/rpm/centos/$releasever/$basearch
    - gpgcheck: 1
    - gpgkey: http://packages.erlang-solutions.com/rpm/erlang_solutions.asc
    - enabled: 1


erlang:
  pkg.installed:
    - require:
      - pkgrepo: erlang-solutions
