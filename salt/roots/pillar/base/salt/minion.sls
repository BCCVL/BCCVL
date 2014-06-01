{% import_yaml "variables.yml" as vars %}

salt:
  minion:
    master: {{ vars.monitor.hostname }}
    #module_config:
    #  test: True
    #  test.foo: foo
    #  test.bar:
    #    - baz
    #    - quo
    #  test.baz:
    #    spam: sausage
    #    cheese: bread
    #grains:
    #  set custom crain values to match against
    #  roles:
    #    - webserver
    #    - memcache
    #  deployment: datacenter4
    #  cabinet: 13
