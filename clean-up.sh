#!/bin/sh

source ./set-vars.sh

echo "Please specify which elements to clean: \n Everything [a] or [enter] \nOnly hostname files [h] \nOnly Netplan files [n]"
read -p "Clean type: " choice
case "${choice}" in
  a|A ) clean="a";;
  h|H ) clean="h";;
  n|N ) clean="n";;
  * ) clean="a";;
esac

if [ -z "${clean}" ];
then
  clean="a"
fi

if [ -f "${configs_dir}/hosts.bkp" ] && ([ "${clean}" = "a" ] || [ "${clean}" = "h" ]);
then
  rm "${configs_dir}/hosts"
  rm "${configs_dir}/hosts.bkp"
  sleep 1
  cp "${PWD}/templates/hosts" "${configs_dir}/hosts"
fi

if [ -f "${configs_dir}/hostname.bkp" ] && ([ "${clean}" = "a" ] || [ "${clean}" = "h" ]);
then
  rm "${configs_dir}/hostname"
  rm "${configs_dir}/hostname.bkp"
  sleep 1
  cp "${PWD}/templates/hostname" "${configs_dir}/hostname"
fi

if [ -f "${netplan_dir}/${netplan_conf_file}.bkp" ] && ([ "${clean}" = "a" ] || [ "${clean}" = "n" ]);
then
  rm "${netplan_dir}/${netplan_conf_file}.bkp"
  sleep 1
  # cp "${PWD}/templates/${netplan_conf_file}" "${netplan_dir}/${netplan_conf_file}"
fi

if [ -f "${netplan_dir}/${netplan_conf_file}" ] && ([ "${clean}" = "a" ] || [ "${clean}" = "n" ]);
then
  rm "${netplan_dir}/${netplan_conf_file}"
  sleep 1
  # cp "${PWD}/templates/${netplan_conf_file}" "${netplan_dir}/${netplan_conf_file}"
fi

exit 0