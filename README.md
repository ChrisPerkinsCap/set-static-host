# set-static-host

A convenience script for changing the hostname and static IP address of virtual machines after cloning.

### N.B. Make sure that the files cleanup.sh, set-hostname.sh and set-vars.sh are executable.

Check file mode (permissions) and ownership.
```bash
ls -asl ./clean-up.sh
```

Set the file to be executable.
```bash
chmod +x ./clean-up.sh
```

## Running the scrpts

N.B. [Sudoers privileges](https://www.linuxfoundation.org/blog/blog/classic-sysadmin-configuring-the-linux-sudoers-file) are required to run the scripts. For instructions on how to grant sudoer privileges, check out the [Linuxize](https://linuxize.com) article ['How to Add User to Sudoers in Ubuntu'](https://linuxize.com/post/how-to-add-user-to-sudoers-in-ubuntu/).

##### Effecting changes to the hostname and static IP address

To set a new hostname and static IP address in the machine use the ./set-hostname.sh script and supply the hostname and IP address component.

Currently, the scripts only change the host (last) segment of the IP address. I do plan to add the functionality to change each segment but, for now this meets my needs.

Example IP: `192.168.56.17`

IP Address Segments: **Network ID** `192.168.56.` **Host ID** `17`

The arguments need to be supplied to the script in the correct order. The hostname should be supplied first, followed by the IP segment.

So, for the hostname `node1`, and the IP Address `192.168.56.17`, call the `./set-hostname.sh` script as follows:

```bash
./set-hostname.sh node1 17
```

## Cleaning up!

The clean up script is currently just for removing files that have been changed during testing within the scripts own test directories. It then will replace those files with template files from its own templates directory. It does not yet have the ability to revert changes but, the functionality is nearly there.

If the `./clean-up.sh` script is run on a machines /etc directory it will not reestablish the machines previous hostname and IP address. They will just replace the machines `/etc/hosts`, `/etc/hostname`, and `/etc/netplan/10-netplan-config.yaml` files with its own templates.

To clean up during testing just run the `./clean-up.sh` script and respond to the question to tell the script whether it should clean up just the hostname files, just the IP address files or everything.

# To come

Moving Forward the following will be implemented:

Set all IP Segments
:Set all segments of the IP Address or select from standard defaults

Revert Changes
:Revert changes made to the hosts `/etc` directory files

Multiple Choice
:Multiple choice based interactions for all functionality and eliminate the need to call different scripts and supply arguments as the script is called.