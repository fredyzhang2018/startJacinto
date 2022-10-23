#!/bin/sh
#############################################################################################
# This script is using for running the command on remote machine.                           #
#     You should make sure you can login the remote shell without password.     
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-02-16                                                                      # 
##############################################################################################

VALID_ARGS=(--list -l --help -h --ip)
echo "profile $PROFILE"
# LOG _LEVEL: debug or no
LOG_LEVEL=debug
echo_log()
{
	if [ $LOG_LEVEL == "debug" ]; then
		echo $1
	fi
}
# --- usage introduction. 
usage()
{
	echo "[ $(date) ] >>> # $0 - To launch the startJacinto tools"
	echo "[ $(date) ] >>> # $0 --list  | -l - To list all the supported SDKs Selections"
	echo "[ $(date) ] >>> # $0 --help  | -h - To display this"
	echo "[ $(date) ] >>> # $0 --ip  command - To set the IP "
}

# --- check the arguments
check_args()
{
	echo_log "[ $(date) ] >>> $0 starting check args  >>> " 
	if [ "$1" == "" ]
	then
		return 0
	fi
	for i in "${VALID_ARGS[@]}"
	do
		if [ "$1" == "$i" ]
		then
			return 0
		fi
	done
	usage
	exit 0
}

# --- parse arguments
parse_args()
{  
	echo_log "[ $(date) ] >>> starting parse args >>>>> " 
}

launch()
{
	# $1 :IP 
	# update user file 
	update_user_files

	# update_application_and_scripts $1 
	# update_imaging_sensor_dcc      $1 
	# update_ptk_cfg                 $1
	# update the local build to remote machine over scp. 
	# scp -r /tmp/tivision_apps_targetfs_stage/*           root@$1:/      # update all
	# scp -r /tmp/tivision_apps_targetfs_stage/lib root@$1:/          # update /lib/
	# scp -r /tmp/tivision_apps_targetfs_stage/opt root@$1:/          # update /opt/
	# scp -r /tmp/tivision_apps_targetfs_stage/usr root@$1:/          # update /usr/
	# opt update : imaging/                   tidl_test/                 vision_apps/               vx_app_arm_remote_log.out
	scp -r /tmp/tivision_apps_targetfs_stage/opt/vision_apps   root@$1:/opt/     # update tidl_test	
	# scp -r /tmp/tivision_apps_targetfs_stage/opt/tidl_test   root@$1:/opt/     # update tidl_test
	# scp -r /tmp/tivision_apps_targetfs_stage/opt/imaging     root@$1:/opt/     # update imaging
	# scp -r /tmp/tivision_apps_targetfs_stage/optvx_app_arm_remote_log.out     root@$1:/opt/  # update reomte log 
	
	ssh root@$1 "chmod +x /opt/vision_apps/*.sh; sync;"
}

update_user_files()
{
	echo_log "update user files: $SJ_PATH_JACINTO $SJ_PATH_JACINTO/reach_dof_test"
	cp $SJ_PATH_JACINTO/downloads/reach_dof_test/run_app_dof_test.sh /tmp/tivision_apps_targetfs_stage/opt/vision_apps
	cp $SJ_PATH_JACINTO/downloads/reach_dof_test/app_dof_test.cfg /tmp/tivision_apps_targetfs_stage/opt/vision_apps
	mkdir -p /tmp/tivision_apps_targetfs_stage/opt/vision_apps/data/dof_out
	# ii=10
	# for i in {0..10}
	# do
	# 	mv $SJ_PATH_JACINTO/downloads/reach_dof_test/data/app_dof/IMG_00$ii.bmp $SJ_PATH_JACINTO/downloads/reach_dof_test/data/app_dof/00$ii.bmp
	# 	ii=`expr $ii + 1`
	# done
	cp -r $SJ_PATH_JACINTO/downloads/reach_dof_test/data/*  /tmp/tivision_apps_targetfs_stage/opt/vision_apps/data/
}

update_application_and_scripts()
{
	# $1 :IP 
	# copy application binaries and scripts
	# mkdir -p /tmp/tivision_apps_targetfs_stage/opt/vision_apps
	# cp /ti/j7/workarea/vision_apps/out/J7/A72/LINUX/release/*.out /tmp/tivision_apps_targetfs_stage/opt/vision_apps || true
	# cp /ti/j7/workarea/vision_apps/out/J7/A72/LINUX/release/vx_app_arm_remote_log.out /tmp/tivision_apps_targetfs_stage/opt || true
	# cp /ti/j7/workarea/vision_apps/out/J7/A72/LINUX/release/libtivision_apps.so.8.1.0 /tmp/tivision_apps_targetfs_stage/usr/lib
	# cp -P /ti/j7/workarea/vision_apps/out/J7/A72/LINUX/release/libtivision_apps.so /tmp/tivision_apps_targetfs_stage/usr/lib
	# cp -r /ti/j7/workarea/vision_apps/apps/basic_demos/app_linux_fs_files/* /tmp/tivision_apps_targetfs_stage/opt/vision_apps
	# chmod +x /tmp/tivision_apps_targetfs_stage/opt/vision_apps/*.sh
	echo_log "[ $(date) ] >>> copy application binaries and scripts   !!!" 
	scp $SJ_PATH_PSDKRA/vision_apps/out/J7/A72/LINUX/release/*.out                      root@$1:/opt/vision_apps
	scp $SJ_PATH_PSDKRA/vision_apps/out/J7/A72/LINUX/release/vx_app_arm_remote_log.out  root@$1:/opt/
	# scp $SJ_PATH_PSDKRA/vision_apps/out/J7/A72/LINUX/release/libtivision_apps.so.8.1.0  root@$1:/usr/lib
	# scp $SJ_PATH_PSDKRA/vision_apps/out/J7/A72/LINUX/release/libtivision_apps.so        root@$1:/usr/lib
	scp $SJ_PATH_PSDKRA/vision_apps/apps/basic_demos/app_linux_fs_files/*               root@$1:/opt/vision_apps
	ssh root@$1 "chmod +x /opt/vision_apps/*.sh; sync;"
}


update_imaging_sensor_dcc()
{
# # copy imaging sensor dcc binaries
# mkdir -p /tmp/tivision_apps_targetfs_stage/opt/imaging/imx390
# mkdir -p /tmp/tivision_apps_targetfs_stage/opt/imaging/ar0820
# mkdir -p /tmp/tivision_apps_targetfs_stage/opt/imaging/ar0233
# mkdir -p /tmp/tivision_apps_targetfs_stage/opt/imaging/imx219
# cp /ti/j7/workarea/imaging/sensor_drv/src/imx390/dcc_bins/*.bin /tmp/tivision_apps_targetfs_stage/opt/imaging/imx390
# cp /ti/j7/workarea/imaging/sensor_drv/src/ar0820/dcc_bins/*.bin /tmp/tivision_apps_targetfs_stage/opt/imaging/ar0820
# cp /ti/j7/workarea/imaging/sensor_drv/src/ar0233/dcc_bins/*.bin /tmp/tivision_apps_targetfs_stage/opt/imaging/ar0233
# cp /ti/j7/workarea/imaging/sensor_drv/src/imx219/dcc_bins/*.bin /tmp/tivision_apps_targetfs_stage/opt/imaging/imx219
	echo_log "[ $(date) ] >>> copy application binaries and scripts   !!!" 
	scp $SJ_PATH_PSDKRA/imaging/sensor_drv/src/imx390/dcc_bins/*.bin                     root@$1:/opt/imaging/imx390
	scp $SJ_PATH_PSDKRA/imaging/sensor_drv/src/ar0820/dcc_bins/*.bin                     root@$1:/opt/imaging/ar0820
	scp $SJ_PATH_PSDKRA/imaging/sensor_drv/src/ar0233/dcc_bins/*.bin                     root@$1:/opt/imaging/ar0233
	scp $SJ_PATH_PSDKRA/imaging/sensor_drv/src/imx219/dcc_bins/*.bin                     root@$1:/opt/imaging/imx219
	ssh root@$1 "sync;"
}

update_ptk_cfg()
{
# # copy ptk cfg files
# mkdir -p /tmp/tivision_apps_targetfs_stage/opt/vision_apps/ptk_app_cfg
# for var in app_surround_radar_ogmap app_dof_sfm_fisheye app_lidar_ogmap app_valet_parking app_sde app_sde_obstacle_detection app_sde_ldc; do \
#         mkdir -p /tmp/tivision_apps_targetfs_stage/opt/vision_apps/ptk_app_cfg/$var; \
#         cp -R /ti/j7/workarea/vision_apps/apps/ptk_demos/$var/config /tmp/tivision_apps_targetfs_stage/opt/vision_apps/ptk_app_cfg/$var; \
# done
echo ""
}

# Starting to run
check_args $1
parse_args $1
case $1 in
	"--list" | "-l")
		usage
		;;
	"--help" | "-h")
		usage
		;;
	"--ip"         )
		launch $2 
		;;
	"")
		usage
		;;
esac
echo_log "[ $(date) ] >>> $0 done   !!!" 
#---------------------------------------------------------------------------



# # Copy header files (variables used in this section are defined in makefile_ipk.mak)
# for folder in imaging/algos/dcc/include imaging/algos/ae/include imaging/algos/awb/include imaging/itt_server_remote/include imaging/kernels/include imaging/ti_2a_wrapper/include imaging/sensor_drv/include ivision perception/include tiadalg tidl_j7_08_01_00_05/ti_dl/inc tiovx/conformance_tests/test_engine tiovx/include tiovx/kernels/include tiovx/kernels_j7/include tiovx/utils/include vision_apps/platform/j721e vision_apps/apps/ptk_demos/applibs vision_apps/apps/ptk_demos/app_common vision_apps/applibs vision_apps/kernels vision_apps/modules vision_apps/utils; do \
#         mkdir -p /tmp/tivision_apps_targetfs_stage/usr/include/processor_sdk/$folder; \
#         (cd /ti/j7/workarea/$folder && find . -name '*.h' -print | tar --create --files-from -) | (cd /tmp/tivision_apps_targetfs_stage/usr/include/processor_sdk/$folder && tar xfp -); \
# done
# ln -sr /tmp/tivision_apps_targetfs_stage/usr/include/processor_sdk/tidl_j7_08_01_00_05 /tmp/tivision_apps_targetfs_stage/usr/include/processor_sdk/tidl_j7
# # Copy MCU1_0 firmware which is used in the default uboot
# ln -sr /tmp/tivision_apps_targetfs_stage/lib/firmware/pdk-ipc/ipc_echo_testb_mcu1_0_release_strip.xer5f /tmp/tivision_apps_targetfs_stage/lib/firmware/j7-mcu-r5f0_0-fw
# # copy remote firmware files for mcu2_0
# cp /ti/j7/workarea/vision_apps/out/J7/R5F/FREERTOS/release/vx_app_rtos_linux_mcu2_0.out /tmp/tivision_apps_targetfs_stage/lib/firmware/vision_apps_evm/.
# /ti/j7/workarea/ti-cgt-armllvm_1.3.0.LTS/bin/tiarmstrip -p /tmp/tivision_apps_targetfs_stage/lib/firmware/vision_apps_evm/vx_app_rtos_linux_mcu2_0.out
# ln -sr /tmp/tivision_apps_targetfs_stage/lib/firmware/vision_apps_evm/vx_app_rtos_linux_mcu2_0.out /tmp/tivision_apps_targetfs_stage/lib/firmware/j7-main-r5f0_0-fw
# # copy remote firmware files for mcu2_1
# cp /ti/j7/workarea/vision_apps/out/J7/R5F/FREERTOS/release/vx_app_rtos_linux_mcu2_1.out /tmp/tivision_apps_targetfs_stage/lib/firmware/vision_apps_evm/.
# /ti/j7/workarea/ti-cgt-armllvm_1.3.0.LTS/bin/tiarmstrip -p /tmp/tivision_apps_targetfs_stage/lib/firmware/vision_apps_evm/vx_app_rtos_linux_mcu2_1.out
# ln -sr /tmp/tivision_apps_targetfs_stage/lib/firmware/vision_apps_evm/vx_app_rtos_linux_mcu2_1.out /tmp/tivision_apps_targetfs_stage/lib/firmware/j7-main-r5f0_1-fw
# # copy remote firmware files for c6x_1
# cp /ti/j7/workarea/vision_apps/out/J7/C66/FREERTOS/release/vx_app_rtos_linux_c6x_1.out /tmp/tivision_apps_targetfs_stage/lib/firmware/vision_apps_evm/.
# /ti/j7/workarea/ti-cgt-c6000_8.3.7/bin/strip6x -p /tmp/tivision_apps_targetfs_stage/lib/firmware/vision_apps_evm/vx_app_rtos_linux_c6x_1.out
# ln -sr /tmp/tivision_apps_targetfs_stage/lib/firmware/vision_apps_evm/vx_app_rtos_linux_c6x_1.out /tmp/tivision_apps_targetfs_stage/lib/firmware/j7-c66_0-fw
# # copy remote firmware files for c6x_2
# cp /ti/j7/workarea/vision_apps/out/J7/C66/FREERTOS/release/vx_app_rtos_linux_c6x_2.out /tmp/tivision_apps_targetfs_stage/lib/firmware/vision_apps_evm/.
# /ti/j7/workarea/ti-cgt-c6000_8.3.7/bin/strip6x -p /tmp/tivision_apps_targetfs_stage/lib/firmware/vision_apps_evm/vx_app_rtos_linux_c6x_2.out
# ln -sr /tmp/tivision_apps_targetfs_stage/lib/firmware/vision_apps_evm/vx_app_rtos_linux_c6x_2.out /tmp/tivision_apps_targetfs_stage/lib/firmware/j7-c66_1-fw
# # copy remote firmware files for c7x_1
# cp /ti/j7/workarea/vision_apps/out/J7/C71/FREERTOS/release/vx_app_rtos_linux_c7x_1.out /tmp/tivision_apps_targetfs_stage/lib/firmware/vision_apps_evm/.
# /ti/j7/workarea/ti-cgt-c7000_2.0.1.STS/bin/strip7x -p /tmp/tivision_apps_targetfs_stage/lib/firmware/vision_apps_evm/vx_app_rtos_linux_c7x_1.out
# ln -sr /tmp/tivision_apps_targetfs_stage/lib/firmware/vision_apps_evm/vx_app_rtos_linux_c7x_1.out /tmp/tivision_apps_targetfs_stage/lib/firmware/j7-c71_0-fw
# #Build TIDL test case and copy binaries
# #make -C /ti/j7/workarea/tidl_j7_08_01_00_05/ti_dl/../ run
# mkdir -p /tmp/tivision_apps_targetfs_stage/opt/tidl_test
# cp -P /ti/j7/workarea/tidl_j7_08_01_00_05/ti_dl/tfl_delegate/out/J7/A72/LINUX/release/*.so*  /tmp/tivision_apps_targetfs_stage/usr/lib
# cp -P /ti/j7/workarea/tidl_j7_08_01_00_05/ti_dl/rt/out/J7/A72/LINUX/release/*.so*  /tmp/tivision_apps_targetfs_stage/usr/lib
# cp -P /ti/j7/workarea/tidl_j7_08_01_00_05/ti_dl/onnxrt_EP/out/J7/A72/LINUX/release/*.so*  /tmp/tivision_apps_targetfs_stage/usr/lib
# cp /ti/j7/workarea/tidl_j7_08_01_00_05/ti_dl/rt/out/J7/A72/LINUX/release/*.out  /tmp/tivision_apps_targetfs_stage/opt/tidl_test/
# cp -r /ti/j7/workarea/tidl_j7_08_01_00_05/ti_dl/test/testvecs/ /tmp/tivision_apps_targetfs_stage/opt/tidl_test/
# sync
# # remove old remote files from filesystem
# rm -f /ti/j7/workarea/targetfs//lib/firmware/j7-*-fw
# rm -rf /ti/j7/workarea/targetfs//lib/firmware/vision_apps_evm
# rm -rf /ti/j7/workarea/targetfs//opt/tidl_test/*
# rm -rf /ti/j7/workarea/targetfs//opt/notebooks/*
# rm -rf /ti/j7/workarea/targetfs//usr/include/processor_sdk/*
# # create new directories
# mkdir -p /ti/j7/workarea/targetfs//usr/include/processor_sdk
# # copy full vision apps linux fs stage directory into linux fs
# cp -r /tmp/tivision_apps_targetfs_stage/* /ti/j7/workarea/targetfs//.
# sync	

#---------------------------------------------------------------------------
