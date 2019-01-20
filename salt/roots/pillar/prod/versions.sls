
versions:
    celery: 3.1.25
    kombu: 3.0.37
    billiard: 3.3.0.23
    amqp: 1.4.9
    zc.buildout: 2.12.2
    numpy: 1.9.1
    matplotlib: 1.4.2
    gunicorn: 19.3.0
    futures: 3.0.3
    dropbox: 8.7.1
    google-api-python-client: 1.4.1
    raven: 6.3.0
    pip: 18.1
    wheel: 0.32.2
    # setuptools >= 38.2.0 support installing wheels,
    #                      but zc.buildout 2.9.5 doesn't handle that behaviour
    setuptools: 40.6.2
    # nose and mock only used by visualiser
    nose: 1.3.4
    mock: 1.0.1
    # GDAL python bindings
    GDAL: 1.9.1
    # The following are branch names or tags
    # TODO: these are rather version pins for released packages
    #       need to check install for the components to build from package
    #       rather than git clone
    org.bccvl.tasks: 1.23.0
    org.bccvl.movelib: 1.13.0
    org.bccvl.site: 1.23.0
    org.bccvl.compute: 1.23.0
    org.bccvl.testsetup: 1.22.0
    org.bccvl.theme: 1.24.0
    plone: 1.21.0
    visualiser: 1.8.7
    data_mover: master
