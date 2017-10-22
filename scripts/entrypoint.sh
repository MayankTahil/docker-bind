#!/bin/bash
set -e

WEBMIN_ENABLED=${WEBMIN_ENABLED:-true}

BIND_DATA_DIR=${DATA_DIR}/bind
WEBMIN_DATA_DIR=${DATA_DIR}/webmin
DHCP_DATA_DIR=$DATA_DIR/dhcp

add_user()
  if sudo cat /data/webmin/etc/webmin.acl | grep -xqFe "admin"
  then
    echo "admin user already exists."
  else
    bash /sbin/add-user.sh
  fi

create_bind_data_dir() {
  mkdir -p ${BIND_DATA_DIR}

  # populate default bind configuration if it does not exist
  if [ ! -d ${BIND_DATA_DIR}/etc ]; then
    mv /etc/bind ${BIND_DATA_DIR}/etc
  fi
  rm -rf /etc/bind
  ln -sf ${BIND_DATA_DIR}/etc /etc/bind
  chmod -R 0775 ${BIND_DATA_DIR}
  chown -R ${BIND_USER}:${BIND_USER} ${BIND_DATA_DIR}

  if [ ! -d ${BIND_DATA_DIR}/lib ]; then
    mkdir -p ${BIND_DATA_DIR}/lib
    chown ${BIND_USER}:${BIND_USER} ${BIND_DATA_DIR}/lib
  fi
  rm -rf /var/lib/bind
  ln -sf ${BIND_DATA_DIR}/lib /var/lib/bind
}

create_dhcp_data_dir() {
  mkdir -p ${DHCP_DATA_DIR}

  # populate default dhcp configuration if it does not exist
  if [ ! -d ${DHCP_DATA_DIR} ]; then
    mv /etc/dhcp ${DHCP_DATA_DIR}/
  fi
  rm -rf /etc/dhcp
  ln -sf ${DHCP_DATA_DIR} /etc/dhcp
  chmod -R 0775 ${DHCP_DATA_DIR}
}

create_webmin_data_dir() {
  mkdir -p ${WEBMIN_DATA_DIR}
  chmod -R 0755 ${WEBMIN_DATA_DIR}
  chown -R root:root ${WEBMIN_DATA_DIR}

  # populate the default webmin configuration if it does not exist
  if [ ! -d ${WEBMIN_DATA_DIR}/etc ]; then
    mv /etc/webmin ${WEBMIN_DATA_DIR}/etc
  fi
  rm -rf /etc/webmin
  ln -sf ${WEBMIN_DATA_DIR}/etc /etc/webmin
}

create_pid_dir() {
  mkdir -m 0775 -p /var/run/named
  chown root:${BIND_USER} /var/run/named
}

create_bind_cache_dir() {
  mkdir -m 0775 -p /var/cache/bind
  chown root:${BIND_USER} /var/cache/bind
}

create_pid_dir
create_bind_data_dir
create_bind_cache_dir
create_dhcp_data_dir

# allow arguments to be passed to named
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == named || ${1} == $(which named) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch named
if [[ -z ${1} ]]; then
  if [ "${WEBMIN_ENABLED}" == "true" ]; then
    create_webmin_data_dir
    echo "Starting webmin..."
    /etc/init.d/webmin start
    # echo "Adding user 'admin' and restarting webmin"
    # add_user
    # echo "Starting dhcpd..."
    dhcpd start &
  fi

  echo "Starting named..."
  exec $(which named) -u ${BIND_USER} -g ${EXTRA_ARGS}
else
  exec "$@"
fi
