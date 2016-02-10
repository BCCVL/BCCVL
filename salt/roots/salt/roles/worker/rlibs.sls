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
  {'name': 'rjson',        'version': '0.2.13',  'hash': 'sha1=6cc2aa36be15e2fb0e9b5ff60f65e30a7ccf0e1e'},
  {'name': 'sp',           'version': '1.0-15',  'hash': 'sha1=64d680802d958a5f52ba911bf03b388c88cfc7b7'},
  {'name': 'raster',       'version': '2.2-31',  'hash': 'sha1=023b75e695a0ebcee4de4367fb021dd1b204c8d2'},
  {'name': 'rgdal',        'version': '0.8-16',  'hash': 'sha1=99483734e8605f5424f6cba1835be837b166722f'},
  {'name': 'rgeos',        'version': '0.3-4',   'hash': 'sha1=dfc25bad67ea11ccb216aab62a5bbc67978bc11f'},
  {'name': 'gam',          'version': '1.09.1',    'hash': 'sha1=ec96fc02f7140978120d90c0fbeb97dafc825435'},
  {'name': 'Rcpp',         'version': '0.11.1',  'hash': 'sha1=5b0b658cf273d7a069a841b181596a31b9436ee3'},
  {'name': 'plyr',         'version': '1.8.1',   'hash': 'sha1=28435911667715950113104dbfa38a58667593d8'},
  {'name': 'pROC',         'version': '1.7.2',   'hash': 'sha1=577b75cd1e184e498fb3f989057abaff2991ce76'},
  {'name': 'R2HTML',       'version': '2.2.1',   'hash': 'sha1=a5d25643f2f452552be31b0b2a86a1bfe978624f'},
  {'name': 'png',          'version': '0.1-7',   'hash': 'sha1=433aeec293faa67d1024af80097c64578b837bf7'},
  {'name': 'survival',     'version': '2.37-7',  'hash': 'sha1=836c616b24ba807ccf22bc8fcfac6c25f896a39f'},
  {'name': 'lattice',      'version': '0.20-29', 'hash': 'sha1=ab7d97fd730226ef50b644b38d122b2a9a52bdf2'},
  {'name': 'gbm',          'version': '2.0-8',   'hash': 'sha1=137f931e65496e7705f627644b35bdbc862bf951'},
  {'name': 'stringr',      'version': '0.6.2',   'hash': 'sha1=6b41bcf589412a9b48ee6357508e35ccbbd77d01'},
  {'name': 'evaluate',     'version': '0.5.3',   'hash': 'sha1=7f47f48df6c8de2e4d10fab14e4cf4f5f546ba55'},
  {'name': 'dismo',        'version': '0.9-3',   'hash': 'sha1=a9a3434733adffdd5a7560a14a22d5ef469fe8dd'},
  {'name': 'R.methodsS3',  'version': '1.6.1',   'hash': 'sha1=30b4afdfb3fa9cf0fb0a062279317c4c577f6901' },
  {'name': 'R.oo',         'version': '1.18.0',  'hash': 'sha1=62d167beeb15764f4e6eae22a4cb82888ea7e66b'},
  {'name': 'R.utils',      'version': '1.29.8',  'hash': 'sha1=1bf1ac23a4af7bc6d1683280d739414cd871bab0'},
  {'name': 'SDMTools',     'version': '1.1-20',  'hash': 'sha1=7398f68250fd8f02825f07efe3ea0c760849676b'},
  {'name': 'abind',        'version': '1.4-0',   'hash': 'sha1=93df0b3f0a57b8cba424354e5ec9779fc1bb3240'},
  {'name': 'RColorBrewer', 'version': '1.0-5',   'hash': 'sha1=83ad459a240ab23d4c3f006f470435821d7cfb15'},
  {'name': 'latticeExtra', 'version': '0.6-26',  'hash': 'sha1=b3ffbce688ccabca143c9174c647f93edd23d7ab'},
  {'name': 'hexbin',       'version': '1.26.3',  'hash': 'sha1=844f863b1f4173ab92377cfa60dd88e0897cc169'},
  {'name': 'zoo',          'version': '1.7-11',  'hash': 'sha1=ea4318de677f78a56c97af465a91ada0131e823f'},
  {'name': 'rasterVis',    'version': '0.28',    'hash': 'sha1=65c2dc445b5271ed439635acc22751407f345993'},
  {'name': 'mda',          'version': '0.4-4',   'hash': 'sha1=7764f05774a462da11cfd3bbc4bffb876a307f79'},
  {'name': 'randomForest', 'version': '4.6-7',   'hash': 'sha1=01f5455d952627cd7a2a1a3977ccfa4005121e9f'},
  {'name': 'biomod2',      'version': '3.1-25',  'hash': 'sha1=38c99da0d44dd6ed1c08e90f87679996117e1da7'},
  {'name': 'nlme',         'version': '3.1-117', 'hash': 'sha1=144dc79d1b6297ba4a7dd6bd6f81c692998d06ee'},
  {'name': 'MASS',         'version': '7.3-33',  'hash': 'sha1=5b401b104c532b8c0e8812b5a5fa6142c050bbbc'},
  {'name': 'gamlss.dist',  'version': '4.3-0',   'hash': 'sha1=d68fa43637c9ac4f55f405a64b432aeff594757b'},
  {'name': 'gamlss.data',  'version': '4.2-7',   'hash': 'sha1=807983f57982c036d450c48d175b9f4a76481048'},
  {'name': 'gamlss',       'version': '4.3-0',   'hash': 'sha1=a78394a905a2e9d1ee2295f69eabd0d802a1bc3e'},
  {'name': 'intervals',    'version': '0.15.0',  'hash': 'sha1=cfa6062725b32696bc89ebf01c4f16157822986a'},
  {'name': 'xts',          'version': '0.9-7',   'hash': 'sha1=c398c823ef2e31d5342954cc654424f05c97c52a'},
  {'name': 'FNN',          'version': '1.1',     'hash': 'sha1=ac5c9025e3eb3b6323c7e785191b1e087801442d'},
  {'name': 'spacetime',    'version': '1.1-1',   'hash': 'sha1=71b083efb41edd7d50c6e20d88e3ae92391baed7'},
  {'name': 'gstat',        'version': '1.0-19',  'hash': 'sha1=0127f734d33f9766908e5638c0ae00c7c2b4bd98'},
  {'name': 'deldir',       'version': '0.1-6',   'hash': 'sha1=0c350e9c29470ef1dae3f40f893ca24663a12841'},
  {'name': 'digest',       'version': '0.6.4',   'hash': 'sha1=1a4a9efd9ae339d1778076b77b428203b6aadf78'},
  {'name': 'gtable',       'version': '0.1.2',   'hash': 'sha1=72bd4ad38e64bb801d622dbc48344897251cf537'},
  {'name': 'reshape2',     'version': '1.4',     'hash': 'sha1=36fb089df7745300d7875460aa47d82d8574e8ad'},
  {'name': 'dichromat',    'version': '2.0-0',   'hash': 'sha1=37aa8221aedb9b004decf7a1022a266ab7a0342e'},
  {'name': 'colorspace',   'version': '1.2-4',   'hash': 'sha1=2210f82e7126e68429c1581581369c588fded106'},
  {'name': 'munsell',      'version': '0.4.2',   'hash': 'sha1=4c225e23dbaf4c3740cbaa419a303a5fac1e216c'},
  {'name': 'labeling',     'version': '0.3',     'hash': 'sha1=fb3328f5c876aabdfb47447a1c73de932e751bc6'},
  {'name': 'scales',       'version': '0.2.4',   'hash': 'sha1=14ce2e1fad263e96c9e4a910eb1df4123c619a6c'},
  {'name': 'proto',        'version': '0.3-10',  'hash': 'sha1=cf5132335b810d73e1e828ae04ce7f151f771051'},
  {'name': 'ggplot2',      'version': '1.0.0',   'hash': 'sha1=2ff9bb37c385a3c10e90da75f886b6adfb977fac'},
  {'name': 'gridExtra',    'version': '2.0.0',   'hash': 'sha1=70bbe0f76f797396e8286ffa7e0fb7edbe545d50'},
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
