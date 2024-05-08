#
# Utility makefile to build PDK libaries and related components
#
# Edit this file to suit your specific build needs
#
## compare the model result
SJ_TIDL_COMPARE_IMPORT_AND_INFERENCE ?=no
SJ_TIDL_COMPARE_INFERENCE_PC_AND_EVM ?=yes
# Tensorflow and Tensorflow Lite Model Usage:
# --- Please CONFIG:  ti_dl_MODEL && SJ_TIDL_RUNTIME_TYPE
# 	Tensorflow: mobilenetv2
# 	TFLITE    : fredy_mobilenetv2 mobilenetv2 inceptionnetv1 mobilenetv2_yuv
#   Caffe     : peelenet jsegnet21v2 lane_detection yuv2rgb_demo
#   Onnx      : squeeze_net mobilenetv2 vgg16
#  edgeai onnx:  mobilenetv2 mobilenetv2_od mobilenetv2_seg
ti_dl_MODEL ?= mobilenetv2_yuv
# RUNTIME type : tensorflow tflite caffe onnx
SJ_TIDL_RUNTIME_TYPE ?=onnx
SJ_TIDL_IMPORT_SET      ?= yes
SJ_TIDL_INFERENCE_SET   ?= yes
SJ_TIDL_INFERENCE_CONFIG_LIST   ?= no
# --------------edge ai only ------------------------------------------
SJ_TIDL_IMPORT_INTERFERN_WITH_TIDL?=yes
SJ_EDGEAI_VERSION?=09_02_06_00
SJ_EDGEAI_GPU_TOOLS?=no
# --------------edge ai only ------------------------------------------done!!!
# 	1. $(SJ_TIDL_TFLITE_MODEL)_1.0_224_frozen.pb
#   2. $(SJ_TIDL_TFLITE_MODEL).pb
ti_dl_MODEL_INPUT_NAME=$(ti_dl_MODEL)
#   1. $(SJ_TIDL_TFLITE_MODEL)_1.0_224_final.pb 
#   2. $(SJ_TIDL_TFLITE_MODEL)_final.pb
ti_dl_MODEL_OUTPUT_NAME =$(ti_dl_MODEL)_final
#   1. tidl_import_mobileNetv2.txt
#   2. tidl_import_$(SJ_TIDL_TFLITE_MODEL).txt
ti_dl_MODEL_MODEL_IMPORT_CONFIG = tidl_import_$(ti_dl_MODEL).txt
#   1. tidl_infer_mobileNetv2.txt
#   2. tidl_infer_$(SJ_TIDL_TFLITE_MODEL).txt
ti_dl_MODEL_MODEL_INFERENCE_CONFIG = tidl_infer_$(ti_dl_MODEL).txt
#   Optimization for Tensorflow: yes or no
ifeq  ($(SJ_TIDL_RUNTIME_TYPE),tensorflow)
ti_dl_MODEL_OPTIMIZED ?= yes
else
ti_dl_MODEL_OPTIMIZED ?= no
endif
# Model Zoo
ti_dl_MODEL_ZOO ?= $(SJ_PATH_SDK)/models-zoo/
# Fucntions : sj_tidl_path
define sj_tidl_path
    SJ_TIDL_PATH_PRINT=$(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl
	$(1) := $$(SJ_TIDL_PATH_PRINT)
endef
# 1. SJ_TIDL_TFLITE_MODEL_NAME:              ti_dl/test/testvecs/models/public/tensorflow/*/.*
# 2. SJ_TIDL_TFLITE_MODEL_IMPORT_CONFIG:     ti_dl/test/testvecs/config/import/public/tensorflow/tidl_import_*.txt
# 3. SJ_TIDL_TFLITE_MODEL_INFERENCE_CONFIG:  ti_dl/test/testvecs/config/infer/public/tensorflow/tidl_infer_*.txt
# 4. Model output:
# 		outputNetFile      = "ti_dl/test/testvecs/config/tidl_models/caffe/tidl_net_suqeezenet_1_1.bin"
#		outputParamsFile   = "ti_dl/test/testvecs/config/tidl_models/caffe/tidl_io_suqeezenet_1_1_"

######################################################################################
### edge AI 
#######################################################################################

tidl_model_import_inference_run:
	$(Q)$(call sj_echo_log, info , "1. tidl_model_import_inference_run ... "); 
	$(eval $(call sj_tidl_path,SJ_TIDL_PATH_FREDY))
ifeq ($(SJ_TIDL_RUNTIME_TYPE),tflite)
	$(eval SJ_TIDL_TYPE=tflite)
	$(eval SJ_TIDL_M_TYPE=tflite)	
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),tensorflow)
	$(eval SJ_TIDL_TYPE=tensorflow)
	$(eval SJ_TIDL_M_TYPE=pb)	
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),caffe)
	$(eval SJ_TIDL_TYPE=caffe)
	$(eval SJ_TIDL_M_TYPE=prototxt)	  # net file
	$(eval SJ_TIDL_P_TYPE=caffemodel) # parammeter file
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),onnx)
	$(eval SJ_TIDL_TYPE=onnx)
	$(eval SJ_TIDL_M_TYPE=onnx)	
endif
	$(Q)$(call sj_echo_log, info , " --- SJ_TIDL_PATH_FREDY := $(SJ_TIDL_PATH_FREDY) !!!");
	$(Q)$(call sj_echo_log, info , " --- SJ_TIDL_TYPE       := $(SJ_TIDL_TYPE) !!!");
	$(Q)$(call sj_echo_log, info , " --- SJ_TIDL_M_TYPE     := $(SJ_TIDL_M_TYPE) !!!");
	$(Q)$(call sj_echo_log, info , " --- 1. setup the $(SJ_TIDL_TYPE) dictionary etc!!!");
	$(Q)mkdir -p $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)
	$(Q)mkdir -p $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)
	$(Q)mkdir -p $(SJ_TIDL_PATH_FREDY)/test/trace
	$(Q)-rm $(SJ_TIDL_PATH_FREDY)/test/trace/*
	$(Q)mkdir -p $(SJ_TIDL_PATH_FREDY)/test/trace/inference
	$(Q)$(call sj_echo_log, info , " --- 2. setup the model !!!");
	$(Q)$(call sj_echo_log, info , " --- 2.1 prepare the model : $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/setup_env.sh !!!");
	$(Q)if [ ! -f $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/setup_env.sh ]; then \
		$(call sj_echo_log, info , " --- 2.1 setup the scripts setup_env.sh");  \
		ln -s  $(SJ_PATH_SCRIPTS)/ubuntu/setup_env_tidl_model.sh $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/setup_env.sh; \
	fi
	$(Q)cd $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL) && ./setup_env.sh && sync
	$(Q)$(call sj_echo_log, info , " --- 2.2 setup the model !!!");
	$(Q)if [ -L $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_M_TYPE) ]; then \
		rm $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_M_TYPE) ; \
	fi
	$(Q)ln -s $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_M_TYPE) $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/ 
ifeq ($(SJ_TIDL_RUNTIME_TYPE),caffe)
	$(Q)$(call sj_echo_log, info , " --- 2.3 setup the model parammeter file for Caffe !!!");
	$(Q)if [ -L $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_P_TYPE) ]; then \
		rm $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_P_TYPE) ; \
	fi
	$(Q)ln -s $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_P_TYPE) $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/ 
endif 
	$(Q)$(call sj_echo_log, info , " --- 2.4 setup the config : config_inference.txt and input pictures !!!");
	$(Q)if [ -f $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/config_inference.txt ]; then \
		cp -v $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/config_inference.txt    $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/  ; \
		cp -rv $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/input*                 $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/  ; \
		cp -v $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/config_inference.txt    $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/  ; \
	fi
ifeq ($(SJ_TIDL_INFERENCE_CONFIG_LIST),yes) 
	cp -v $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/config_inference_list.txt $(SJ_TIDL_PATH_FREDY)/test/testvecs/config;
endif 
	$(Q)$(call sj_echo_log, info , " --- 3. setup the import filie!!!");
	$(Q)if [ -f $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG) ]; then \
		rm $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG) ; \
	fi
	$(Q)ln -s $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG)          $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/; 
	$(Q)$(call sj_echo_log, info , " --- 4. setup the infer filie!!!");
	$(Q)if [ -f $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/infer/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG) ]; then \
		rm $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/infer/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG) ; \
	fi
	$(Q)ln -s $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG)       $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/infer/public/$(SJ_TIDL_TYPE)/;  
	$(Q)$(call sj_echo_log, info , " --- !!! finish the setup !!!");
	$(Q)$(call sj_echo_log, info , " --- 1. start porting and run on PC !!!");
ifeq ($(ti_dl_MODEL_OPTIMIZED),yes)
	$(Q)$(call sj_echo_log, info , " --- 2. Optimized Model == $(ti_dl_MODEL_OPTIMIZED)  : only use for tensorflow");
	$(Q)cd ~/.local/lib/python3.6/site-packages/tensorflow/python/tools/ && python3 optimize_for_inference.py \
	    --input=$(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_M_TYPE) \
        --output=$(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_OUTPUT_NAME).$(SJ_TIDL_M_TYPE)  \
        --input_names="input" \
    	--output_names="MobilenetV2/Predictions/Softmax"
	# Re link the file for tensorflow frozon model 
	$(Q)rm $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_M_TYPE)
	$(Q)cp $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_OUTPUT_NAME).$(SJ_TIDL_M_TYPE) \
		$(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_M_TYPE) 
else
	$(Q)$(call sj_echo_log, info , " --- 2. Optimized Model == NO  no action ");
endif
	$(Q)$(call sj_echo_log, info , " --- 3. check the model name ---- $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_M_TYPE)");
	$(Q)if [ ! -f $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_M_TYPE)  ]; then \
		$(call sj_echo_log, error , "# error please check your model! $(ti_dl_MODEL_INPUT_NAME)"); \
	# else \
	# 	ls -l  $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_M_TYPE); \
	fi
	$(Q)$(call sj_echo_log, info , " --- 4. check the SJ_TIDL_TFLITE_MODEL_IMPORT_CONFIG ---- $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG)");
	$(Q)if [  ! -f $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG) ]; then \
		$(call sj_echo_log, error , "# error please check your model! $(ti_dl_MODEL_MODEL_IMPORT_CONFIG).txt"); \
	# else \
	# 	ls -l $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG); \
	fi
	$(Q)$(call sj_echo_log, info , " --- 5. check the ti_dl_MODEL_MODEL_INFERENCE_CONFIG ---- $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/infer/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG)");
	$(Q)if [ ! -f $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/infer/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG) ]; then \
		$(call sj_echo_log, error , "# error please check your model! $(ti_dl_MODEL_MODEL_INFERENCE_CONFIG)"); \
	# else \
	# 	ls -l $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/infer/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG); \
	fi
	$(Q)$(call sj_echo_log, info , " --- 6. import the model ");
ifeq ($(SJ_TIDL_IMPORT_SET),yes)
	# Tensorflow : --numParamBits 15 
	$(Q)cd $(SJ_TIDL_PATH_FREDY)/utils/tidlModelImport && \
	./out/tidl_model_import.out $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG)
else
	$(Q)$(call sj_echo_log, info , " --- 6.1  SJ_TIDL_IMPORT_SET : $(SJ_TIDL_IMPORT_SET) ");
endif
	$(Q)$(call sj_echo_log, info , " --- 7. inference on the pc");
	$(Q)$(call sj_echo_log, info , " --- 7.1 Add below config in $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/testvecs/config/config_list.txt");
	$(Q)$(call sj_echo_log, info , " ---     $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/testvecs/config/infer/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG) ");
	$(Q)$(call sj_echo_log, info , " ---     config fredy:  in $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/config_inference_list.txt");
	$(Q)$(call sj_echo_log, info , " ---     Add below config in $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/config_list.txt");
	$(Q)sed -i '1c 1 testvecs/config/infer/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG)' $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/config_list.txt
	$(Q)$(call sj_echo_log, info , " --- 7.2 Execute command PC_dsp_test_dl_algo.out");
ifeq ($(SJ_TIDL_INFERENCE_SET),yes)
ifeq ($(SJ_TIDL_INFERENCE_CONFIG_LIST),yes)
	echo "./PC_dsp_test_dl_algo.out $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/config_inference_list.txt"; 
	$(Q)cd $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test && \
	    ./PC_dsp_test_dl_algo.out $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/config_inference_list.txt;  
else 
	echo "./PC_dsp_test_dl_algo.out $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/config_list.txt"; 
	$(Q)cd $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test && ./PC_dsp_test_dl_algo.out 2>&1;  
endif 
else 
	$(Q)$(call sj_echo_log, info , " --- 7.3  SJ_TIDL_INFERENCE_SET : $(SJ_TIDL_INFERENCE_SET) ");
endif
	$(Q)echo ""
	$(Q)$(call sj_echo_log, info , " --- 8. check the model and input file");
	$(Q)$(call sj_echo_log, info , "# Model   file  : $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_M_TYPE) ");
ifeq ($(SJ_TIDL_RUNTIME_TYPE),caffe)
	$(Q)$(call sj_echo_log, info , "# Param   file  : $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_P_TYPE) ");
endif 
	$(Q)$(call sj_echo_log, info , "# model   zoo   : $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL) ");
	$(Q)$(call sj_echo_log, info , "# trace         : $(SJ_TIDL_PATH_FREDY)/test/trace/ ");
	$(Q)$(call sj_echo_log, info , "# import  file  : $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG) ");
	$(Q)$(call sj_echo_log, info , "# infer   file  : $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/infer/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG) ");
	$(Q)$(call sj_echo_log, info , "# network file  : $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_net_$(ti_dl_MODEL).bin ");
	$(Q)$(call sj_echo_log, info , "#  I/O    file  : $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_io_$(ti_dl_MODEL)_1.bin ");
	$(Q)$(call sj_echo_log, info , "# network graph : $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_net_$(ti_dl_MODEL).bin.svg");
	$(Q)$(call sj_echo_log, info , "# output        : $(SJ_TIDL_PATH_FREDY)/test/testvecs/output/tidl_$(SJ_TIDL_TYPE)_$(ti_dl_MODEL)_output.bin");
	$(Q)$(call sj_echo_log, info , "# User Guide    : https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/$(SJ_PSDKRA_BRANCH)/exports/docs/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/docs/user_guide_html/index.html");
	$(Q)$(call sj_echo_log, info , "1. tidl_model_import_inference_run ... done! ");  

tidl_model_output_result_check:
	$(Q)$(call sj_echo_log, info , "1. tidl_model_output_result_check ... "); 
	$(eval $(call sj_tidl_path,SJ_TIDL_PATH_FREDY))
ifeq ($(SJ_TIDL_RUNTIME_TYPE),tflite)
	$(eval SJ_TIDL_TYPE=tflite)
	$(eval SJ_TIDL_M_TYPE=tflite)	
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),tensorflow)
	$(eval SJ_TIDL_TYPE=tensorflow)
	$(eval SJ_TIDL_M_TYPE=pb)	
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),caffe)
	$(eval SJ_TIDL_TYPE=caffe)
	$(eval SJ_TIDL_M_TYPE=prototxt)	  # net file
	$(eval SJ_TIDL_P_TYPE=caffemodel) # parammeter file
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),onnx)
	$(eval SJ_TIDL_TYPE=onnx)
	$(eval SJ_TIDL_M_TYPE=onnx)	
endif
	#hexdump -C 	$(SJ_TIDL_PATH_FREDY)/test/testvecs/output/tidl_$(SJ_TIDL_TYPE)_$(ti_dl_MODEL)_output.bin
	#hexdump -e '1/1 "%d" "  |  "' -e '1/1 "%_p" "\n"' $(SJ_TIDL_PATH_FREDY)/test/testvecs/output/tidl_$(SJ_TIDL_TYPE)_$(ti_dl_MODEL)_output.bin
	od -d $(SJ_TIDL_PATH_FREDY)/test/testvecs/output/tidl_$(SJ_TIDL_TYPE)_$(ti_dl_MODEL)_output.bin
	$(Q)$(call sj_echo_log, info , "1. tidl_model_output_result_check ... done! ");  

tidl_model_inference_run_evm:
	$(Q)$(call sj_echo_log, info , "1. tidl_model_inference_run_evm ... "); 
	$(Q)$(call sj_echo_log, file , "SCRIPT","$(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP)"); 
	cd $(SJ_PATH_SCRIPTS)/j7 && ./remote_command.sh --ip $(SJ_EVM_IP) ./run_tidl_inference.sh
	$(Q)$(call sj_echo_log, info , "1. tidl_model_inference_run_evm ... done! ");  

tidl_model_sd_model_setup:
	$(Q)$(call sj_echo_log, info , "1. tidl_model_sd_model_setup ... "); 
	$(eval $(call sj_tidl_path,SJ_TIDL_PATH_FREDY))
ifeq ($(SJ_TIDL_RUNTIME_TYPE),tflite)
	$(eval SJ_TIDL_TYPE=tflite)
	$(eval SJ_TIDL_M_TYPE=tflite)	
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),tensorflow)
	$(eval SJ_TIDL_TYPE=tensorflow)
	$(eval SJ_TIDL_M_TYPE=pb)	
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),caffe)
	$(eval SJ_TIDL_TYPE=caffe)
	$(eval SJ_TIDL_M_TYPE=prototxt)	  # net file
	$(eval SJ_TIDL_P_TYPE=caffemodel) # parammeter file
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),onnx)
	$(eval SJ_TIDL_TYPE=onnx)
	$(eval SJ_TIDL_M_TYPE=onnx)	
endif
	$(Q)$(call sj_echo_log, info , " --- 0. model setup to  SD /rootfs/home/root ");
	scp $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_net_$(ti_dl_MODEL).bin   root@$(SJ_EVM_IP):/home/root
	scp $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_io_$(ti_dl_MODEL)_1.bin  root@$(SJ_EVM_IP):/home/root
	scp $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_net_$(ti_dl_MODEL).bin   root@$(SJ_EVM_IP):/opt/tidl_test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)
	scp $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_io_$(ti_dl_MODEL)_1.bin  root@$(SJ_EVM_IP):/opt/tidl_test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)
	scp $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/config_inference.txt                                      root@$(SJ_EVM_IP):/opt/tidl_test/testvecs/config
	scp $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/config_list.txt                                           root@$(SJ_EVM_IP):/opt/tidl_test/testvecs/config
ifeq ($(SJ_TIDL_INFERENCE_CONFIG_LIST),yes)
	scp $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/config_inference_evm_list.txt                                 root@$(SJ_EVM_IP):/opt/tidl_test/testvecs/config
endif
	scp $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG) 	         root@$(SJ_EVM_IP):/opt/tidl_test/testvecs/config/infer/public/$(SJ_TIDL_TYPE)
	scp -r $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/input*                                                                  root@$(SJ_EVM_IP):/opt/tidl_test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)
	$(Q)$(call sj_echo_log, info , " --- 1. model setup to  SD /rootfs/home/root done!!! ");
	$(Q)$(call sj_echo_log, info , "1. tidl_model_sd_model_setup ... done! ");

tidl_model_nfs_model_setup:
	$(Q)$(call sj_echo_log, info , "1. tidl_model_nfs_model_setup ... "); 
	$(eval $(call sj_tidl_path,SJ_TIDL_PATH_FREDY))
ifeq ($(SJ_TIDL_RUNTIME_TYPE),tflite)
	$(eval SJ_TIDL_TYPE=tflite)
	$(eval SJ_TIDL_M_TYPE=tflite)	
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),tensorflow)
	$(eval SJ_TIDL_TYPE=tensorflow)
	$(eval SJ_TIDL_M_TYPE=pb)	
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),caffe)
	$(eval SJ_TIDL_TYPE=caffe)
	$(eval SJ_TIDL_M_TYPE=prototxt)	  # net file
	$(eval SJ_TIDL_P_TYPE=caffemodel) # parammeter file
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),onnx)
	$(eval SJ_TIDL_TYPE=onnx)
	$(eval SJ_TIDL_M_TYPE=onnx)	
endif
	$(Q)$(call sj_echo_log, info , " --- 0. model setup to  SD /rootfs/home/root ");
	cp -v $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_net_$(ti_dl_MODEL).bin   $(SJ_PATH_PSDKRA)/targetfs/home/root
	cp -v $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_io_$(ti_dl_MODEL)_1.bin  $(SJ_PATH_PSDKRA)/targetfs/home/root
	cp -v $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_net_$(ti_dl_MODEL).bin   $(SJ_PATH_PSDKRA)/targetfs/opt/tidl_test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)
	cp -v $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_io_$(ti_dl_MODEL)_1.bin  $(SJ_PATH_PSDKRA)/targetfs/opt/tidl_test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)
	cp -v $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/config_inference.txt                                      $(SJ_PATH_PSDKRA)/targetfs/opt/tidl_test/testvecs/config
	cp -v $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/config_list.txt                                           $(SJ_PATH_PSDKRA)/targetfs/opt/tidl_test/testvecs/config
ifeq ($(SJ_TIDL_INFERENCE_CONFIG_LIST),yes)
	cp -v $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/config_inference_evm_list.txt                                $(SJ_PATH_PSDKRA)/targetfs/opt/tidl_test/testvecs/config
endif
	cp -v $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG) 	         $(SJ_PATH_PSDKRA)/targetfs/opt/tidl_test/testvecs/config/infer/public/$(SJ_TIDL_TYPE)
	cp -rv $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/input*                							 $(SJ_PATH_PSDKRA)/targetfs/opt/tidl_test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)
	sync
	$(Q)$(call sj_echo_log, info , " --- 1. model setup to  nfs $(SJ_PATH_PSDKRA)/targetfs done!!! ");
	$(Q)$(call sj_echo_log, info , "1. tidl_model_nfs_model_setup ... done! ");  

# before run below command , you should run  : tidl-model-setup-import-run
tidl_model_check_inference_trace:  tidl_model_import_inference_run  tidl_model_sd_model_setup tidl_model_inference_run_evm
	$(Q)$(call sj_echo_log, info , "1. tidl_model_check_inference_trace ... "); 
	$(eval $(call sj_tidl_path,SJ_TIDL_PATH_FREDY))
ifeq ($(SJ_TIDL_RUNTIME_TYPE),tflite)
	$(eval SJ_TIDL_TYPE=tflite)
	$(eval SJ_TIDL_M_TYPE=tflite)	
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),tensorflow)
	$(eval SJ_TIDL_TYPE=tensorflow)
	$(eval SJ_TIDL_M_TYPE=pb)	
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),caffe)
    $(eval SJ_TIDL_TYPE=caffe)
    $(eval SJ_TIDL_M_TYPE=prototxt)   # net file
    $(eval SJ_TIDL_P_TYPE=caffemodel) # parammeter file
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),onnx)
	$(eval SJ_TIDL_TYPE=onnx)
	$(eval SJ_TIDL_M_TYPE=onnx)	
endif
	$(Q)$(call sj_echo_log, info , " --- 0.  check the model import    trace");
	$(Q)mkdir -p $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/importer/
	$(Q)-rm $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/importer/*
	$(Q)$(call sj_echo_log, info , " --- 0.1 update the import trace check");
	$(Q)cp -v $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_import_$(ti_dl_MODEL).txt00* $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/importer/ >> $(SJ_PATH_JACINTO)/.sj_log;
	$(Q)$(call sj_echo_log, info , " --- 0.2 check the model inference trace");
	$(Q)$(call sj_echo_log, info , " --- 1. copy the pc emulation trace to model zoo directory");
	$(Q)mkdir -p $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/pc_emulation/
	$(Q)-rm $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/pc_emulation/*
	$(Q)cp -rv $(SJ_TIDL_PATH_FREDY)/test/trace/* $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/pc_emulation/ >> $(SJ_PATH_JACINTO)/.sj_log;
ifeq ($(SJ_TIDL_COMPARE_INFERENCE_PC_AND_EVM),yes)
	$(Q)$(call sj_echo_log, info , " --- 2. copy the EVM trace to model zoo directory");
	$(Q)mkdir -p $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/evm
	$(Q)-rm $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/evm/*
	$(Q)scp -r root@$(SJ_EVM_IP):/opt/tidl_test/trace/* $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/evm >> $(SJ_PATH_JACINTO)/.sj_log;
endif 
	$(Q)$(call sj_echo_log, info , " --- 3.  compare the import and inference");
	$(Q)if [ ! -f $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODELTIDLExecutionProvider
	$(Q)$(call sj_echo_log, info , "# model   zoo   : $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/check_trace.sh ");
ifeq ($(SJ_TIDL_COMPARE_IMPORT_AND_INFERENCE),yes)
	# $(Q)cd $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL) && ./check_trace.sh IMPORT_vs_INFERENCE > trace_compare_pc_vs_import_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d`.log
	$(Q)cd $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL) && ./check_trace.sh IMPORT_vs_INFERENCE
endif
ifeq ($(SJ_TIDL_COMPARE_INFERENCE_PC_AND_EVM),yes)
	$(Q)-cd $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL) && ./check_trace.sh PC_vs_EVM > trace_compare_pc_vs_evm_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d`.log
	$(Q)cd $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)  && ./check_trace.sh PC_vs_EVM 
endif 
	$(Q)$(call sj_echo_log, info , " --- 4. ----log : $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace_compare_pc_vs_evm_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d`.log ------------------done!!! ");
	$(Q)$(call sj_echo_log, info , "1. tidl_model_check_inference_trace ... done! ");  

tidl_model_check_feature_map:
	$(Q)$(call sj_echo_log, info , "1. tidl_model_check_feature_map ... "); 
	$(eval $(call sj_tidl_path,SJ_TIDL_PATH_FREDY))
ifeq ($(SJ_TIDL_RUNTIME_TYPE),tflite)
	$(eval SJ_TIDL_TYPE=tflite)
	$(eval SJ_TIDL_M_TYPE=tflite)	
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),tensorflow)
	$(eval SJ_TIDL_TYPE=tensorflow)
	$(eval SJ_TIDL_M_TYPE=pb)	
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),caffe)
	$(eval SJ_TIDL_TYPE=caffe)
	$(eval SJ_TIDL_M_TYPE=prototxt)	  # net file
	$(eval SJ_TIDL_P_TYPE=caffemodel) # parammeter file
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),onnx)
	$(eval SJ_TIDL_TYPE=onnx)
	$(eval SJ_TIDL_M_TYPE=onnx)	
endif
	$(Q)$(call sj_echo_log, info , " --- 0. feature map check");
	$(Q)$(call sj_echo_log, info , " --- 1. compare the layer level activation comparisons : $(SJ_PATH_SCRIPTS)/j7/tidl/script_feature_map.py ");
	cd $(SJ_TIDL_PATH_FREDY)/utils/tidlModelImport && python3 $(SJ_PATH_SCRIPTS)/j7/tidl/script_feature_map.py \
		-im ../../test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG) \
		-in testvecs/config/infer/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG) > $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/log_feature_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d`.txt
	$(Q)$(call sj_echo_log, info , "\n");
	$(Q)$(call sj_echo_log, info , " --- 2. compare the layer level activation comparisons : $(SJ_PATH_SCRIPTS)/j7/tidl/script_layer_float_compare.py");
	$(Q)cat $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG) | grep numParamBits 
	$(Q)mkdir -p  $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/compare_layer/parm8/
	$(Q)mkdir -p  $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/compare_layer/parm16/
	$(Q)echo  "- cp -rv $(SJ_TIDL_PATH_FREDY)/test/trace/*float.bin $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/compare_layer/parm8/"
	$(Q)echo  "- cp -rv $(SJ_TIDL_PATH_FREDY)/test/trace/*float.bin $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/compare_layer/parm16/"
	$(Q)cd $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)  && ./check_trace.sh Layer_Float_8_vs_16
	cd $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/compare_layer && python3 $(SJ_PATH_SCRIPTS)/j7/tidl/script_layer_float_compare.py -i ./trcae_files_list.txt > ./log_compare_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d`.txt
	$(Q)$(call sj_echo_log, info , " --- comparision1 output:  $(SJ_TIDL_PATH_FREDY)/utils/tidlModelImport/comparison_output/activations/");
	$(Q)$(call sj_echo_log, info , " --- comparision1 output:  $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/log_feature_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d`.txt");
	$(Q)$(call sj_echo_log, info , " --- comparision2 output:  $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/compare_layer/log_compare_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d`.txt");
	$(Q)$(call sj_echo_log, info , " --- comparision2 output:  $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/compare_layer/trcae_files_list.txt");
	$(Q)$(call sj_echo_log, info , " --- 3. compare the layer level activation comparisons ---done");
	$(Q)$(call sj_echo_log, info , "1. tidl_model_check_feature_map ... done! ");  

tidl_model_onnx_imnet:
	$(Q)$(call sj_echo_log, info , "1. tidl_model_onnx_imnet ... "); 
	$(eval $(call sj_tidl_path,SJ_TIDL_PATH_FREDY))
ifeq ($(SJ_TIDL_RUNTIME_TYPE),tflite)
	$(eval SJ_TIDL_TYPE=tflite)
	$(eval SJ_TIDL_M_TYPE=tflite)	
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),tensorflow)
	$(eval SJ_TIDL_TYPE=tensorflow)
	$(eval SJ_TIDL_M_TYPE=pb)	
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),caffe)
	$(eval SJ_TIDL_TYPE=caffe)
	$(eval SJ_TIDL_M_TYPE=prototxt)	  # net file
	$(eval SJ_TIDL_P_TYPE=caffemodel) # parammeter file
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),onnx)
	$(eval SJ_TIDL_TYPE=onnx)
	$(eval SJ_TIDL_M_TYPE=onnx)	
endif
	$(Q)$(call sj_echo_log, info , " --- 0. Example script to Reference output from MxNet for ONNX");
	$(Q)$(call sj_echo_log, info , " --- 1.  $(SJ_PATH_SCRIPTS)/j7/tidl/onnx_predict_output.py ");
	cd $(SJ_TIDL_PATH_FREDY)/utils/tidlModelImport && python3 $(SJ_PATH_SCRIPTS)/j7/tidl/onnx_predict_output.py 
	$(Q)$(call sj_echo_log, info , " --- Trace $(SJ_TIDL_PATH_FREDY)/utils/tidlModelImport/trace ");
	$(Q)$(call sj_echo_log, info , " --- 0. Example script to Reference output from MxNet for ONNX done!");
	$(Q)$(call sj_echo_log, info , "1. tidl_model_onnx_imnet ... done! ");  

tidl_caffe_lane_dection_run_on_evm:
	$(Q)$(call sj_echo_log, info , "1. tidl_caffe_lane_dection_run_on_evm ... "); 
	$(Q)$(ECHO) "1. lane dection, plase check the branch: lane-dection, tested on SDK0703 "
	$(Q)$(ECHO) "2. build  and instlal the images to SD card"
	$(Q)$(ECHO) "3. update the app_tidl_cam.cfg "
	scp $(SJ_PATH_DOWNLOAD)/models-zoo/lane_model/caffe_lane_detection/app_tidl_cam.cfg root@$(SJ_EVM_IP):/opt/vision_apps
	$(Q)$(ECHO) "4. update the net  "
	scp $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/testvecs/config/tidl_models/caffe/tidl_net_lane_dection_512x512.bin root@$(SJ_EVM_IP):/opt/vision_apps
	$(Q)$(ECHO) "5. update the io  "
	scp $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/testvecs/config/tidl_models/caffe/tidl_io_lane_dection_512x512_1.bin root@$(SJ_EVM_IP):/opt/vision_apps
	$(Q)$(ECHO) "6. Run on EVM: ./run_app_tidl_cam.sh  !!! "
	$(Q)$(call sj_echo_log, info , "1. tidl_caffe_lane_dection_run_on_evm ... done! ");  

tidl_model_run_on_evm_setup:
	$(Q)$(call sj_echo_log, info , "1. tidl_model_run_on_evm_setup ... "); 
	$(Q)$(ECHO) "If you run test on EVM "
	$(Q)$(ECHO) "export LD_LIBRARY_PATH=\$$LD_LIBRARY_PATH:/usr/lib"
	$(Q)$(ECHO) "cd /opt/ti_tester"
	$(Q)$(ECHO) "./TI*"
	$(Q)$(call sj_echo_log, info , "1. tidl_model_run_on_evm_setup ... done! ");  

tidl_src_download_setup:
	$(Q)$(call sj_echo_log, info , "1. tidl_src_download_setup ... "); 
	$(SJ_PATH_SCRIPTS)/j7/j7_c7x_mma.sh -i
	$(Q)$(call sj_echo_log, info , "1. tidl_src_download_setup ... done! ");  

tidl_src_build_pc:
	$(Q)$(call sj_echo_log, info , "1. tidl_src_build_pc ... "); 
	$(eval $(call sj_tidl_path,SJ_TIDL_PATH_FREDY))
	$(Q)$(call sj_echo_log, info , " --- 1. build the pdk depency: pls ----------set : BUILD_EMULATION_MODE = yes------");
	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) pdk_emu -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , " --- 2. build the pc all");
	$(MAKE) -C $(SJ_TIDL_PATH_FREDY)/../  all TARGET_PLATFORM=PC -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , " --- 3. Tensorflow-lite runtime");
	$(MAKE) -C $(SJ_TIDL_PATH_FREDY)/../  it TIDL_BUILD_TFLITE_IMPORT_LIB=1
	$(Q)$(call sj_echo_log, info , " --- 4. Tensorflow-lite runtime");
	$(MAKE) -C $(SJ_TIDL_PATH_FREDY)/../  it TIDL_BUILD_ONNX_IMPORT_LIB=1
	$(Q)$(call sj_echo_log, info , " --- 5. Tensorflow-lite runtime");
	$(MAKE) -C $(SJ_TIDL_PATH_FREDY)/../  it TIDL_BUILD_RELAY_IMPORT_LIB=1
	$(Q)$(call sj_echo_log, info , " --- 6. build all done");
	$(Q)$(call sj_echo_log, info , "1. tidl_src_build_pc ... done! ");  

tidl_src_addon_packages:
	$(Q)$(call sj_echo_log, info , "1. tidl_src_addon_packages ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. setup the flatbuffers");
	$(SJ_PATH_SCRIPTS)/ubuntu/setup/setup-flatbuffers.sh -p $(SJ_PATH_PSDKRA)  -i yes
	$(Q)$(call sj_echo_log, info , " --- 1. setup the flatbuffers - done");
	$(Q)$(call sj_echo_log, info , " --- 2. setup the opencv");
	$(SJ_PATH_SCRIPTS)/ubuntu/setup/setup-opencv.sh -p $(SJ_PATH_PSDKRA) -v -i yes
	$(Q)$(call sj_echo_log, info , " --- 2. setup the opencv done");
	$(Q)$(call sj_echo_log, info , " --- 3. setup the protobuf");
	$(SJ_PATH_SCRIPTS)/ubuntu/setup/setup-protobuf.sh -p $(SJ_PATH_PSDKRA) -i yes
	$(Q)$(call sj_echo_log, info , " --- 3. setup the protobuf done");
	$(Q)$(call sj_echo_log, info , " --- 4. setup the tensorflow");
	cd $(SJ_PATH_PSDKRA)/ && git clone --depth 1 --single-branch -b tidl-j7 https://github.com/TexasInstruments/tensorflow.git
	$(Q)$(call sj_echo_log, info , " --- 4. setup the tensorflow done");
	$(Q)$(call sj_echo_log, info , " --- 5. setup the onnx");
	cd $(SJ_PATH_PSDKRA)/ && git clone --depth 1 --single-branch -b tidl-j7 https://github.com/TexasInstruments/onnxruntime.git
	$(Q)$(call sj_echo_log, info , " --- 5. setup the onnx done");
	$(Q)$(call sj_echo_log, info , " --- 6. setup the tvm");
	cd $(SJ_PATH_PSDKRA)/ &&  git clone --single-branch -b tidl-j7 https://github.com/TexasInstruments/tvm ;\
	cd tvm ; git submodule init ; git submodule update --init --recursive
	$(Q)$(call sj_echo_log, info , " --- 6. setup the tvm done");
	$(Q)$(call sj_echo_log, info , "1. tidl_src_addon_packages ... done! ");  

tidl_src_build_dependent:
	$(Q)$(call sj_echo_log, info , "1. tidl_src_build_dependent ... "); 
	$(eval $(call sj_tidl_path,SJ_TIDL_PATH_FREDY))
	sudo apt install graphviz-dev ;\
	export TIDL_GRAPHVIZ_PATH=/usr; \
	cd $(SJ_TIDL_PATH_FREDY)/../ && TARGET_PLATFORM=PC make gv
	$(Q)$(call sj_echo_log, info , "1. tidl_src_build_dependent ... done! ");  

tidl_src_build_evm:
	$(Q)$(call sj_echo_log, info , "1. tidl_src_build_evm ... "); 
	$(eval $(call sj_tidl_path,SJ_TIDL_PATH_FREDY))
	$(Q)$(call sj_echo_log, info , " --- 1. build the tidl src code");
	$(MAKE) -C $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`  tidl  -s -j$(CPU_NUM)
	$(MAKE) -C $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`  tidl_rt  -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, info , " --- 2. build the tidl src code");
	$(Q)$(call sj_echo_log, info , "1. tidl_src_build_evm ... done! ");  

tidl_tools_setup: 
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_setup ... "); 
	$(Q)$(call sj_echo_log, help , "Setup the edgeai", "$(SJ_PATH_EDGEAI_TIDL_TOOLS) ");
	$(Q)$(call sj_echo_log, file , "SCRIPTS", "$(SJ_PATH_SCRIPTS)/j7/install_edgeai.sh ");
ifeq ($(SJ_EDGEAI_GPU_TOOLS),yes)
	$(Q)$(call sj_echo_log, warning , "--- GPU setup  ");
	$(SJ_PATH_SCRIPTS)/j7/install_edgeai.sh --soctype $(SJ_SOC_TYPE) -i yes --ver "$(SJ_EDGEAI_VERSION)" -d $(SJ_PATH_PSDKRA)  --gpu yes
else
	$(Q)$(call sj_echo_log, warning , "--- CPU setup  ");
	$(SJ_PATH_SCRIPTS)/j7/install_edgeai.sh --soctype $(SJ_SOC_TYPE) -i yes --ver "$(SJ_EDGEAI_VERSION)" -d $(SJ_PATH_PSDKRA) 
endif
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_setup ... done! ");  

tidl_tools_validate: check_paths_EDGEAI_TIDL_TOOLS
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_validate ... "); 
	$(Q)$(call sj_echo_log, help , "Setup the edgeai", "$(SJ_PATH_EDGEAI_TIDL_TOOLS) ");
	$(Q)$(call sj_echo_log, file , "SCRIPTS", "$(SJ_PATH_SCRIPTS)/j7/install_edgeai.sh ");
	$(SJ_PATH_SCRIPTS)/j7/install_edgeai.sh --soctype $(SJ_SOC_TYPE) -b yes
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_validate ... done! ");  

tidl_tools_run: check_paths_EDGEAI_TIDL_TOOLS
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_run ... "); 
	$(Q)$(call sj_echo_log, warning , "run this command before : pyenv activate benchmark"); 
ifeq ($(SJ_TIDL_RUNTIME_TYPE),tflite)
	$(eval SJ_TIDL_TYPE=tflite)
	$(eval SJ_TIDL_M_TYPE=tflite)	
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),onnx)
	$(eval SJ_TIDL_TYPE=onnx)
	$(eval SJ_TIDL_M_TYPE=onnx)	
endif
	$(Q)$(call sj_echo_log, info , " --- SJ_PATH_EDGEAI_TIDL_TOOLS := $(SJ_PATH_EDGEAI_TIDL_TOOLS) !!!");
	$(Q)$(call sj_echo_log, help , "SJ_TIDL_TYPE"   ,"$(SJ_TIDL_TYPE)");
	$(Q)$(call sj_echo_log, help , "SJ_TIDL_M_TYPE" ,"$(SJ_TIDL_M_TYPE)");
	$(Q)$(call sj_echo_log, help , "ti_dl_MODEL"    ,"$(ti_dl_MODEL)");
	$(Q)$(call sj_echo_log, help , "SJ_TIDL_IMPORT_INTERFERN_WITH_TIDL", "$(SJ_TIDL_IMPORT_INTERFERN_WITH_TIDL)");
	$(Q)$(call sj_echo_log, file , "Model config", "$(SJ_PATH_EDGEAI_TIDL_TOOLS)/examples/osrt_python/model_configs.py"); 
	$(Q)$(call sj_echo_log, file , "SCRIPTS", "$(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/setup_env_edgeai.sh"); 
	$(Q)$(call sj_echo_log, info , " --- 1.1 prepare the model ... ");
	$(Q)if [ ! -f  $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/setup_env_edgeai.sh ]; then \
		$(call sj_echo_log, info , " --- 2.1 setup the scripts setup_env.sh");  \
		ln -s  $(SJ_PATH_SCRIPTS)/ubuntu/setup_env_tidl_tools_model.sh $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/setup_env_edgeai.sh; \
		chmod 777 $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/setup_env_edgeai.sh; \
	fi
	$(Q)cd $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL) && ./setup_env_edgeai.sh && sync
	$(Q)$(call sj_echo_log, info , " --- 1.1 prepare the model ... done !!!");
	$(Q)$(call sj_echo_log, info , " --- 2. import and inference on the pc ... ");
ifeq ($(SJ_TIDL_INFERENCE_SET),yes)
ifeq ($(SJ_TIDL_IMPORT_INTERFERN_WITH_TIDL),yes)
	$(Q)$(call sj_echo_log, info , " --- 2.1 import and interence $(SJ_TIDL_TYPE) model ... with TIDL  $(SJ_PATH_EDGEAI_TIDL_TOOLS)/examples/osrt_python/ort --- python3 onnxrt_ep.py ");
	./scripts/j7/install_edgeai.sh --soctype $(SJ_SOC_TYPE) --name $(ti_dl_MODEL) --running yes -m $(SJ_TIDL_TYPE)  --tidl
	./scripts/j7/install_edgeai.sh --soctype $(SJ_SOC_TYPE) --name $(ti_dl_MODEL) --running yes -m $(SJ_TIDL_TYPE)  --tidl  > $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/log_$(SJ_SOC_TYPE)_$(SJ_PSDKRA_BRANCH)_tidl_`date +%Y-%m-%d-%H-%M-%S`.txt
else
	$(Q)$(call sj_echo_log, info , " --- 2.1 import and interence $(SJ_TIDL_TYPE) model ... without TIDL  $(SJ_PATH_EDGEAI_TIDL_TOOLS)/examples/osrt_python/ort --- python3 onnxrt_ep.py ");
	./scripts/j7/install_edgeai.sh --soctype $(SJ_SOC_TYPE) --name $(ti_dl_MODEL) --running yes -m $(SJ_TIDL_TYPE) --cxx no 
	./scripts/j7/install_edgeai.sh --soctype $(SJ_SOC_TYPE) --name $(ti_dl_MODEL) --running yes -m $(SJ_TIDL_TYPE) --cxx no > $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/log_$(SJ_SOC_TYPE)_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d-%H-%M-%S`.txt
endif
	$(Q)$(call sj_echo_log, info , " --- 2.1 import and interence $(SJ_TIDL_TYPE) mode ... --done!!!");
else
	$(Q)$(call sj_echo_log, info , " --- 2.1  SJ_TIDL_INFERENCE_SET : $(SJ_TIDL_INFERENCE_SET) ");
endif
	$(Q)$(call sj_echo_log, info , " --- 2. import and inference on the pc ... --done!!!");
	$(Q)$(call sj_echo_log, info , " --- 3. check the model and input file");
	$(Q)$(call sj_echo_log, file , "# model   zoo   ","$(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL) ");
	$(Q)$(call sj_echo_log, file , "# model  output ","$(SJ_PATH_EDGEAI_TIDL_TOOLS)/model-artifacts/$(ti_dl_MODEL)-$(SJ_TIDL_RUNTIME_TYPE)");
	$(Q)$(call sj_echo_log, file , "# model  input  ","$(SJ_PATH_EDGEAI_TIDL_TOOLS)/models/");
	$(Q)$(call sj_echo_log, file , "# output images ","$(SJ_PATH_EDGEAI_TIDL_TOOLS)/output_images/");
	$(Q)$(call sj_echo_log, file , "# network file  ","`ls -l $(SJ_PATH_EDGEAI_TIDL_TOOLS)/model-artifacts/$(ti_dl_MODEL)-$(SJ_TIDL_RUNTIME_TYPE)/*.bin`");
	$(Q)$(call sj_echo_log, file , "# output        ","`ls -l $(SJ_PATH_EDGEAI_TIDL_TOOLS)/output_images/py_out_$(ti_dl_MODEL)-$(SJ_TIDL_RUNTIME_TYPE)*.jpg`");
	$(Q)$(call sj_echo_log, file , "# User Guide    ","https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/$(SJ_PSDKRA_BRANCH)/exports/docs/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/docs/user_guide_html/index.html");
	$(Q)mkdir $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/log_$(SJ_SOC_TYPE)_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d-%H-%M`; \
		cp -r $(SJ_PATH_EDGEAI_TIDL_TOOLS)/model-artifacts/$(ti_dl_MODEL)-$(SJ_TIDL_RUNTIME_TYPE) $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/log_$(SJ_SOC_TYPE)_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d-%H-%M`/ ; \
		mkdir $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/log_$(SJ_SOC_TYPE)_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d-%H-%M`/trace_ref/ ; \
		cp /tmp/tidl_trace* $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/log_$(SJ_SOC_TYPE)_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d-%H-%M`/trace_ref/ ; \
		cp $(SJ_PATH_EDGEAI_TIDL_TOOLS)/output_images/py_out_$(ti_dl_MODEL)-$(SJ_TIDL_RUNTIME_TYPE)*.jpg $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/log_$(SJ_SOC_TYPE)_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d-%H-%M`/ ; 
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_run ... done! ");  

tidl_tools_run_tflite: check_paths_EDGEAI_TIDL_TOOLS
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_run_tflite ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. setup the edgeai : $(SJ_PATH_EDGEAI_TIDL_TOOLS) ");
	$(Q)$(call sj_echo_log, info , " --- 1. setup the scripts : $(SJ_PATH_SCRIPTS)/j7/install_edgeai.sh ");
	./scripts/j7/install_edgeai.sh --soctype $(SJ_SOC_TYPE) -r yes -m tflite --tidl
	$(Q)$(call sj_echo_log, info , " --- 1. setup the edgeai sdk --done!!!");
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_run_tflite ... done! ");  

tidl_tools_run_tflite_without_tidl: check_paths_EDGEAI_TIDL_TOOLS
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_run_tflite_without_tidl ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. setup the edgeai : $(SJ_PATH_EDGEAI_TIDL_TOOLS) ");
	$(Q)$(call sj_echo_log, info , " --- 1. setup the scripts : $(SJ_PATH_SCRIPTS)/j7/install_edgeai.sh ");
	./scripts/j7/install_edgeai.sh --soctype $(SJ_SOC_TYPE) -r yes -m tflite 
	$(Q)$(call sj_echo_log, info , " --- 1. setup the edgeai sdk --done!!!");
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_run_tflite_without_tidl ... done! ");  

tidl_tools_run_onnx: check_paths_EDGEAI_TIDL_TOOLS
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_run_onnx ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. setup the edgeai : $(SJ_PATH_EDGEAI_TIDL_TOOLS) ");
	$(Q)$(call sj_echo_log, info , " --- 1. setup the scripts : $(SJ_PATH_SCRIPTS)/j7/install_edgeai.sh ");
	./scripts/j7/install_edgeai.sh --soctype $(SJ_SOC_TYPE) -r yes -m onnx --tidl 
	$(Q)$(call sj_echo_log, info , " --- 1. setup the edgeai sdk --done!!!");
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_run_onnx ... done! ");  

tidl_tools_run_onnx_without_tidl: check_paths_EDGEAI_TIDL_TOOLS
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_run_onnx_without_tidl ... "); 
	$(Q)$(call sj_echo_log, info , " --- 1. setup the edgeai : $(SJ_PATH_EDGEAI_TIDL_TOOLS) ");
	$(Q)$(call sj_echo_log, info , " --- 1. setup the scripts : $(SJ_PATH_SCRIPTS)/j7/install_edgeai.sh ");
	./scripts/j7/install_edgeai.sh --soctype $(SJ_SOC_TYPE) -r yes -m onnx --tidl
	$(Q)$(call sj_echo_log, info , " --- 1. setup the edgeai sdk --done!!!");
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_run_onnx_without_tidl ... done! ");  

# ./bin/Release/ort_main -f model-artifacts/cl-ort-resnet18-v1  -i test_data/airshow.jpg
tidl_tools_cxx_run: check_paths_EDGEAI_TIDL_TOOLS
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_cxx_run ... "); 
ifeq ($(SJ_TIDL_RUNTIME_TYPE),tflite)
	$(eval SJ_TIDL_TYPE=tflite)
	$(eval SJ_TIDL_M_TYPE=tflite)	
else ifeq ($(SJ_TIDL_RUNTIME_TYPE),onnx)
	$(eval SJ_TIDL_TYPE=onnx)
	$(eval SJ_TIDL_M_TYPE=onnx)	
endif
	$(Q)$(call sj_echo_log, info , " --- 1. setup the edgeai : $(SJ_PATH_EDGEAI_TIDL_TOOLS) ");
	$(Q)$(call sj_echo_log, info , " --- 1. setup the scripts : $(SJ_PATH_SCRIPTS)/j7/install_edgeai.sh ");
	./scripts/j7/install_edgeai.sh --soctype $(SJ_SOC_TYPE) -r yes -m $(SJ_TIDL_TYPE) --tidl --cxx yes  --name $(ti_dl_MODEL) 
	$(Q)$(call sj_echo_log, info , " --- 1. 	$(Q)$(call sj_echo_log, info , "1. tidl_help ... "); setup the edgeai sdk --done!!!");
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_cxx_run ... done! ");  

tidl_tools_docker_build:
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_docker_build ... "); 
	$(Q)$(call sj_echo_log, file , "Setup User guide","https://github.com/TexasInstruments/edgeai-tidl-tools/blob/master/docs/advanced_setup.md#docker-based-setup-for-x86_pc");
	$(Q)$(call sj_echo_log, file , "Setup Scripts","$(SJ_PATH_EDGEAI_TIDL_TOOLS)/scripts/docker/build_docker.sh");
ifeq ($(SJ_EDGEAI_GPU_TOOLS),yes)
	$(eval TIDL_TOOLS_TYPE=GPU)	
	$(Q)$(call sj_echo_log, debug , "check : TIDL_TOOLS_TYPE = $(TIDL_TOOLS_TYPE)");
	cd $(SJ_PATH_EDGEAI_TIDL_TOOLS) && export TIDL_TOOLS_TYPE=GPU;  source ./scripts/docker/build_docker.sh
else
	$(Q)$(call sj_echo_log, debug , "check : TIDL_TOOLS_TYPE = $(TIDL_TOOLS_TYPE)");
	cd $(SJ_PATH_EDGEAI_TIDL_TOOLS) && source ./scripts/docker/build_docker.sh
endif
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_docker_build ... done! ");  

# SJ_YOCTO_TAG?=jwidic/x86_ubuntu_22:sdk_09_02_v3_gpu # CPU
SJ_YOCTO_TAG?=jwidic/x86_ubuntu_22:sdk_09_02_v3
tidl_tools_docker_run:	
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_docker_run ... "); 
	$(Q)$(call sj_echo_log, file , "Run docker scripts", "$(SJ_PATH_EDGEAI_TIDL_TOOLS)/scripts/docker/run_docker.sh");
	$(Q)$(call sj_echo_log, info , "Running with GPU : SJ_EDGEAI_GPU_TOOLS - $(SJ_EDGEAI_GPU_TOOLS)");
ifeq ($(SJ_EDGEAI_GPU_TOOLS),yes)
	$(Q)$(call sj_echo_log, info , "Running with GPU : SJ_EDGEAI_GPU_TOOLS - $(SJ_EDGEAI_GPU_TOOLS) running ... ");
	sudo docker run --gpus all -it --shm-size=4096m --mount source=$(SJ_PATH_JACINTO),target=$(SJ_PATH_JACINTO),type=bind $(SJ_YOCTO_TAG)
else
	$(Q)$(call sj_echo_log, info , "Running with CPU : SJ_EDGEAI_GPU_TOOLS - $(SJ_EDGEAI_GPU_TOOLS) running ... ");
	sudo docker run -it --shm-size=4096m --mount source=$(SJ_PATH_JACINTO),target=$(SJ_PATH_JACINTO),type=bind $(SJ_YOCTO_TAG)
endif
	$(Q)$(call sj_echo_log, info , "1. tidl_tools_docker_run ... done! ");  

tidl_notebooks_setup:
	$(Q)$(call sj_echo_log, info , "1. tidl_notebooks_setup ... "); 
	$(Q)$(ECHO) "# 1. ifconfig check the EVM ip: "
	$(Q)$(ECHO) "# 2. run below command (First Time): "
	$(Q)$(ECHO) " /opt/notebooks "
	$(Q)$(ECHO) " ./notebook_evm.sh"
	$(Q)$(ECHO) ">>> http://j7-evm:8888/?token=5f4dc2f9c60318a8d8f70013a0786d56fd1c17a012a6a630"
	$(Q)$(ECHO) "# 3. if not the first time, setup env as below:  "
	$(Q)$(ECHO) "export LD_LIBRARY_PATH="/usr/lib""
	$(Q)$(ECHO) "export TIDL_TOOLS_PATH="/opt/jai_tidl_notebooks""
	$(Q)$(ECHO) "export TIDL_RT_PERFSTATS="1""
	$(Q)$(ECHO) "jupyter notebook --allow-root --no-browser --ip=0.0.0.0"
	$(Q)$(ECHO) ">>> http://j7-evm:8888/?token=5f4dc2f9c60318a8d8f70013a0786d56fd1c17a012a6a630"
	$(Q)$(ECHO) "# End of the file !"
	$(Q)$(call sj_echo_log, info , "1. tidl_notebooks_setup ... done! ");  

tidl_edgeai_ai_tensorflow:
	$(Q)$(call sj_echo_log, info , "1. tidl_edgeai_ai_tensorflow ... "); 
	# pip install tensorflow -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	pip3 install --upgrade pip -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	pip3 install tensorflow -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	pip3 install --upgrade tensorflow-cpu  -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	#To update TensorFlow to the latest version, add --upgrade flag to the above commands.
	$(Q)$(call sj_echo_log, info , "1. tidl_edgeai_ai_tensorflow ... done! ");  

define sj_tidl_path_print
	$(Q)case $(1) in \
		'tidl') \
			echo "$(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl"; \
		;;   \
		'model') \
			echo "$(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/testvecs/models/public/$(2)"; \
		;;   \
		"config") \
			echo "$(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/testvecs/config/import/public/$(2)";  \
		;;   \
		"infer") \
			echo "$(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/testvecs/config/infer/public/$(2)";  \
		;;   \
		*)   \
			echo "[ `date`  ] >>> error please check the function!  "; \
		;;   \
	esac
endef

# Input :
# 	1. $1 : model/config/infer 
#   2. $2 : model type: onnx
#   3. $3 : return value 
tidl_test_function:
	$(Q)$(call sj_echo_log, info , "1. tidl_help ... "); 
	$(call sj_tidl_path_print,config,onnx);
	$(eval $(call sj_tidl_path,SJ_TIDL_PATH_FREDY))
	echo ${SJ_TIDL_PATH_FREDY}
	$(Q)$(call sj_echo_log, info , "1. tidl_help ... done! ");  


tidl_help:
	$(Q)$(call sj_echo_log, info , "1. tidl_help ... "); 
	$(Q)$(call sj_echo_log, info , "# Available build targets are:"); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, help , "tidl_caffe_lane_dection_run_on_evm"        ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_model_import_inference_run"           ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_model_inference_run_evm"              ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_model_check_feature_map"              ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_model_check_inference_trace"          ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_model_nfs_model_setup"                ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_model_onnx_imnet"                     ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_model_output_result_check"            ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_model_run_on_evm_setup"               ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_model_sd_model_setup"                 ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_src_addon_packages"                   ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_src_build_dependent"                  ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_src_build_evm"                        ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_src_build_pc"                         ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_src_download_setup"                   ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_tools_setup"                          ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_tools_validate"                       ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_tools_run"                            ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_tools_run_onnx"                       ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_tools_run_onnx_without_tidl"          ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_tools_run_tflite"                     ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_tools_run_tflite_without_tidl"        ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_tools_cxx_run"                        ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_tools_docker_build"                   ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_tools_docker_run"                     ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "tidl_test_function"                        ,"install ... "); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, file , "edgeai-tidl-tools", "https://github.com/TexasInstruments/edgeai-tidl-tools"); 
	$(Q)$(call sj_echo_log, file , "edgeai doc", "/home/fredy/startjacinto/docs/jacinto7/edgeai.md"); 
	$(Q)$(call sj_echo_log, info , "1. tidl_help ... done! ");  