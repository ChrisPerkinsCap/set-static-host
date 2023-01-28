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

N.B. [Sudoers privileges](https://www.linuxfoundation.org/blog/blog/classic-sysadmin-configuring-the-linux-sudoers-file) are required to run the scripts. For instructions on how to grant sudoer privileges check out the [Linuxize](https://linuxize.com) article ['How to Add User to Sudoers in Ubuntu'](https://linuxize.com/post/how-to-add-user-to-sudoers-in-ubuntu/).

##### Effecting changes to the hostname and static IP address

To set a new hostname and static IP address in the machine use the ./set-hostname.sh script and supply the hostname and IP address component.

Currently the scripts only change the host (last) segment of the IP address. I do plan to add the functionality to change each segment but, for now this meets my needs.

Example IP: `192.168.56.17`

IP Address Segments: **Network ID** `192.168.56.` **Host ID** `17`

The argumentss need to be supplied to the script in the correct order. The hostname should be supplied first and the IP segment