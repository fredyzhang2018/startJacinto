# This script is using for setup the model envirionment: 
# Steps: 1. prepare the module .onnx
#        2. prepare the import_ import configure files. 
#        3. prepare the infer_  inference configure files. 
#        4. prepare the test pictures. 
script_path=$(cd $(dirname $0); pwd)
script_dir=`echo $script_path | awk -F"/" '{ print $8 }'`
modle_type=`echo $script_path | awk -F"/" '{ print $7 }'`
TIDL_PATH_PRINT=$SJ_PATH_PSDKRA/`ls $SJ_PATH_PSDKRA | grep tidl`/ti_dl

DICTORY_NAME=$script_dir
RUNTIME_TYPE=$modle_type


# TODO Check the below setting before running the demo. 
if [ -d $script_path/input_images ];then 
    MODEL_INPUT_SET="yes"  # model input data setting. 
    MODEL_YUV_INPUT="no"
else 
    MODEL_INPUT_SET="no"  # model input data setting. 
fi 

if [ -f $script_path/config_inference_list.txt ];then
    CONFIG_INFERENCE_LIST="yes"
else 
    CONFIG_INFERENCE_LIST="no"
fi

if [ $RUNTIME_TYPE == "onnx" ];then 
    MODEL_NET=$modle_type
    rm ./$DICTORY_NAME.$MODEL_NET # delete the original model. 
    INPUT_MODEL_NAME=`ls *.onnx`
    INPUT_IMPORT_CONFIG=`ls import_*`
    INPUT_INFER_CONFIG=`ls infer_*`
elif [ $RUNTIME_TYPE == "tflite" ];then 
    MODEL_NET=$modle_type
    rm ./$DICTORY_NAME.$MODEL_NET # delete the original model. 
    INPUT_MODEL_NAME=`ls *.tflite`
    INPUT_IMPORT_CONFIG=`ls import_*`
    INPUT_INFER_CONFIG=`ls infer_*`
elif [ $RUNTIME_TYPE == "tensorflow" ];then 
    MODEL_NET=pb
    rm ./$DICTORY_NAME.$MODEL_NET # delete the original model. 
    INPUT_MODEL_NAME=`ls *.pb`
    INPUT_IMPORT_CONFIG=`ls import_*`
    INPUT_INFER_CONFIG=`ls infer_*`
elif [ $RUNTIME_TYPE == "caffe" ];then 
    MODEL_NET=prototxt
    MODEL_PARAM=caffemodel
    rm ./$DICTORY_NAME.$MODEL_NET # delete the original model. 
    INPUT_MODEL_NAME=`ls *.prototxt`
    INPUT_MODEL_PARAM_NAME=`ls *.caffemodel`
    INPUT_IMPORT_CONFIG=`ls import_*`
    INPUT_INFER_CONFIG=`ls infer_*`
else 
    echo "Model type is not correct, please check . Thanks. "
fi

# Print Variable for check: 
echo "[ `date` ] >>> 0. check the variable  "
echo "- DICTORY_NAME : $DICTORY_NAME"
echo "- RUNTIME_TYPE : $RUNTIME_TYPE"
echo "- MODEL_NET    : $MODEL_NET"
if [ $RUNTIME_TYPE == "caffe" ];then 
    echo "- MODEL_PARAM : $MODEL_PARAM"
fi
echo "- INPUT_MODEL_NAME : $INPUT_MODEL_NAME"
if [ $RUNTIME_TYPE == "caffe" ];then 
    echo "- INPUT_MODEL_PARAM_NAME : $INPUT_MODEL_PARAM_NAME"
fi
echo "- INPUT_IMPORT_CONFIG : $INPUT_IMPORT_CONFIG"
echo "- INPUT_INFER_CONFIG : $INPUT_INFER_CONFIG"
echo "- MODEL_INPUT_SET : $MODEL_INPUT_SET"
echo "- CONFIG_INFERENCE_LIST : $CONFIG_INFERENCE_LIST"
echo "- TIDL_PATH_PRINT : $TIDL_PATH_PRINT"
echo "[ `date` ] >>> 1.  prepare the model and configure files. "

echo "cp  -v $INPUT_MODEL_NAME               ./$DICTORY_NAME.$MODEL_NET"
cp  -vr $INPUT_MODEL_NAME               ./$DICTORY_NAME.$MODEL_NET
if [ $RUNTIME_TYPE == "caffe" ];then 
cp  -v $INPUT_MODEL_PARAM_NAME         ./$DICTORY_NAME.$MODEL_PARAM
fi

if [ $MODEL_YUV_INPUT == "yes" ];then 
    INPUT_IMPORT_CONFIG=`ls yuv_import_*`
    INPUT_INFER_CONFIG=`ls yuv_infer_*`
    cp  -v $INPUT_IMPORT_CONFIG            ./tidl_import_$DICTORY_NAME.txt
    cp  -v $INPUT_INFER_CONFIG             ./tidl_infer_$DICTORY_NAME.txt
else 
    cp  -v $INPUT_IMPORT_CONFIG            ./tidl_import_$DICTORY_NAME.txt
    cp  -v $INPUT_INFER_CONFIG             ./tidl_infer_$DICTORY_NAME.txt
fi 
# update picture path: 
if [ $MODEL_YUV_INPUT == "yes" ];then 
    ls  ./input_images_yuv/*  >   ./config_inference.txt
else
    ls  ./input_images/*  >   ./config_inference.txt
fi 

sed -i "s/^/.\/testvecs\/models\/public\/$RUNTIME_TYPE\/$DICTORY_NAME\/&/g"  ./config_inference.txt

# 2. update the import configration file. 
echo "[ `date` ] >>> 2. configure  $DICTORY_NAME import file"
sed -i "/^inputNetFile/c inputNetFile               = \"../../test/testvecs/models/public/${RUNTIME_TYPE}/${DICTORY_NAME}/${DICTORY_NAME}.${MODEL_NET}\""  ./tidl_import_$DICTORY_NAME.txt
if [ $RUNTIME_TYPE == "caffe" ];then 
    sed -i "/^inputParamsFile/c inputParamsFile         = \"../../test/testvecs/models/public/${RUNTIME_TYPE}/${DICTORY_NAME}/${DICTORY_NAME}.${MODEL_PARAM}\""  ./tidl_import_$DICTORY_NAME.txt
fi 
sed -i "/^outputNetFile/c outputNetFile             = \"../../test/testvecs/config/tidl_models/${RUNTIME_TYPE}/tidl_net_${DICTORY_NAME}.bin\""  ./tidl_import_$DICTORY_NAME.txt
sed -i "/^outputParamsFile/c outputParamsFile       = \"../../test/testvecs/config/tidl_models/${RUNTIME_TYPE}/tidl_io_${DICTORY_NAME}_\""  ./tidl_import_$DICTORY_NAME.txt

if [ "yes" == "$MODEL_INPUT_SET" ]; then
    # 2.1 update the $DICTORY_NAME inData -- optional.
    echo "[ `date` ] >>> 1.1 update the  $DICTORY_NAME inData"
    sed -i "/^inData /c inData = \"../../test/testvecs/models/public/${RUNTIME_TYPE}/${DICTORY_NAME}/config_inference.txt\""  ./tidl_import_$DICTORY_NAME.txt
fi 
# 3. update the inference configration file.  
echo "[ `date` ] >>> 3. configure  $DICTORY_NAME infer file"
sed -i "/^netBinFile/c netBinFile        = \"testvecs/config/tidl_models/${RUNTIME_TYPE}/tidl_net_${DICTORY_NAME}.bin\""     ./tidl_infer_$DICTORY_NAME.txt
sed -i "/^ioConfigFile/c ioConfigFile    = \"testvecs/config/tidl_models/${RUNTIME_TYPE}/tidl_io_${DICTORY_NAME}_1.bin\""    ./tidl_infer_$DICTORY_NAME.txt
sed -i "/^outData/c outData    = \"testvecs/output/tidl_${RUNTIME_TYPE}_${DICTORY_NAME}_output.bin\""                        ./tidl_infer_$DICTORY_NAME.txt

if [ "yes" == "$MODEL_INPUT_SET" ]; then
    # 3.1 update the $DICTORY_NAME inData --- optional
    echo "[ `date` ] >>> 3.1 update the  $DICTORY_NAME inData"
    #sed -i "/^inData /c inData = \"testvecs/models/public/${RUNTIME_TYPE}/${DICTORY_NAME}/config_inference.txt\""  ./tidl_infer_$DICTORY_NAME.txt
    #sed -i "/^inData /c inData = \"testvecs/config/classification_lane_dection.txt\""  ./tidl_infer_$DICTORY_NAME.txt
    sed -i "/^inData /c inData = \"testvecs/config/config_inference.txt\""  ./tidl_infer_$DICTORY_NAME.txt
fi

if [ "yes" == "$CONFIG_INFERENCE_LIST" ]; then
    echo "[ `date` ] >>> 4 config the inference list"
    rm ./config_inference_list.txt
    rm ./config_inference_evm_list.txt
    LIST_IMAGS_NUM=`seq -f %010.0f 0 0`
    post_suffix="bin"
    for num in $LIST_IMAGS_NUM
    do 
        echo "1 $TIDL_PATH_PRINT/test/testvecs/config/infer/public/$RUNTIME_TYPE/tidl_infer_$DICTORY_NAME.txt \
                --inData  $TIDL_PATH_PRINT/test/testvecs/models/public/${RUNTIME_TYPE}/$DICTORY_NAME/input_images/$num.$post_suffix \
                --outData $TIDL_PATH_PRINT/test/trace/inference/result_$num" >> ./config_inference_list.txt 
        echo "1 /opt/tidl_test/testvecs/config/infer/public/$RUNTIME_TYPE/tidl_infer_$DICTORY_NAME.txt \
                --inData  /opt/tidl_test/testvecs/models/public/${RUNTIME_TYPE}/$DICTORY_NAME/input_images/$num.$post_suffix \
                --outData /opt/tidl_test/trace/inference/result_$num" >> ./config_inference_evm_list.txt
    done 
    echo "2 it will stop at the next line, do not remove 0 at last line. " >> ./config_inference_list.txt 
    echo "0" >> ./config_inference_list.txt 
    echo "2 it will stop at the next line, do not remove 0 at last line. " >> ./config_inference_evm_list.txt
    echo "0" >> ./config_inference_evm_list.txt 
fi 

echo "[ `date` ] >>> 4. setup $DICTORY_NAME done"