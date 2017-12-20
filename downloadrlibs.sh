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

  mirror="http://mirror.aarnet.edu.au/pub/CRAN"
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
       MASS_7.3-47.tar.gz
       Matrix_1.2-3.tar.gz
       MatrixModels_0.4-1.tar.gz
       ModelMetrics_1.1.0.tar.gz
       R.methodsS3_1.7.1.tar.gz
       R.oo_1.21.0.tar.gz
       R.utils_2.6.0.tar.gz
       RColorBrewer_1.1-2.tar.gz
       Rcpp_0.12.14.tar.gz
       RcppEigen_0.3.3.3.1.tar.gz
       SDMTools_1.1-221.tar.gz
       SparseM_1.77.tar.gz
       abind_1.4-5.tar.gz
       biomod2_3.3-7.tar.gz
       boot_1.3-17.tar.gz
       car_2.1-6.tar.gz
       caret_6.0-78.tar.gz
       class_7.3-14.tar.gz
       cluster_2.0.3.tar.gz
       codetools_0.2-14.tar.gz
       colorspace_1.3-2.tar.gz
       deldir_0.1-14.tar.gz
       dichromat_2.0-0.tar.gz
       digest_0.6.13.tar.gz
       dismo_1.1-4.tar.gz
       doParallel_1.0.11.tar.gz
       evaluate_0.10.1.tar.gz
       foreach_1.4.4.tar.gz
       foreign_0.8-69.tar.gz
       gam_1.14-4.tar.gz
       gamlss_4.3-8.tar.gz
       gamlss.data_4.3-2.tar.gz
       gamlss.dist_4.3-5.tar.gz
       gbm_2.1.1.tar.gz
       gbm_2.1.3.tar.gz
       gdalUtils_2.0.1.7.tar.gz
       ggdendro_0.1-20.tar.gz
       ggplot2_2.2.1.tar.gz
       gridExtra_2.3.tar.gz
       gstat_1.1-5.tar.gz
       gtable_0.2.0.tar.gz
       hexbin_1.27.1.tar.gz
       intervals_0.15.1.tar.gz
       iterators_1.0.9.tar.gz
       labeling_0.3.tar.gz
       lattice_0.20-35.tar.gz
       latticeExtra_0.6-28.tar.gz
       lazyeval_0.2.1.tar.gz
       lme4_1.1-14.tar.gz
       magrittr_1.5.tar.gz
       mda_0.4-10.tar.gz
       mgcv_1.8-22.tar.gz
       minqa_1.2.4.tar.gz
       mmap_0.6-15.tar.gz
       munsell_0.4.3.tar.gz
       nlme_3.1-131.tar.gz
       nloptr_1.0.4.tar.gz
       nnet_7.3-12.tar.gz
       ordinal_2015.6-28.tar.gz
       pbkrtest_0.4-2.tar.gz
       pROC_1.8.tar.gz
       plyr_1.8.4.tar.gz
       png_0.1-7.tar.gz
       proto_1.0.0.tar.gz
       quantreg_5.34.tar.gz
       randomForest_4.6-12.tar.gz
       raster_2.6-7.tar.gz
       rasterVis_0.41.tar.gz
       reshape_0.8.7.tar.gz
       reshape2_1.4.3.tar.gz
       rgdal_1.1-3.tar.gz
       rgeos_0.3-23.tar.gz
       rjson_0.2.15.tar.gz
       rpart_4.1-10.tar.gz
       scales_0.5.0.tar.gz
       sp_1.2-5.tar.gz
       spacetime_1.2-1.tar.gz
       spatial_7.3-11.tar.gz
       spatial.tools_1.4.8.tar.gz
       stringi_1.1.6.tar.gz
       stringr_1.2.0.tar.gz
       survival_2.41-3.tar.gz
       tibble_1.3.4.tar.gz
       ucminf_1.1-4.tar.gz
       xts_0.10-0.tar.gz
       zoo_1.8-0.tar.gz )

for lib in ${RLIBS[@]} ; do
  get_r_lib "${lib}"
done
