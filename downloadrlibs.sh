#!/bin/bash

SHASUM=$(which shasum)
SHASUM=${SHASUM:-$(which sha1sum)}

SALT_ROOT="$(pwd)/salt/roots"
if [ ! -d "${SALT_ROOT}" ] ; then
  SALT_ROOT="/srv"
  if [ !-d "${SALT_ROOT}" ] ; then
    echo "Can't identify salt state root folder"
    exit 1
  fi
fi

RLIBS_PATH="${SALT_ROOT}/salt/roles/worker/rlibs"

if [ ! -d "${RLIBS_PATH}" ] ; then
  mkdir "${RLIBS_PATH}"
fi

function get_r_lib() {

  mirror="http://cran.ms.unimelb.edu.au"
  contrib="${mirror}/src/contrib"
  archive="${contrib}/Archive"

  dest="${RLIBS_PATH}/$1"
  if [ -f "${dest}" ] ; then
    echo "$1 already available"
    return
  fi
  echo "Download $1 from CRAN"
  curl --progress-bar --fail -o "${dest}" "${contrib}/$1" 1>/dev/null
  if [ ! $? -eq 0 ] ; then
    echo "Download $1 from CRAN Archive"
    echo "${archive}/${1%_*}/$1"
    curl --progress-bar --fail -o "${dest}" "${archive}/${1%_*}/$1" 1>/dev/null
    if [ ! $? -eq 0 ]; then
      echo "Download $1 failed"
      return
    fi
  fi
  name="${dest%.tar.gz}.sha1"
  ${SHASUM} "${dest}"  | cut -f1 -d ' ' > "${name}"
}

RLIBS=(rjson_0.2.13.tar.gz
       sp_1.0-15.tar.gz
       raster_2.2-31.tar.gz
       rgdal_0.8-16.tar.gz
       rgeos_0.3-4.tar.gz
       gam_1.09.1.tar.gz
       Rcpp_0.11.1.tar.gz
       plyr_1.8.1.tar.gz
       pROC_1.7.2.tar.gz
       R2HTML_2.2.1.tar.gz
       png_0.1-7.tar.gz
       survival_2.37-7.tar.gz
       lattice_0.20-29.tar.gz
       gbm_2.0-8.tar.gz
       stringr_0.6.2.tar.gz
       evaluate_0.5.3.tar.gz
       dismo_0.9-3.tar.gz
       R.methodsS3_1.6.1.tar.gz
       R.oo_1.18.0.tar.gz
       R.utils_1.29.8.tar.gz
       SDMTools_1.1-20.tar.gz
       abind_1.4-0.tar.gz
       RColorBrewer_1.0-5.tar.gz
       latticeExtra_0.6-26.tar.gz
       hexbin_1.26.3.tar.gz
       zoo_1.7-11.tar.gz
       rasterVis_0.28.tar.gz
       mda_0.4-4.tar.gz
       randomForest_4.6-7.tar.gz
       biomod2_3.1-25.tar.gz)

for lib in ${RLIBS[@]} ; do
  get_r_lib "${lib}"
done
