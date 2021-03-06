#!/bin/bash

# TODO: in case this script dies at some point, I should also make sure it cleans up enough to be re-run


function die() {
  msg=$1
  code=$2
  echo "$msg"
  exit $code
}

function scl_enable_perl516() {
  scl enable perl516 "$*"
}


function install_local_lib() {
  # download
  curl --fail -k -L -O http://mirror.aarnet.edu.au/pub/CPAN/authors/id/H/HA/HAARG/local-lib-2.000012.tar.gz || die "Failed to download local::lib" 1
  # unpack
  tar xzf local-lib-2.000012.tar.gz || die "Failed to extract loacl::lib" 1
  # build
  pushd local-lib-2.000012 || die "Failed to enter local::lib extract" 1
  scl_enable_perl516 perl Makefile.PL --bootstrap || die "Failed to bootstrap local::lib" 1
  scl_enable_perl516 make test || die "Failed to make test lcoal::lib" 1
  scl_enable_perl516 make install || die "Failed to install local::lib" 1
  popd
  # cleanup
  rm -fr local-lib-2.000012
  rm -f local-lib-2.000012.tar.gz
}


function install_gdal_perl_bindings() {
  curl --fail -k -L -O http://download.osgeo.org/gdal/gdal-1.9.2.tar.gz || die "Failed to download gdal" 1
  tar -xzf gdal-1.9.2.tar.gz || die "Failed to extract gdal" 1
  pushd gdal-1.9.2/swig/perl || die "Faled to enter swig/perl" 1
  # build and install
  scl_enable_perl516 perl Makefile.PL --gdal-config=/usr/bin/gdal-config-64 || die "Failed to generate makefiles" 1

  scl_enable_perl516 make -f Makefile_Geo__GDAL || die "Failed building Geo::GDAL" 1
  scl_enable_perl516 make -f Makefile_Geo__GDAL__Const || die "Failed building Geo::GDAL::Const" 1
  scl_enable_perl516 make -f Makefile_Geo__OGR || die "Failed building Geo::OGR" 1
  scl_enable_perl516 make -f Makefile_Geo__OSR || die "Failed building Geo::OSR" 1
  # install
  scl_enable_perl516 make -f Makefile_Geo__GDAL install || die "Failed installing Geo::GDAL" 1
  scl_enable_perl516 make -f Makefile_Geo__GDAL__Const install || die "Failed installing Geo::GDAL::Const" 1
  scl_enable_perl516 make -f Makefile_Geo__OGR install || die "Failed installing Geo::OGR" 1
  scl_enable_perl516 make -f Makefile_Geo__OSR install || die "Failed installing Geo::OSR" 1
  # cleanup
  popd
  rm -fr gdal-1.9.2
  rm -f gdal-1.9.2.tar.gz
}

function install_biodiverse_dependencies() {
  # dependencies first
  export PERL_MM_USE_DEFAULT=1
  scl_enable_perl516 cpan App::cpanminus || die "Failed to install App::cpanminus" 1
  # YAML::Syck has installation failures at v1.27
  scl_enable_perl516 cpanm YAML::Syck || die "Failed to install YAML:Syck" 1
  # and all the stuff that's missing in the documentation
  scl_enable_perl516 cpanm Getopt::Long::Descriptive
  scl_enable_perl516 cpanm JSON
  scl_enable_perl516 cpanm Time::HiRes
  scl_enable_perl516 cpanm --force Object::InsideOut
  scl_enable_perl516 cpanm Math::Random::MT::Auto
  scl_enable_perl516 cpanm List::BinarySearch
  scl_enable_perl516 cpanm List::BinarySearch::XS
  # and the rest of deps
  scl_enable_perl516 cpanm Task::Biodiverse::NoGUI || die "Failed to install Biodiverse::NoGUI" 1
}

#1. setup local::lib
install_local_lib
#2. activate local::lib
eval $(scl_enable_perl516 "perl -I$HOME/perl5/lib/perl5 -Mlocal::lib")
#3. install_biodiverse_dependencies
install_gdal_perl_bindings
install_biodiverse_dependencies
