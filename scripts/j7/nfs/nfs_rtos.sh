#!/bin/sh
# Refer to below link
# https://e2e.ti.com/support/processors-group/processors/f/processors-forum/984034/faq-tda4vm-how-to-enable-nfs-on-psdkra

Run ./setup.sh from ti-sdk installer
Run sudo minicom -S ./bin/setupBoard.minicom
Power cycle board
The steps in the minicom script will execute. 
Ctrl-C 2x to cancel failed network loads
Run steps below (with your own local IP address)
Boot works

setenv serverip_to_set <your_host_ip_address>
setenv serverip ${serverip_to_set}
setenv init_net 'run args_all args_net; setenv autoload no;dhcp; setenv serverip ${serverip_to_set};rproc init; run boot_rprocs_mmc; rproc list;'
setenv rproc_fw_binaries '2 /lib/firmware/j7-main-r5f0_0-fw 3 /lib/firmware/j7-main-r5f0_1-fw 6 /lib/firmware/j7-c66_0-fw 7 /lib/firmware/j7-c66_1-fw 8 /lib/firmware/j7-c71_0-fw'
setenv rproc_load_and_boot_one 'if nfs $loadaddr ${serverip}:${nfs_root}/${rproc_fw};then if rproc load ${rproc_id} ${loadaddr} ${filesize}; then rproc start ${rproc_id};fi;fi'
setenv overlay_files 'k3-j721e-vision-apps.dtbo'
setenv overlayaddr ${dtboaddr}
setenv args_net 'setenv bootargs console=${console} ${optargs} rootfstype=nfs root=/dev/nfs rw nfsroot=${serverip}:${nfs_root},${nfs_options} ip=dhcp'
setenv setup_net 'setenv autoload no; dhcp; setenv serverip ${serverip_to_set}'
boot