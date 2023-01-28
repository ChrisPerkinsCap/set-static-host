#!/bin/sh

host_name=$(hostname -s)
new_hostname="${1}"
ip="192.168.56.${2}"
configs_dir="${PWD}/etc"
#configs_dir="/etc"
netplan_dir="${configs_dir}/netplan"
#netplan_dir="netplan"
# netplan_conf_file="10-example-static.yaml"
netplan_conf_file="10-enp0s8-static-config.yaml"
# clean="${3:-"all"}"
mod_hostname="y"
mod_netplan="y"