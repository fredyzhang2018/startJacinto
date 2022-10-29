#!/bin/bash
# This script is using for check the TIDL inferecne trace.
# @Author : Fredy Zhang  
# @email  ：fredyzhang2018@gmail.com 
# @date   ：2022-02-11

# Get the filename from the file dictroy. 
FILE_LIST_EMULATION=$(ls ./trace/pc_emulation)
FILE_LIST_EVM=$(ls ./trace/evm)
FILE_LIST_IMPORTER=$(ls ./trace/importer)
FILE_LIST_INFERENCE_OUTPUT=$(ls ./trace/evm/inference/)
FILE_LIST_INFER_FLOAT_OUTPUT=$(ls ./trace/compare_layer/parm16)
TIDL_PATH_PRINT=$SJ_PATH_PSDKRA/`ls $SJ_PATH_PSDKRA | grep tidl`/ti_dl
echo "[ `date` ] : ---  >>> start $1"
echo " - TIDL PATH : $TIDL_PATH_PRINT"
echo " - inference trace PC  PATH: $TIDL_PATH_PRINT/test/trace/"
echo " - inference trace EVM PATH: /opt/tidl_test/trace/"

if [ $1 == "IMPORT_vs_INFERENCE" ]; then
    for filename in $FILE_LIST_EMULATION
    do
        # 0802 :
        mv  ./trace/importer/`echo $filename | sed 's/infer/import/g' | sed 's/txt_0/txt0/g'` ./trace/importer/`echo $filename | sed 's/infer/import/g'`
        # Original 
        # mv  ./trace/importer/`echo $filename | sed 's/infer/import/g' | sed 's/txt_0/txt0/g'` ./trace/importer/`echo $filename | sed 's/infer/import/g' | sed 's/txt0/txt_0/g'`
        # ls -l  /trace/importer/`echo $filename | sed 's/infer/import/g' | sed 's/txt0/txt_0/g'`
        cmp ./trace/pc_emulation/$filename  ./trace/importer/`echo $filename | sed 's/infer/import/g' `
    done
fi 
sync
if [ $1 == "PC_vs_EVM" ]; then
    echo "[ `date` ] : ---  >>> evm vs pc"
    for filename in $FILE_LIST_EMULATION
    do
        cmp ./trace/pc_emulation/$filename  ./trace/evm/$filename
    done
    echo "[ `date` ] : ---  >>> evm vs pc done"

    if [ -d ./trace/evm/inference ]; then
        echo "[ `date` ] : ---  >>> evm vs pc inference output"
        for filename in $FILE_LIST_INFERENCE_OUTPUT
        do
            echo "./trace/pc_emulation/inference/$filename  ./trace/evm/inference/$filename"
            cmp ./trace/pc_emulation/inference/$filename  ./trace/evm/inference/$filename
        done
        echo "[ `date` ] : ---  >>> evm vs pc inference"
    fi 
fi 

if [ $1 == "Layer_Float_8_vs_16" ]; then
    echo "[ `date` ] >>> Layer_Float_8_vs_16"
    rm ./trace/compare_layer/trcae_files_list.txt
    for t_flie in $FILE_LIST_INFER_FLOAT_OUTPUT
    do 
        echo "./parm8/$t_flie  ./parm16/$t_flie" >> ./trace/compare_layer/trcae_files_list.txt
    done
fi 

echo "[ `date` ] : ---  >>> done $1  !!!"