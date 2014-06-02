#!/usr/bin/env bash

ROOTCA_CN=bccvlca.bccvl.org.au
CANAME=bccvlca

CURDIR=$(pwd)

function readlink() {
  python -c 'import sys, os.path; print os.path.realpath(sys.argv[1])' $1
}

SALTROOT=$(readlink "${CURDIR}/..")

CADIR="${CURDIR}/${CANAME}"

# Create a certificate Authority
if [[ ! -d "${CADIR}" ]] ; then
    mkdir -p "${CADIR}"
    pushd "${CADIR}"
    mkdir certs private
    chmod 700 private
    echo 01 > serial
    touch index.txt
    popd
fi

# Create openssl config file
if [[ ! -f "${CADIR}/openssl.cnf" ]] ; then
  pushd "${CADIR}"
  cat > openssl.cnf << EOL
[ ca ]
default_ca = ${CANAME}

[ ${CANAME} ]
dir = .
certificate = \$dir/cacert.pem
database = \$dir/index.txt
new_certs_dir = \$dir/certs
private_key = \$dir/private/cakey.pem
serial = \$dir/serial

default_crl_days = 7
default_days = 365
default_md = sha1

policy = ${CANAME}_policy
x509_extensions = certificate_extensions

unique_subject = no

[ ${CANAME}_policy ]
commonName = supplied
stateOrProvinceName = optional
countryName = optional
emailAddress = optional
organizationName = optional
organizationalUnitName = optional

[ certificate_extensions ]
basicConstraints = CA:false

[req]
default_bits = 2048
default_keyfile = ./private/cakey.pem
default_md = sha1
prompt = no
distinguished_name = root_ca_distinguished_name
x509_extensions = root_ca_extensions

[ root_ca_distinguished_name ]
#commonName = hostname
commonName = ${ROOTCA_CN}

[ root_ca_extensions ]
basicConstraints = CA:true, pathlen:0
keyUsage = keyCertSign, cRLSign

[ client_ca_extensions ]
basicConstraints = CA:false
# only digitalSignature should be required for ssl client
keyUsage = digitalSignature, keyEncipherment, keyAgreement
# clientAuth = 1.3.6.1.5.5.7.3.2
extendedKeyUsage = clientAuth
subjectAltName = \$ENV::SUBJECTALTNAME

[ server_ca_extensions ]
basicConstraints = CA:false
# only digitalSignature should be require for ssl server
keyUsage = digitalSignature, keyEncipherment, keyAgreement
# serverAuth = 1.3.6.1.5.5.7.3.1
subjectAltName = \$ENV::SUBJECTALTNAME

EOL

    # generate Certificate Authority
    SUBJECTALTNAME="${CANAME}" openssl req -x509 -config openssl.cnf -newkey rsa:2048 -days 365 -out cacert.pem -outform PEM -subj /CN=${CANAME}/ -nodes
    SUBJECTALTNAME="${CANAME}" openssl x509 -in cacert.pem -out cacert.cer -outform DER
    popd
fi

function create_server_cert {
    # create dir in current folder and generate cert for given CN
    CADIR=$1
    DIR=$2
    CN=$3
    if [[ -d ${DIR} ]] ; then
      echo "Directory ${DIR} already exists"
      return 1
    fi
    mkdir ${DIR}
    pushd ${DIR}
    openssl genrsa -out key.pem 2048
    SUBJECTALTNAME="DNS:$CN" openssl req -new -key key.pem -out req.pem -outform PEM -subj /CN=${CN}/O=BCCVL/ -nodes
    pushd ${CADIR}
    SUBJECTALTNAME="DNS:$CN" openssl ca -config openssl.cnf -in ${DIR}/req.pem -out ${DIR}/cert.pem -notext -batch -extensions server_ca_extensions
    popd  # CADIR
    # optional pkcs12 file for e.g. java servers
    # openssl pkcs12 -export -out keycert.p12 -in cert.pem -inkey key.pem -passout pass:MySecretPassword
    popd  # DIR
}

function create_client_cert {
    CADIR=$1
    DIR=$2
    CN=$3
    if [[ -d ${DIR} ]] ; then
      echo "Directory ${DIR} already exists"
      return 1
    fi
    mkdir ${DIR}
    pushd ${DIR}
    openssl genrsa -out key.pem 2048
    SUBJECTALTNAME="DNS:$CN" openssl req -new -key key.pem -out req.pem -outform PEM -subj /CN=${CN}/O=BCCVL/ -nodes
    pushd ${CADIR}
    SUBJECTALTNAME="DNS:$CN" openssl ca -config openssl.cnf -in ${DIR}/req.pem -out ${DIR}/cert.pem -notext -batch -extensions client_ca_extensions
    popd  # CADIR
    # optional pkcs12 file for e.g. java servers
    # openssl pkcs12 -export -out keycert.p12 -in cert.pem -inkey key.pem -passout pass:MySecretPassword
    popd  # DIR
}

function create_cert_environment {
  ENV=$1

  if [ "$ENV" != "dev" -a "$ENV" != "test" -a "$ENV" != "qa" -a "$ENV" != "prod" ] ; then
    echo "Unknown environment '$ENV' "
    exit 1
  fi

  # create the server certs
  for name in ${SERVER_CERTS} ; do
    create_server_cert ${CADIR} "${CURDIR}/${name}-${ENV}" "${DNSMAP[${name}-${ENV}]}"
  done

  # create some client certs:
  for name in ${CLIENT_CERTS} ; do
    create_client_cert ${CADIR} "${CURDIR}/${name}-${ENV}" "${name}-${ENV}.bccvl.org.au"
  done

  # Decide where to put the certs
  PILLAR_ROOT=${SALTROOT}/pillar/${ENV}/certs

  for name in ${CLIENT_CERTS} ; do
    cp ${name}-${ENV}/cert.pem ${PILLAR_ROOT}/${name}.crt.pem
    cp ${name}-${ENV}/key.pem ${PILLAR_ROOT}/${name}.key.pem
  done

  for name in ${SERVER_CERTS} ; do
    if [ -e ${name}-${ENV}/cert.pem ] ; then
      # TODO: don't overwrite non bccvlca server certs
      cp ${name}-${ENV}/cert.pem ${PILLAR_ROOT}/${name}.crt.pem
      cp ${name}-${ENV}/key.pem ${PILLAR_ROOT}/${name}.key.pem
    fi
  done

}

# map ENV names to domain names
declare -A DNSMAP
DNSMAP=(
  ["monitor-dev"]="192.168.100.100"
  ["monitor-qa"]="monitor.bccvl.org.au"
  ["monitor-test"]="monitor.bccvl.org.au"
  ["monitor-prod"]="monitor.bccvl.org.au"
  ["rsyslog-dev"]="192.168.100.100"
  ["rsyslog-qa"]="monitor.bccvl.org.au"
  ["rsyslog-test"]="monitor.bccvl.org.au"
  ["rsyslog-prod"]="monitor.bccvl.org.au"
  ["bccvl-dev"]="192.168.100.200"
  ["bccvl-qa"]="qa.bccvl.org.au"
  ["bccvl-test"]="test.bccvl.org.au"
  ["bccvl-prod"]="app.bccvl.org.au"
  ["rabbitmq-dev"]="192.168.100.200"
  ["rabbitmq-qa"]="qa.bccvl.org.au"
  ["rabbitmq-test"]="test.bccvl.org.au"
  ["rabbitmq-prod"]="app.bccvl.org.au"
  ["rabbitweb-dev"]="192.168.100.200"
  ["rabbitweb-qa"]="qa.bccvl.org.au"
  ["rabbitweb-test"]="test.bccvl.org.au"
  ["rabbitweb-prod"]="app.bccvl.org.au"
)

SERVER_CERTS="monitor rsyslog bccvl rabbitmq rabbitweb"
CLIENT_CERTS="worker plone bccvllogger flower"

#### copy root cert to pillar folder base/certs
PILLAR_ROOT=${SALTROOT}/pillar/base/certs
# copy cacert (no need to copy CA private key)
cp ${CADIR}/cacert.pem ${PILLAR_ROOT}/${CANAME}.crt.pem

### generate env specific certs
for env in dev qa test prod ; do
    create_cert_environment ${env}
done
