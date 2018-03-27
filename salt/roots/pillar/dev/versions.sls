
versions:
    celery: 3.1.25
    kombu: 3.0.37
    billiard: 3.3.0.23
    amqp: 1.4.9
    zc.buildout: 2.9.5
    numpy: 1.9.1
    matplotlib: 1.4.2
    gunicorn: 19.3.0
    futures: 3.0.3
    dropbox: 8.7.1
    google-api-python-client: 1.4.1
    raven: 6.3.0
    pip: 9.0.1
    # setuptools >= 38.2.0 support installing wheels,
    #                      but zc.buildout 2.9.5 doesn't handle that behaviour
    setuptools: 38.1.0
    # nose and mock only used by visualiser
    nose: 1.3.4
    mock: 1.0.1
    # GDAL python bindings
    GDAL: 1.9.1
    # The following are branch names or tags
    org.bccvl.tasks: develop
    org.bccvl.movelib: develop
    plone: develop
    visualiser: develop
    data_mover: develop
