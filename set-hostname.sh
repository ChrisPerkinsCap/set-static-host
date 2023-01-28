#!/bin/sh

source ./set-vars.sh

###############################################
###########  check Evironment State ###########

# Hostname argument is missing so early exit
if [ -z "${1}" ];
then
  echo "No arguments supplied. \nPlease provide a hostname as your first argument!" 1>&2
  exit 1
fi

# IP address component argument is missing so early exit
if [ -z "$2" ];
then
  echo "The IP address component has not been supplied. \nPlease ensure the second argument is an IP address component between 1-3 figures!" 1>&2
  exit 1
fi

# IP address component is not between 0 and 255 so early exit
if [ "${2}" -lt 0 ] || [ "${2}" -gt 255 ];
then
  echo "The IP address component '${2}' must be between 0 and 255. Please check and try again." 1>&2
  exit 1
fi

# The hosts or the hostname file has been modified so early exit
# if [ -f "${configs_dir}/hosts.bkp" ] || [ -f "${configs_dir}/hostname.bkp" ];
# then
#   echo "The hostname has already been modified! \nPlease note the changes before using the clean up script!"
#   read -p "Do you want to modify them again? (y|n) " choice

#   case "${choice}" in
#     y|Y ) mod_hostname="y";;
#     n|N ) mod_hostname="n";;
#     * ) mod_hostname="y";;
#   esac
# fi

# The hosts or the hostname file has been modified so confirm further modifications
if [ -f "${configs_dir}/hosts.bkp" ] || [ -f "${configs_dir}/hostname.bkp" ];
then
  echo "The hostname has already been modified! \nPlease note the changes before using the clean up script!"
  read -p "Do you want to modify them again? (y|n) " hostname_choice

  case "${hostname_choice}" in
    y|Y ) mod_hostname="y";;
    n|N ) mod_hostname="n";;
    * ) mod_hostname="y";;
  esac
fi

# The netplan cofig file has been set so confirm further modifications
if [ -f "${netplan_dir}/${netplan_conf_file}" ] || [ -f "${netplan_dir}/${netplan_conf_file}.bkp" ];
then
  echo "The netplan configuration has already been set! \nPlease note the changes before using the clean up script!"
  read -p "Do you want to modify the netplan config again? (y|n) " netplan_choice

  case "${netplan_choice}" in
    y|Y ) mod_netplan="y";;
    n|N ) mod_netplan="n";;
    * ) mod_netplan="y";;
  esac
fi

# No further modifications so early exit
if [ "${mod_hostname}" == "n" ] && [ "${mod_netplan}" == "n" ];
then
  echo "The hostname has been modified  and no further channges are required." 1>&2
  echo "The Netplan configuration has previously been set and no further modifications are required" 1>&2
  echo "Exiting .........\n"
  exit 1
fi

######## END - check Evironment State #########
###############################################


##############################################
##########  modify Evironment State ##########

# Check the hostname has been supplied and apply it to the /etc/hosts file
if [ -n "${host_name}" ] && [ "${mod_hostname}" == "y" ] && [ ! -f "${configs_dir}/hosts.bkp" ];
then
  sudo sed -i'.bkp' "s/127.0.1.1 ${host_name}/127.0.1.1 ${new_hostname}/" "${configs_dir}/hosts"
fi

# Check the hostname has been supplied and apply it to the /etc/hostname file
if [ -n "${host_name}" ] && [ "${mod_hostname}" == "y" ] && [ ! -f "${configs_dir}/hostname.bkp" ];
then
  sudo sed -i'.bkp' "s/${host_name}/${new_hostname}/" "${configs_dir}/hostname"
fi

# Check that th IP address component had be supplied and if the netplan file already exists.
# If so apply the IP argument to the netplan file.
if [ -n "${ip}" ] && [ "${mod_netplan}" == "y" ] && [ -f "${netplan_dir}/${netplan_conf_file}" ];
then
  printf "File exists\nEditing file...."
  sed -i '.bkp' -E "s/(-[[:space:]])((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]?).){3}(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]?){1}(\/24)?/- ${ip}\/24/" "${netplan_dir}/${netplan_conf_file}"
fi

# Check that th IP address component had be supplied and if the netplan file doesn't already exists.
# If so apply the IP argument to the netplan file.
if [ -n "${ip}" ] && [ ! -f "${netplan_dir}/${netplan_conf_file}" ];
then
printf "File does not exist\nCreating file: "
  # sudo tee -a "${netplan_dir}/${netplan_conf_file}" <<EOF
  tee -a "${netplan_dir}/${netplan_conf_file}" <<EOF
network:
  version: 2
  ethernets:
    enp0s8:
      dhcp4: false
      addresses:
        - $ip/24
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
      routes:
        - to: default
          via: 192.168.56.255
EOF
fi

###### END - modify Evironment State #########
##############################################

# sudo netplan try
#sudo reboot