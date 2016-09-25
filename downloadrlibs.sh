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

RLIBS=(FNN_1.1.tar.gz
       KernSmooth_2.23-15.tar.gz
       MASS_7.3-45.tar.gz
       Matrix_1.2-3.tar.gz
       R.methodsS3_1.7.1.tar.gz
       R.oo_1.20.0.tar.gz
       R.utils_2.2.0.tar.gz
       R2HTML_2.3.1.tar.gz
       RColorBrewer_1.1-2.tar.gz
       Rcpp_0.12.3.tar.gz
       SDMTools_1.1-221.tar.gz
       abind_1.4-3.tar.gz
       biomod2_3.1-64.tar.gz
       boot_1.3-17.tar.gz
       class_7.3-14.tar.gz
       cluster_2.0.3.tar.gz
       codetools_0.2-14.tar.gz
       colorspace_1.2-6.tar.gz
       deldir_0.1-9.tar.gz
       dichromat_2.0-0.tar.gz
       digest_0.6.9.tar.gz
       dismo_1.0-15.tar.gz
       evaluate_0.8.tar.gz
       foreach_1.4.3.tar.gz
       foreign_0.8-66.tar.gz
       gam_1.12.tar.gz
       gamlss_4.3-8.tar.gz
       gamlss.data_4.3-2.tar.gz
       gamlss.dist_4.3-5.tar.gz
       gbm_2.1.1.tar.gz
       gdalUtils_2.0.1.7.tar.gz
       ggplot2_2.0.0.tar.gz
       gridExtra_2.2.0.tar.gz
       gstat_1.1-2.tar.gz
       gtable_0.2.0.tar.gz
       hexbin_1.27.1.tar.gz
       intervals_0.15.1.tar.gz
       iterators_1.0.8.tar.gz
       labeling_0.3.tar.gz
       lattice_0.20-33.tar.gz
       latticeExtra_0.6-28.tar.gz
       magrittr_1.5.tar.gz
       mda_0.4-8.tar.gz
       mgcv_1.8-9.tar.gz
       munsell_0.4.3.tar.gz
       nlme_3.1-122.tar.gz
       nnet_7.3-11.tar.gz
       pROC_1.8.tar.gz
       plyr_1.8.3.tar.gz
       png_0.1-7.tar.gz
       proto_0.3-10.tar.gz
       randomForest_4.6-12.tar.gz
       raster_2.5-8.tar.gz
       rasterVis_0.37.tar.gz
       reshape_0.8.5.tar.gz
       reshape2_1.4.1.tar.gz
       rgdal_1.1-10.tar.gz
       rgeos_0.3-17.tar.gz
       rjson_0.2.15.tar.gz
       rpart_4.1-10.tar.gz
       scales_0.4.0.tar.gz
       sp_1.2-2.tar.gz
       spacetime_1.1-5.tar.gz
       spatial_7.3-11.tar.gz
       stringi_1.0-1.tar.gz
       stringr_1.0.0.tar.gz
       survival_2.38-3.tar.gz
       xts_0.9-7.tar.gz
       zoo_1.7-12.tar.gz )

for lib in ${RLIBS[@]} ; do
  get_r_lib "${lib}"
done
