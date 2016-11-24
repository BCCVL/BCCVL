include:
  - geos
  - gdal
  - proj4
  - libpng
  - gcc
  - make


# bitops_1.0-6
# gtools_3.4.0
# gdata_2.13.3
# caTools_1.17
# xts_0.9.7
# intervals_0.14.0
# gplots_2.13.0
# spacetime_1.1.0
# FNN_1.1
# tkrplot_0.0-23
# shapefiles_0.7.tar.gz
# foreach_1.4.2.tar.gz
# iterators_1.0.7
# snow_0.3-13
# Formula_1.1-1
# rJava_0.9-6
# XML_3.98-1.1
# ROCR_1.0-5
# deldir_0.1-5
# gstat_1.0-19
# kernlab_0.9-19
# maptools_0.8-29
# adehabitat_1.8.14
# RUnit_0.4.26
# microbenchmark_1.3-0
# logcondens_2.1.1
# doMC_1.3.3
# doSNOW_1.0.12
# ade4_1.6-2
# Hmisc_3.14-4
{% set rpkgs = [
    {'name': 'FNN',           'version': '1.1',     'hash': 'ac5c9025e3eb3b6323c7e785191b1e087801442d'},
    {'name': 'KernSmooth',    'version': '2.23-15', 'hash': 'c6b35fe9117d2a6eccff097072ec9066bea0fffc'},
    {'name': 'MASS',          'version': '7.3-45',  'hash': '2e3c97b2b9d5d91c67b2da8cca42a71b2e86d1fc'},
    {'name': 'Matrix',        'version': '1.2-3',   'hash': '264c309b91f81df4e6f0b00b58c17b481376bb08'},
    {'name': 'R.methodsS3',   'version': '1.7.1',   'hash': '75a9b2872030f9e6ef8c321de7132ae759e0deef'},
    {'name': 'R.oo',          'version': '1.20.0',  'hash': '27a6ebf8e68c71262d6244cc46c26f2990a25226'},
    {'name': 'R.utils',       'version': '2.2.0',   'hash': 'c2e1c3f6df21bbbb5d0d9598eaf24a8f0312e61e'},
    {'name': 'R2HTML',        'version': '2.3.1',   'hash': '35226853de2dbeb3fe6a3969b62ed98fbcf0292a'},
    {'name': 'RColorBrewer',  'version': '1.1-2',   'hash': 'ffe73355d888a62bcee6d25f6700c8a8fa6464d8'},
    {'name': 'Rcpp',          'version': '0.12.3',  'hash': 'c519915794f554cb9de0061d8adc24928d3ef127'},
    {'name': 'SDMTools',      'version': '1.1-221', 'hash': '4eefdf32f498f254c5a940e94d0fd3dbee1b570e'},
    {'name': 'abind',         'version': '1.4-3',   'hash': '9b1e66e3a4368aaa4244224dce5bfe67adbbf7d8'},
    {'name': 'biomod2',       'version': '3.1-64',  'hash': '1f378ea62d8b3f55ec55b4a9818d251388db1ef4'},
    {'name': 'boot',          'version': '1.3-17',  'hash': '5e1fa4be310c35cda8a442f333b268a222f597bc'},
    {'name': 'class',         'version': '7.3-14',  'hash': '9376f106ae4865f70a46d8e4bea33c98a3404734'},
    {'name': 'cluster',       'version': '2.0.3',   'hash': '6a0cc31a2affe1ced97833c9f8a85b7010ca2486'},
    {'name': 'codetools',     'version': '0.2-14',  'hash': 'a28ad42d9440a31280ac46b68e317a9ac6927bfe'},
    {'name': 'colorspace',    'version': '1.2-6',   'hash': '24746b3de8bf74b167c222f1180b3ccd995d41fe'},
    {'name': 'deldir',        'version': '0.1-9',   'hash': 'd49b1ab9d3a9fb4c3b05cde1ab4060c5fa6240dd'},
    {'name': 'dichromat',     'version': '2.0-0',   'hash': '37aa8221aedb9b004decf7a1022a266ab7a0342e'},
    {'name': 'digest',        'version': '0.6.9',   'hash': '77bfa32ebde733b0faad10f489ef15bcd83f92a9'},
    {'name': 'dismo',         'version': '1.0-15',  'hash': 'a9a3434733adffdd5a7560a14a22d5ef469fe8dd'},
    {'name': 'doParallel',    'version': '1.0.10',  'hash': 'efc606d319c45386be00e3c3324689a233956986'},
    {'name': 'evaluate',      'version': '0.8',     'hash': '899029c06332ba6197477f16d3cf600767ecf2cb'},
    {'name': 'foreach',       'version': '1.4.3',   'hash': '5cd10fcdfa79539a1c9f04bf0842d7a2ecc6eb83'},
    {'name': 'foreign',       'version': '0.8-66',  'hash': 'ab83d1551d17d1f63b3937e9485a3ee3fb71a123'},
    {'name': 'gam',           'version': '1.12',    'hash': 'f4ed16fe528e6e1e0bf06a3542758abc75ad24b0'},
    {'name': 'gamlss',        'version': '4.3-8',   'hash': '851c17137dac2b374c8f8546919242cf8afa843f'},
    {'name': 'gamlss.data',   'version': '4.3-2',   'hash': '8f0a7d30cd30ec125f006e6712f70bf4ade95151'},
    {'name': 'gamlss.dist',   'version': '4.3-5',   'hash': '4f102d46a701ec9592f205a69ecda80498e9619d'},
    {'name': 'gbm',           'version': '2.1.1',   'hash': 'b6559a9974e55388aa30613c028df13263869263'},
    {'name': 'gdalUtils',     'version': '2.0.1.7', 'hash': '412fe40012ee91ea7e82f9693e58e1096275f707'},
    {'name': 'ggplot2',       'version': '2.0.0',   'hash': '9b409c22a474c9db85db7c91c4a516802cd663b0'},
    {'name': 'gridExtra',     'version': '2.2.0',   'hash': 'cb626c7ff4b3cec0c1139d48094d9765280c5f0f'},
    {'name': 'gstat',         'version': '1.1-2',   'hash': '1c1770159afd40238d790b8dddad00256fabdfc5'},
    {'name': 'gtable',        'version': '0.2.0',   'hash': '60fb0214fa0a94f864c7400c689159769c6e9880'},
    {'name': 'hexbin',        'version': '1.27.1',  'hash': '75dc504231965da0cd91498e86bf488fbb7abaae'},
    {'name': 'intervals',     'version': '0.15.1',  'hash': '33a5e484559af70e1b2be396c058baeaf43405a9'},
    {'name': 'iterators',     'version': '1.0.8',   'hash': 'f381e093e7120ac406cee58d8663633ada53a9bf'},
    {'name': 'labeling',      'version': '0.3',     'hash': 'fb3328f5c876aabdfb47447a1c73de932e751bc6'},
    {'name': 'lattice',       'version': '0.20-33', 'hash': 'c1d43597a1478c7d5ad48a646d2ce1438b24f0dc'},
    {'name': 'latticeExtra',  'version': '0.6-28',  'hash': 'aa69ca76b26295a9fd1f037769725be74169703b'},
    {'name': 'magrittr',      'version': '1.5',     'hash': '174f9188eb2c87702c3ad28f19cf6250cda021f5'},
    {'name': 'mda',           'version': '0.4-8',   'hash': 'f74838a5ca3b35aa4c3a8ef504ceeac5095c03d4'},
    {'name': 'mgcv',          'version': '1.8-9',   'hash': '9b02857e08f10de91ddba9ba5d1aa70a26edd69f'},
    {'name': 'mmap',          'version': '0.6-12',  'hash': '4fa47408250d246eaa77a20496ba66460a31b011'},
    {'name': 'munsell',       'version': '0.4.3',   'hash': '2e9a3cd4a1f5c10e1abd7d4f6c6fa0cf7420bf00'},
    {'name': 'nlme',          'version': '3.1-122', 'hash': 'a8fca65fa1d2197e69e2a8ea76c3c2c8244dfa99'},
    {'name': 'nnet',          'version': '7.3-11',  'hash': '8b5d1687af4e1a655b8a6940c50f9e010de53314'},
    {'name': 'pROC',          'version': '1.8',     'hash': '4885d34ce8738b8a85bf9fb2276cd2d637ea263d'},
    {'name': 'plyr',          'version': '1.8.3',   'hash': '61e21401e64ba17407b548d9301d66522e18f713'},
    {'name': 'png',           'version': '0.1-7',   'hash': '433aeec293faa67d1024af80097c64578b837bf7'},
    {'name': 'proto',         'version': '0.3-10',  'hash': 'cf5132335b810d73e1e828ae04ce7f151f771051'},
    {'name': 'randomForest',  'version': '4.6-12',  'hash': 'd9c7c08b51efc5bc3f0562b503fe8e44b5ef75bc'},
    {'name': 'raster',        'version': '2.5-8',   'hash': 'ff364f42cceb2172edb2d51a94d3ba1fddf5e65e'},
    {'name': 'rasterVis',     'version': '0.37',    'hash': '25879fd73992c626df10badc7942492c39796178'},
    {'name': 'reshape',       'version': '0.8.5',   'hash': 'a7fb85caf9fc1f22b7caa238d0abb033534d0f68'},
    {'name': 'reshape2',      'version': '1.4.1',   'hash': '6e6328a0baf4dd24944f650ddf70030613aefb0a'},
    {'name': 'rgdal',         'version': '1.1-3',   'hash': '8e6fdd0bad7ecdd046236d2b7bc123a936b5e8d1'},
    {'name': 'rgeos',         'version': '0.3-17',  'hash': '17dd28d13c001c37c23e15992f8c724885626de3'},
    {'name': 'rjson',         'version': '0.2.15',  'hash': '230b4e4883226d3437f72331089774070112fef9'},
    {'name': 'rpart',         'version': '4.1-10',  'hash': 'f395e7316fe4a13cdfdebd7f3d1c40f10686509b'},
    {'name': 'scales',        'version': '0.4.0',   'hash': 'd19cfaad4bbcc9c6f20ea2b9161846b8bbbb5416'},
    {'name': 'sp',            'version': '1.2-2',   'hash': '5a783b17058b0fca59f6a341e9330c350e028016'},
    {'name': 'spacetime',     'version': '1.1-5',   'hash': 'e974d33b83a8f988865ab0a5bd0aae9f91305473'},
    {'name': 'spatial',       'version': '7.3-11',  'hash': 'c849dc91bb4a22185f0a5bed044f8fd3f2ed82e2'},
    {'name': 'spatial.tools', 'version': '1.4.8',   'hash': 'b9c0fc738485cf14c354b91ceb256fb9649ad28d'},
    {'name': 'stringi',       'version': '1.0-1',   'hash': 'b9fdcd23ae8950ea527574b74139ad74678b739f'},
    {'name': 'stringr',       'version': '1.0.0',   'hash': '1b135f1084752c3a094243f151e197a1dc0149f7'},
    {'name': 'survival',      'version': '2.38-3',  'hash': '23556bf5e4249dcefc5a16fcc25a0725af55fe1e'},
    {'name': 'xts',           'version': '0.9-7',   'hash': 'c398c823ef2e31d5342954cc654424f05c97c52a'},
    {'name': 'zoo',           'version': '1.7-12',  'hash': '73a7dc5152b21d4cd215c07a22f020b537c352c9'},
] %}

/home/bccvl/R_libs:
  file.directory:
    - user: bccvl
    - group: bccvl
    - mode: 700
    - require:
      - user: bccvl

# TODO: document the option to put the files onto master and serve via salt://worker/rlibs/<pkgtarfile>

{% set cranmirrors = ["http://cran.ms.unimelb.edu.au",
                      "http://mirror.aarnet.edu.au/pub/CRAN"] %}
{% for pkginfo in rpkgs %}
{% set name = pkginfo['name'] %}
{% set version = pkginfo['version'] %}
{% set hash = pkginfo['hash'] %}
{% set pkgtar = [name, "_", version, '.tar.gz']|join %}
{% set sources = [{['salt://worker/rlibs', pkgtar]|join("/"): hash},
                  {[cranmirrors[0], 'src/contrib', pkgtar]|join("/"): hash} ,
                  {[cranmirrors[0], 'src/contrib/Archive', name, pkgtar]|join("/"): hash},
                  {[cranmirrors[1], 'src/contrib', pkgtar]|join("/"): hash},
                  {[cranmirrors[1], 'src/contrib/Archive', name, pkgtar]|join("/"): hash}] %}
{% set salturl = ["salt://worker/rlibs/", pkgtar]|join %}
{% set tmppkgtar = ["/tmp/", pkgtar]|join %}

{{ tmppkgtar }}:
  file.managed:
    - source: {{ sources|json }}
    - source_hash: {{ hash }}
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: R_LIBS=/home/bccvl/R_libs R CMD INSTALL {{ tmppkgtar }}
    - unless: R_LIBS=/home/bccvl/R_libs R --slave -e 'if (!("{{ name }}" %in% installed.packages() && packageVersion("{{ name }}") == "{{ version }}")) { quit("no", 1) }'
    - user: bccvl
    - group: bccvl
    - require:
      - user: bccvl
      - pkg: R
      - file: {{ tmppkgtar }}
      - file: /home/bccvl/R_libs
{% endfor %}
