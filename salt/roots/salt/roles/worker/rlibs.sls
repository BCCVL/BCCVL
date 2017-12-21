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
    {'name': 'BH',            'version': '1.65.0-1', 'hash': '51e5b837df99bbce793472a06224e4cd2d842c72'},
    {'name': 'CVST',          'version': '0.2-1',   'hash': '82d8100ccbe51a0f600980c6991e2b6d0a4391bd'},
    {'name': 'DEoptimR',      'version': '1.0-8',   'hash': '3974d3642d4426fa2ee2093c13cae7aeba2dd70f'},
    {'name': 'DRR',           'version': '0.0.2',   'hash': 'bf72024918f9122493ed239880835678df18250a'},
    {'name': 'FNN',           'version': '1.1',     'hash': 'ac5c9025e3eb3b6323c7e785191b1e087801442d'},
    {'name': 'KernSmooth',    'version': '2.23-15', 'hash': 'c6b35fe9117d2a6eccff097072ec9066bea0fffc'},
    {'name': 'MASS',          'version': '7.3-47',  'hash': '95cbfde9ef54596ddf1cf5412f41dae70d52a932'},
    {'name': 'Matrix',        'version': '1.2-3',   'hash': '264c309b91f81df4e6f0b00b58c17b481376bb08'},
    {'name': 'MatrixModels',  'version': '0.4-1',   'hash': 'a5c3ba4361903ef19eaf4cbb31a14bf14ddb60ad'},
    {'name': 'ModelMetrics',  'version': '1.1.0',   'hash': 'b908275967ab58f97a3944d30cad2c9d86e7cef9'},
    {'name': 'NLP',           'version': '0.1-11',  'hash': 'd17727ad73bea96c17f2135d5c54e2ce8425d4c6'},
    {'name': 'PresenceAbsence', 'version': '1.1.9', 'hash': '122616a597d4fe3584bd35788bf26537262b14c6'},
    {'name': 'R.methodsS3',   'version': '1.7.1',   'hash': '75a9b2872030f9e6ef8c321de7132ae759e0deef'},
    {'name': 'R.oo',          'version': '1.21.0',  'hash': 'b19f76d0261d11bfe703e5f244746d0a221211d0'},
    {'name': 'R.utils',       'version': '2.6.0',   'hash': 'a7d3555cbcaf37848742fb1db41ed6ea0ff17c05'},
    {'name': 'R6',            'version': '2.2.2',   'hash': '79a34be63e9cf52844a2a9277967d7c31af6d51d'},
    {'name': 'RColorBrewer',  'version': '1.1-2',   'hash': 'ffe73355d888a62bcee6d25f6700c8a8fa6464d8'},
    {'name': 'Rcpp',          'version': '0.12.14',  'hash': '572c3ad6c67ad1b4f97e5d51fbaa2734bfab1027'},
    {'name': 'RcppEigen',     'version': '0.3.3.3.1', 'hash': '991a85952672c200b9172d44dd5fb4b006d51516'},
    {'name': 'RcppRoll',      'version': '0.2.2',   'hash': '64dfb12dbfdcadc9fbbeebce75fd9df3e7d44fe3'},
    {'name': 'SDMTools',      'version': '1.1-221', 'hash': '4eefdf32f498f254c5a940e94d0fd3dbee1b570e'},
    {'name': 'SparseM',       'version': '1.77',    'hash': 'bdd0b56a3e0cf8e8c1d45ce8878884e64a6f5212'},
    {'name': 'TeachingDemos', 'version': '2.10',    'hash': '81b71ebc3ce35794dd573e0ad8345548389cd026'},
    {'name': 'abind',         'version': '1.4-5',   'hash': '6b3d85631af7ab574f96c08a6d48ad8bfd281458'},
    {'name': 'assertthat',    'version': '0.2.0',   'hash': '53ac38c4449cad0c499ed07f5c332214371ce4a3'},
    {'name': 'bindr',         'version': '0.1',     'hash': '67347d42183252ae46fc8fbe5f01f8d86b754aa3'},
    {'name': 'bindrcpp',      'version': '0.2',     'hash': 'b3542f61941d45e99894e5b1b6d211cb2a2af2f3'},
    {'name': 'biomod2',       'version': '3.3-7',   'hash': '85d4e2baa6e8acde55970e7ce4ffcdb5ca3c4715'},
    {'name': 'boot',          'version': '1.3-17',  'hash': '5e1fa4be310c35cda8a442f333b268a222f597bc'},
    {'name': 'broom',         'version': '0.4.3',   'hash': '5a831fa1042abb3e9a1e96bde2f24b701450f6af'},
    {'name': 'car',           'version': '2.1-0',   'hash': 'c21c3d669dc522b66eef904013b28d869d09ca5e'},
    {'name': 'caret',         'version': '6.0-78',  'hash': '583c34c485eacfb8478108912a7a2a091d16fb2c'},
    {'name': 'class',         'version': '7.3-14',  'hash': '9376f106ae4865f70a46d8e4bea33c98a3404734'},
    {'name': 'cluster',       'version': '2.0.3',   'hash': '6a0cc31a2affe1ced97833c9f8a85b7010ca2486'},
    {'name': 'codetools',     'version': '0.2-14',  'hash': 'a28ad42d9440a31280ac46b68e317a9ac6927bfe'},
    {'name': 'colorspace',    'version': '1.3-2',   'hash': '40ed8aad9e2e622fa2a2f083ff3b3e123f4254e2'},
    {'name': 'ddalpha',       'version': '1.3.1',   'hash': '4552b1f08e1398077aeb1449d4bb1e765a16c0d1'},
    {'name': 'deldir',        'version': '0.1-14',  'hash': '5a29053b18ff8515478a7a7f0fbdfea60d0cbdc2'},
    {'name': 'dichromat',     'version': '2.0-0',   'hash': '37aa8221aedb9b004decf7a1022a266ab7a0342e'},
    {'name': 'digest',        'version': '0.6.13',  'hash': 'df754b101eb9e4ff099a95a7cb6d95d5d0e8c234'},
    {'name': 'dimRed',        'version': '0.1.0',   'hash': 'f01cbfcfafaf3e1a20bd5c4fc18c09ba5f9af256'},
    {'name': 'dismo',         'version': '1.1-4',   'hash': 'b194c36a7ed65fa5008832b6e056b3231933f3a3'},
    {'name': 'doParallel',    'version': '1.0.11',  'hash': '2d7ecb3408c94c555c4efc3717140da8cd8a3117'},
    {'name': 'dplyr',         'version': '0.7.4',   'hash': '4c0e4952c81d8229432d16c2a9dfeee947302c37'},
    {'name': 'earth',         'version': '4.6.0',   'hash': 'f4c17a941aba96e379a29df0d7fbfdb747d61ab6'},
    {'name': 'evaluate',      'version': '0.10.1',  'hash': '7cbf409b310687e055dbb86ae653c1fd8e1e1544'},
    {'name': 'foreach',       'version': '1.4.4',   'hash': '6030ba909b54ec60d1445d062b9b2a10d4ef2edd'},
    {'name': 'foreign',       'version': '0.8-69',  'hash': '4599708a2fb95c8129a64bf5cda84e033c35b57e'},
    {'name': 'gam',           'version': '1.14-4',  'hash': '097ae6f71aa9368b2f3ea12f9017f125594c8a56'},
    {'name': 'gamlss',        'version': '4.3-8',   'hash': '851c17137dac2b374c8f8546919242cf8afa843f'},
    {'name': 'gamlss.data',   'version': '4.3-2',   'hash': '8f0a7d30cd30ec125f006e6712f70bf4ade95151'},
    {'name': 'gamlss.dist',   'version': '4.3-5',   'hash': '4f102d46a701ec9592f205a69ecda80498e9619d'},
    {'name': 'gbm',           'version': '2.1.3',   'hash': '28c0e26ebb6721571cf7dd1317423deb39d715fd'},
    {'name': 'gdalUtils',     'version': '2.0.1.7', 'hash': '412fe40012ee91ea7e82f9693e58e1096275f707'},
    {'name': 'ggdendro',      'version': '0.1-20',  'hash': '085455b7ec35e5e39051c03332a17b82d2b80c50'},
    {'name': 'ggplot2',       'version': '2.2.1',   'hash': '07bedaacb6c2cf271eb2ba5ee310f1cc96f85f14'},
    {'name': 'glue',          'version': '1.2.0',   'hash': '0c4354cbfd529f2475d186bf7e3e22024561f2cc'},
    {'name': 'gower',         'version': '0.1.2',   'hash': 'c26038c4009d8428d01a1fa3dce5e0f4311c41c0'},
    {'name': 'gridExtra',     'version': '2.3',     'hash': '2c9e2c1bdc4e5c02d48de1cb4cb493f036621c4c'},
    {'name': 'gstat',         'version': '1.1-5',   'hash': '1367a0fb979e29db621772562c573df6e155d22d'},
    {'name': 'gtable',        'version': '0.2.0',   'hash': '60fb0214fa0a94f864c7400c689159769c6e9880'},
    {'name': 'hexbin',        'version': '1.27.1',  'hash': '75dc504231965da0cd91498e86bf488fbb7abaae'},
    {'name': 'intervals',     'version': '0.15.1',  'hash': '33a5e484559af70e1b2be396c058baeaf43405a9'},
    {'name': 'ipred',         'version': '0.9-6',   'hash': '1a2358ceb95dd6552250ad184fd5319d9356e975'},
    {'name': 'iterators',     'version': '1.0.9',   'hash': '71e5f9e62c897bb33b1ebaeedfed04ec269b5f47'},
    {'name': 'kernlab',       'version': '0.9-25',  'hash': 'c35344f797a1b3872e6fba26ac77f7de7f105c95'},
    {'name': 'labeling',      'version': '0.3',     'hash': 'fb3328f5c876aabdfb47447a1c73de932e751bc6'},
    {'name': 'lattice',       'version': '0.20-35', 'hash': 'df7ef01563e217ee3c1d6845d5badb7154e6bdac'},
    {'name': 'latticeExtra',  'version': '0.6-28',  'hash': 'aa69ca76b26295a9fd1f037769725be74169703b'},
    {'name': 'lava',          'version': '1.5.1',   'hash': 'f3c845fe5b2d33c767b336cc82a8f654771a1ac6'},
    {'name': 'lazyeval',      'version': '0.2.1',   'hash': '002606abdace20eda0be1004e71a1aab250d0577'},
    {'name': 'lme4',          'version': '1.1-14',  'hash': '3f419c84de92bce5b5d7d563c62205f3f4207276'},
    {'name': 'lubridate',     'version': '1.6.0',   'hash': '08b777d453bbf11d2016fd600781fe008bcc4e08'},
    {'name': 'magrittr',      'version': '1.5',     'hash': '174f9188eb2c87702c3ad28f19cf6250cda021f5'},
    {'name': 'maxent',        'version': '1.3.3.1', 'hash': '45c7c532490ccbab359128519b7eb49782952030'},
    {'name': 'mda',           'version': '0.4-10',  'hash': '2d4b55903f5268281a72a519efcd4fe1eaf961f2'},
    {'name': 'mgcv',          'version': '1.8-22',  'hash': 'af5bdd4e5062ca485a45d33b7be5b2f371ce81ac'},
    {'name': 'minqa',         'version': '1.2.4',   'hash': '1f61420fc334a73a079d6b2b8c39c552826ca7d5'},
    {'name': 'mmap',          'version': '0.6-15',  'hash': 'eb80330622448061b548a0391b99756d1cf65650'},
    {'name': 'mnormt',        'version': '1.5-5',   'hash': 'd15adf94be1e08539a26056941f5cb56038e1ffb'},
    {'name': 'munsell',       'version': '0.4.3',   'hash': '2e9a3cd4a1f5c10e1abd7d4f6c6fa0cf7420bf00'},
    {'name': 'nlme',          'version': '3.1-131', 'hash': '5c8a7916b35365f70392f8a01b7a32644edbbfc7'},
    {'name': 'nloptr',        'version': '1.0.4',   'hash': '96a408dd280081c4ee4e56050afd317e8c3cfef9'},
    {'name': 'nnet',          'version': '7.3-12',  'hash': 'fdbd8ae630e15abf92ddc4e92d39112f1f61a3a4'},
    {'name': 'numDeriv',      'version': '2016.8-1', 'hash': '8d43a502c4ee1efcf8b3dcf5ba1c91667c84198a'},
    {'name': 'ordinal',       'version': '2015.6-28','hash': '514532a3a2de3c567bf6d022e57f930cc5575a18'},
    {'name': 'pbkrtest',      'version': '0.4-2',   'hash': 'c31d8c536f14bb089a505daf762aa7c3ee14e4a7'},
    {'name': 'pROC',          'version': '1.8',     'hash': '4885d34ce8738b8a85bf9fb2276cd2d637ea263d'},
    {'name': 'pkgconfig',     'version': '2.0.1',   'hash': '762fa56420abb5fa7901b13c66f60fddb6f7f4a4'},
    {'name': 'plogr',         'version': '0.1-1',   'hash': 'f81de60c00923d9674fb764195c09d5e6fd981d1'},
    {'name': 'plotmo',        'version': '3.3.4',   'hash': '476a1fd3a076fbdb378e921b3d19b981199faaf1'},
    {'name': 'plotrix',       'version': '3.7',     'hash': 'c47a200a622a106877ca2d5002c2f5f886a33079'},
    {'name': 'plyr',          'version': '1.8.4',   'hash': 'b85d161877ba9b30f22b68568e411d60d89d6e4a'},
    {'name': 'png',           'version': '0.1-7',   'hash': '433aeec293faa67d1024af80097c64578b837bf7'},
    {'name': 'purrr',         'version': '0.2.4',   'hash': '89211b41a2055f76ab9e06188ab837bf20173f62'},
    {'name': 'prodlim',       'version': '1.6.1',   'hash': 'a89843cacd89c6711628d7763754840dad8bfc22'},
    {'name': 'proto',         'version': '1.0.0',   'hash': '27be73646ec5479f8761dc8f33dd6b8d4bc0faa6'},
    {'name': 'psych',         'version': '1.7.8',   'hash': '051472e89c5592631ebb2839331855e80924f1b3'},
    {'name': 'quantreg',      'version': '5.34',    'hash': '4f27031591733b7d9070d6d7e3bec70ad9415d66'},
    {'name': 'randomForest',  'version': '4.6-12',  'hash': 'd9c7c08b51efc5bc3f0562b503fe8e44b5ef75bc'},
    {'name': 'raster',        'version': '2.6-7',   'hash': 'bd742b92f90df6b423c53ee0421e9fedbfc1187b'},
    {'name': 'rasterVis',     'version': '0.41',    'hash': '8e6ca104f15b8e917d91074f8044d688df047a77'},
    {'name': 'recipes',       'version': '0.1.1',   'hash': 'abf0c09ecb666ba8aa219756a2809580d60817d1'},
    {'name': 'reshape',       'version': '0.8.7',   'hash': '86d46489168de9efc7c86d305f7732bd7d6bc7e7'},
    {'name': 'reshape2',      'version': '1.4.3',   'hash': '14189819c2ef3c4461805c4aa6fcd4aa1851ac67'},
    {'name': 'rgdal',         'version': '1.1-3',   'hash': '8e6fdd0bad7ecdd046236d2b7bc123a936b5e8d1'},
    {'name': 'rgeos',         'version': '0.3-23',  'hash': '4aa087ec67d4d61e4467c0d7178961c2995faa0d'},
    {'name': 'rjson',         'version': '0.2.15',  'hash': '230b4e4883226d3437f72331089774070112fef9'},
    {'name': 'rlang',         'version': '0.1.4',   'hash': 'e10b2692d5e78e6567d4332d4ff9f33b6faa07f9'},
    {'name': 'robustbase',    'version': '0.92-8',  'hash': 'ff3280dc89d1cd5a127d9cd527f5794e754154ca'},
    {'name': 'rpart',         'version': '4.1-10',  'hash': 'f395e7316fe4a13cdfdebd7f3d1c40f10686509b'},
    {'name': 'scales',        'version': '0.5.0',   'hash': 'df1c718aebea32eaeebb4332405a8cfd53ae4268'},
    {'name': 'sfsmisc',       'version': '1.1-1',   'hash': 'dbde2d90bc2339a0d34d44e77133c4cb03304ee5'},
    {'name': 'slam',          'version': '0.1-37',  'hash': '853c701cb2c440eedac8eebf91a3807581ccf609'},
    {'name': 'sp',            'version': '1.2-5',   'hash': '0e24d5a6d6fc3196a38d7d4ddfcca247dd6afbe8'},
    {'name': 'spacetime',     'version': '1.2-1',   'hash': '77fc1c8190be5a40b0f3c9d333e77703f7313db7'},
    {'name': 'spatial',       'version': '7.3-11',  'hash': 'c849dc91bb4a22185f0a5bed044f8fd3f2ed82e2'},
    {'name': 'spatial.tools', 'version': '1.4.8',   'hash': 'b9c0fc738485cf14c354b91ceb256fb9649ad28d'},
    {'name': 'stringi',       'version': '1.1.6',   'hash': '1393f38caee1430fa56718d33b25b3c909cc587d'},
    {'name': 'stringr',       'version': '1.2.0',   'hash': 'c53001e1eb12e18935939a54ab721b042d71b27e'},
    {'name': 'survival',      'version': '2.41-3',  'hash': 'c4336da9e4b38daa6872f130fced41d8960a182f'},
    {'name': 'tibble',        'version': '1.3.4',   'hash': 'f7242439a5ade9c6aaff22b61d253c58174fca07'},
    {'name': 'tidyr',         'version': '0.7.2',   'hash': 'bbe4adcb7a6107abd85ef5ed188201801d05387d'},
    {'name': 'tidyselect',    'version': '0.2.3',   'hash': 'c85b91357f782f4bbb75ffe90f6ac06e7b8c71f5'},
    {'name': 'timeDate',      'version': '3042.101', 'hash': 'bdc27e3822a323e0507399b92e990bb5c1f8101d'},
    {'name': 'tm',            'version': '0.7-1',   'hash': '7ddb1e9f0dbf58236ed246814b55171e65ad31f3'},
    {'name': 'ucminf',        'version': '1.1-4',   'hash': '3faa27a97f96ad775bc120bf07965d6950a253b1'},
    {'name': 'viridisLite',   'version': '0.2.0',   'hash': '53fc6a97adf703b8bdb78d978170060b302d658c'},
    {'name': 'withr',         'version': '2.1.1',   'hash': '60d65c0c3a639b4899b1b6d071327f563b98ccbe'},
    {'name': 'xml2',          'version': '1.1.1',   'hash': '4431dde88efddd9881bda85ed478e8f2c519ac35'},
    {'name': 'xts',           'version': '0.10-0',  'hash': '9bc0f828628244fb9fd18215cb51a1ae4421609b'},
    {'name': 'zoo',           'version': '1.8-0',   'hash': '1d9def97f316bcf28e4cbd426e31fe7998578c88'},
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
