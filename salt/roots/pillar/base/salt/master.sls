{% import_yaml "variables.yml" as vars %}

salt:
  master:
    fileserver_backend:
      # - git
      - roots

    #gitfs_remotes:
      #- git://github.com/saltstack-formulas/salt-formula.git
      #- file://var/git/saltmaster

    file_roots:
      base:
        - /srv/salt/base
        - /srv/salt/formulas/salt-formula
      dev:
        - /srv/salt/dev
        - /srv/salt/roles
        - /srv/salt/formulas/users-formula
        - /srv/salt/formulas/epel-formula
        - /srv/salt/formulas/my-formulas
      qa:
        - /srv/salt/qa
        - /srv/salt/roles
        - /srv/salt/formulas/users-formula
        - /srv/salt/formulas/epel-formula
        - /srv/salt/formulas/my-formulas
      prod:
        - /srv/salt/prod
        - /srv/salt/roles
        - /srv/salt/formulas/users-formula
        - /srv/salt/formulas/epel-formula
        - /srv/salt/formulas/my-formulas

    pillar_roots:
      base:
        - /srv/pillar/base
      dev:
        - /srv/pillar/dev
        - /srv/pillar/qa
        - /srv/pillar/prod
        - /srv/pillar/base
      qa:
        - /srv/pillar/qa
        - /srv/pillar/prod
        - /srv/pillar/base
      prod:
        - /srv/pillar/prod
        - /srv/pillar/base

    #client_acl:
    #   hash of acls as in config
    #external_auth:
    #   pam:
    #     fred:
    #       - test.*
    #halite:
    # ... whatever halite wants

  # in case we run salt.minion as well, we'll have to setup master
  # here, otherwise saltstack-formula would take the salt.master
  # dictionary to set master: in minion.cfg
  minion:
    master: {{ vars.monitor.hostname }}
