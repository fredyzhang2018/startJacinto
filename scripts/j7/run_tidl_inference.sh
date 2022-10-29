#! /bin/sh
# @Author : fredyzhang2018@gmail.com
# @Date   : 2-11-2022

INFERENCE_LIST=no
echo "`date` : ###############################################################"
echo "`date` : >>> 0. INFERENCE_LIST set :  $INFERENCE_LIST"
echo "`date` : ###############################################################"
echo "`date` : >>> 1. setup the trace dictory"
rm -rf /opt/tidl_test/trace
mkdir -p  /opt/tidl_test/trace
mkdir -p  /opt/tidl_test/trace/inference
echo "`date` : >>> 2. export the path: "
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib
TEST_FILE_NULL=`cd /opt/tidl_test/ && ./TI* | grep "Couldn't open Paramete"`
echo "TEST_FILE_NULL = $TEST_FILE_NULL"
echo "`date` : >>> 3. run tidl inference on evm"
if [  "$TEST_FILE_NULL" != ""  ]; then
    echo "`date` : >>>   Could't find the file"
    INFERENCE_NAME=`cd /opt/tidl_test/ && ./TI* | grep "Processing config" | awk -F" : " '{ print $2 }'`
    echo "INFERENCE_NAME = $INFERENCE_NAME"
    cd /opt/tidl_test && rm $INFERENCE_NAME
    echo "`date` : >>>   please run on startjacinto : make tidl-sd-model-setup"
    echo "`date` : >>>   then run this scipts again"
else
    if [  "$INFERENCE_LIST" == "yes"  ]; then
        cd /opt/tidl_test/ && ./TI_DEVICE_a72_test_dl_algo_host_rt.out /opt/tidl_test/testvecs/config/config_inference_evm_list.txt 
    else 
        cd /opt/tidl_test/ && ./TI_DEVICE_a72_test_dl_algo_host_rt.out 
    fi
fi
echo "`date`  : >>> check the trace file "
ls -l /opt/tidl_test/trace
echo "`date`  : >>> please run below command to compare the result on ubuntu "
echo "`date`  : >>> make tidl-model-inference-trace-check"


