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
ti_dl_MODEL ?= mobilenetv2_yuv
# RUNTIME type : tensorflow tflite caffe onnx
SJ_TIDL_RUNTIME_TYPE ?=onnx
SJ_TIDL_IMPORT_SET      ?= yes
SJ_TIDL_INFERENCE_SET   ?= yes
SJ_TIDL_INFERENCE_CONFIG_LIST   ?= no
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
ti_dl_MODEL_ZOO ?= $(SJ_PATH_J7_SDK)/models-zoo/
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

tidl-model-import-inference-run:
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
	$(Q)$(call sj_echo_log, 0 , " --- SJ_TIDL_PATH_FREDY := $(SJ_TIDL_PATH_FREDY) !!!");
	$(Q)$(call sj_echo_log, 0 , " --- SJ_TIDL_TYPE       := $(SJ_TIDL_TYPE) !!!");
	$(Q)$(call sj_echo_log, 0 , " --- SJ_TIDL_M_TYPE     := $(SJ_TIDL_M_TYPE) !!!");
	$(Q)$(call sj_echo_log, 0 , " --- 1. setup the $(SJ_TIDL_TYPE) dictionary etc!!!");
	$(Q)mkdir -p $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)
	$(Q)mkdir -p $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)
	$(Q)mkdir -p $(SJ_TIDL_PATH_FREDY)/test/trace
	$(Q)-rm $(SJ_TIDL_PATH_FREDY)/test/trace/*
	$(Q)mkdir -p $(SJ_TIDL_PATH_FREDY)/test/trace/inference
	$(Q)$(call sj_echo_log, 0 , " --- 2. setup the model !!!");
	$(Q)$(call sj_echo_log, 0 , " --- 2.1 prepare the model : $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/setup_env.sh !!!");
	$(Q)if [ ! -f $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/setup_env.sh ]; then \
		$(call sj_echo_log, 0 , " --- 2.1 setup the scripts setup_env.sh");  \
		ln -s  $(SJ_PATH_SCRIPTS)/ubuntu/setup_env_tidl_model.sh $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/setup_env.sh; \
	fi
	$(Q)cd $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL) && ./setup_env.sh && sync
	$(Q)$(call sj_echo_log, 0 , " --- 2.2 setup the model !!!");
	$(Q)if [ -L $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_M_TYPE) ]; then \
		rm $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_M_TYPE) ; \
	fi
	$(Q)ln -s $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_M_TYPE) $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/ 
ifeq ($(SJ_TIDL_RUNTIME_TYPE),caffe)
	$(Q)$(call sj_echo_log, 0 , " --- 2.3 setup the model parammeter file for Caffe !!!");
	$(Q)if [ -L $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_P_TYPE) ]; then \
		rm $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_P_TYPE) ; \
	fi
	$(Q)ln -s $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_P_TYPE) $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/ 
endif 
	$(Q)$(call sj_echo_log, 0 , " --- 2.4 setup the config : config_inference.txt and input pictures !!!");
	$(Q)if [ -f $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/config_inference.txt ]; then \
		cp -v $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/config_inference.txt    $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/  ; \
		cp -rv $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/input*                 $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/  ; \
		cp -v $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/config_inference.txt    $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/  ; \
	fi
ifeq ($(SJ_TIDL_INFERENCE_CONFIG_LIST),yes) 
	cp -v $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/config_inference_list.txt $(SJ_TIDL_PATH_FREDY)/test/testvecs/config;
endif 
	$(Q)$(call sj_echo_log, 0 , " --- 3. setup the import filie!!!");
	$(Q)if [ -f $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG) ]; then \
		rm $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG) ; \
	fi
	$(Q)ln -s $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG)          $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/; 
	$(Q)$(call sj_echo_log, 0 , " --- 4. setup the infer filie!!!");
	$(Q)if [ -f $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/infer/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG) ]; then \
		rm $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/infer/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG) ; \
	fi
	$(Q)ln -s $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG)       $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/infer/public/$(SJ_TIDL_TYPE)/;  
	$(Q)$(call sj_echo_log, 0 , " --- !!! finish the setup !!!");
	$(Q)$(call sj_echo_log, 0 , " --- 1. start porting and run on PC !!!");
ifeq ($(ti_dl_MODEL_OPTIMIZED),yes)
	$(Q)$(call sj_echo_log, 0 , " --- 2. Optimized Model == $(ti_dl_MODEL_OPTIMIZED)  : only use for tensorflow");
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
	$(Q)$(call sj_echo_log, 0 , " --- 2. Optimized Model == NO  no action ");
endif
	$(Q)$(call sj_echo_log, 0 , " --- 3. check the model name ---- $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_M_TYPE)");
	$(Q)if [ ! -f $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_M_TYPE)  ]; then \
		$(call sj_echo_log, 2 , "# error please check your model! $(ti_dl_MODEL_INPUT_NAME)"); \
	# else \
	# 	ls -l  $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_M_TYPE); \
	fi
	$(Q)$(call sj_echo_log, 0 , " --- 4. check the SJ_TIDL_TFLITE_MODEL_IMPORT_CONFIG ---- $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG)");
	$(Q)if [  ! -f $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG) ]; then \
		$(call sj_echo_log, 2 , "# error please check your model! $(ti_dl_MODEL_MODEL_IMPORT_CONFIG).txt"); \
	# else \
	# 	ls -l $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG); \
	fi
	$(Q)$(call sj_echo_log, 0 , " --- 5. check the ti_dl_MODEL_MODEL_INFERENCE_CONFIG ---- $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/infer/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG)");
	$(Q)if [ ! -f $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/infer/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG) ]; then \
		$(call sj_echo_log, 2 , "# error please check your model! $(ti_dl_MODEL_MODEL_INFERENCE_CONFIG)"); \
	# else \
	# 	ls -l $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/infer/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG); \
	fi
	$(Q)$(call sj_echo_log, 0 , " --- 6. import the model ");
ifeq ($(SJ_TIDL_IMPORT_SET),yes)
	# Tensorflow : --numParamBits 15 
	$(Q)cd $(SJ_TIDL_PATH_FREDY)/utils/tidlModelImport && \
	./out/tidl_model_import.out $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG)
else
	$(Q)$(call sj_echo_log, 0 , " --- 6.1  SJ_TIDL_IMPORT_SET : $(SJ_TIDL_IMPORT_SET) ");
endif
	$(Q)$(call sj_echo_log, 0 , " --- 7. inference on the pc");
	$(Q)$(call sj_echo_log, 0 , " --- 7.1 Add below config in $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/testvecs/config/config_list.txt");
	$(Q)$(call sj_echo_log, 0 , " ---     $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/testvecs/config/infer/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG) ");
	$(Q)$(call sj_echo_log, 0 , " ---     config fredy:  in $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/config_inference_list.txt");
	$(Q)$(call sj_echo_log, 0 , " ---     Add below config in $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/config_list.txt");
	$(Q)sed -i '1c 1 testvecs/config/infer/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG)' $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/config_list.txt
	$(Q)$(call sj_echo_log, 0 , " --- 7.2 Execute command PC_dsp_test_dl_algo.out");
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
	$(Q)$(call sj_echo_log, 0 , " --- 7.3  SJ_TIDL_INFERENCE_SET : $(SJ_TIDL_INFERENCE_SET) ");
endif
	$(Q)echo ""
	$(Q)$(call sj_echo_log, 0 , " --- 8. check the model and input file");
	$(Q)$(call sj_echo_log, 0 , "# Model   file  : $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_M_TYPE) ");
ifeq ($(SJ_TIDL_RUNTIME_TYPE),caffe)
	$(Q)$(call sj_echo_log, 0 , "# Param   file  : $(SJ_TIDL_PATH_FREDY)/test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/$(ti_dl_MODEL_INPUT_NAME).$(SJ_TIDL_P_TYPE) ");
endif 
	$(Q)$(call sj_echo_log, 0 , "# model   zoo   : $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL) ");
	$(Q)$(call sj_echo_log, 0 , "# trace         : $(SJ_TIDL_PATH_FREDY)/test/trace/ ");
	$(Q)$(call sj_echo_log, 0 , "# import  file  : $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG) ");
	$(Q)$(call sj_echo_log, 0 , "# infer   file  : $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/infer/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG) ");
	$(Q)$(call sj_echo_log, 0 , "# network file  : $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_net_$(ti_dl_MODEL).bin ");
	$(Q)$(call sj_echo_log, 0 , "#  I/O    file  : $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_io_$(ti_dl_MODEL)_1.bin ");
	$(Q)$(call sj_echo_log, 0 , "# network graph : $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_net_$(ti_dl_MODEL).bin.svg");
	$(Q)$(call sj_echo_log, 0 , "# output        : $(SJ_TIDL_PATH_FREDY)/test/testvecs/output/tidl_$(SJ_TIDL_TYPE)_$(ti_dl_MODEL)_output.bin");
	$(Q)$(call sj_echo_log, 0 , "# User Guide    : https://software-dl.ti.com/jacinto7/esd/processor-sdk-rtos-jacinto7/$(SJ_PSDKRA_BRANCH)/exports/docs/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/docs/user_guide_html/index.html");
	$(Q)$(call sj_echo_log, 0 , " -------------------------------- done !!!");

tidl_model_output_result_check:
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

tidl-model-inference-run-evm:
	$(Q)$(call sj_echo_log, 0 , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) -------------------------------- start !!!");
	cd $(SJ_PATH_SCRIPTS)/j7 && ./remote_command.sh --ip $(SJ_EVM_IP) ./run_tidl_inference.sh
	$(Q)$(call sj_echo_log, 0 , " 0. Run the ssh $(SJ_PATH_SCRIPTS)/j7/remote_command.sh --ip $(SJ_EVM_IP) -------------------------------- done !!!");

tidl-model-sd-model-setup:
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
	$(Q)$(call sj_echo_log, 0 , " --- 0. model setup to  SD /rootfs/home/root ");
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
	scp -r $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/input*                							 root@$(SJ_EVM_IP):/opt/tidl_test/testvecs/models/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)
	$(Q)$(call sj_echo_log, 0 , " --- 1. model setup to  SD /rootfs/home/root done!!! ");

# before run below command , you should run  : tidl-model-setup-import-run
tidl-model-check-inference-trace:  tidl-model-import-inference-run  tidl-model-sd-model-setup tidl-model-inference-run-evm
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
	$(Q)$(call sj_echo_log, 0 , " --- 0.  check the model import    trace");
	$(Q)mkdir -p $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/importer/
	$(Q)-rm $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/importer/*
	$(Q)$(call sj_echo_log, 0 , " --- 0.1 update the import trace check");
	$(Q)cp -v $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_import_$(ti_dl_MODEL).txt00* $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/importer/ >> $(SJ_PATH_JACINTO)/.sj_log;
	$(Q)$(call sj_echo_log, 0 , " --- 0.2 check the model inference trace");
	$(Q)$(call sj_echo_log, 0 , " --- 1. copy the pc emulation trace to model zoo directory");
	$(Q)mkdir -p $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/pc_emulation/
	$(Q)-rm $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/pc_emulation/*
	$(Q)cp -rv $(SJ_TIDL_PATH_FREDY)/test/trace/* $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/pc_emulation/ >> $(SJ_PATH_JACINTO)/.sj_log;
ifeq ($(SJ_TIDL_COMPARE_INFERENCE_PC_AND_EVM),yes)
	$(Q)$(call sj_echo_log, 0 , " --- 2. copy the EVM trace to model zoo directory");
	$(Q)mkdir -p $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/evm
	$(Q)-rm $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/evm/*
	$(Q)scp -r root@$(SJ_EVM_IP):/opt/tidl_test/trace/* $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/evm >> $(SJ_PATH_JACINTO)/.sj_log;
endif 
	$(Q)$(call sj_echo_log, 0 , " --- 3.  compare the import and inference");
	$(Q)if [ ! -f $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/check_trace.sh ]; then \
		$(call sj_echo_log, 0 , " --- 3.1 setup the scripts check_trace.sh");  \
		ln -s  $(SJ_PATH_SCRIPTS)/ubuntu/check_trace_tidl.sh $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/check_trace.sh; \
	fi
	$(Q)$(call sj_echo_log, 0 , "# model   zoo   : $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/check_trace.sh ");
ifeq ($(SJ_TIDL_COMPARE_IMPORT_AND_INFERENCE),yes)
	# $(Q)cd $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL) && ./check_trace.sh IMPORT_vs_INFERENCE > trace_compare_pc_vs_import_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d`.log
	$(Q)cd $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL) && ./check_trace.sh IMPORT_vs_INFERENCE
endif
ifeq ($(SJ_TIDL_COMPARE_INFERENCE_PC_AND_EVM),yes)
	$(Q)-cd $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL) && ./check_trace.sh PC_vs_EVM > trace_compare_pc_vs_evm_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d`.log
	$(Q)cd $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)  && ./check_trace.sh PC_vs_EVM 
endif 
	$(Q)$(call sj_echo_log, 0 , " --- 4. ----log : $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace_compare_pc_vs_evm_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d`.log ------------------done!!! ");


tidl-model-check-feature-map:
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
	$(Q)$(call sj_echo_log, 0 , " --- 0. feature map check");
	$(Q)$(call sj_echo_log, 0 , " --- 1. compare the layer level activation comparisons : $(SJ_PATH_SCRIPTS)/j7/tidl/script_feature_map.py ");
	cd $(SJ_TIDL_PATH_FREDY)/utils/tidlModelImport && python3 $(SJ_PATH_SCRIPTS)/j7/tidl/script_feature_map.py \
		-im ../../test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG) \
		-in testvecs/config/infer/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_INFERENCE_CONFIG) > $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/log_feature_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d`.txt
	$(Q)$(call sj_echo_log, 0 , "\n");
	$(Q)$(call sj_echo_log, 0 , " --- 2. compare the layer level activation comparisons : $(SJ_PATH_SCRIPTS)/j7/tidl/script_layer_float_compare.py");
	$(Q)cat $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/import/public/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL_MODEL_IMPORT_CONFIG) | grep numParamBits 
	$(Q)mkdir -p  $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/compare_layer/parm8/
	$(Q)mkdir -p  $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/compare_layer/parm16/
	$(Q)echo  "- cp -rv $(SJ_TIDL_PATH_FREDY)/test/trace/*float.bin $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/compare_layer/parm8/"
	$(Q)echo  "- cp -rv $(SJ_TIDL_PATH_FREDY)/test/trace/*float.bin $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/compare_layer/parm16/"
	$(Q)cd $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)  && ./check_trace.sh Layer_Float_8_vs_16
	cd $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/compare_layer && python3 $(SJ_PATH_SCRIPTS)/j7/tidl/script_layer_float_compare.py -i ./trcae_files_list.txt > ./log_compare_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d`.txt
	$(Q)$(call sj_echo_log, 0 , " --- comparision1 output:  $(SJ_TIDL_PATH_FREDY)/utils/tidlModelImport/comparison_output/activations/");
	$(Q)$(call sj_echo_log, 0 , " --- comparision1 output:  $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/log_feature_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d`.txt");
	$(Q)$(call sj_echo_log, 0 , " --- comparision2 output:  $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/compare_layer/log_compare_$(SJ_PSDKRA_BRANCH)_`date +%Y-%m-%d`.txt");
	$(Q)$(call sj_echo_log, 0 , " --- comparision2 output:  $(ti_dl_MODEL_ZOO)/$(SJ_TIDL_TYPE)/$(ti_dl_MODEL)/trace/compare_layer/trcae_files_list.txt");
	$(Q)$(call sj_echo_log, 0 , " --- 3. compare the layer level activation comparisons ---done");


tidl-model-onnx-imnet:
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
	$(Q)$(call sj_echo_log, 0 , " --- 0. Example script to Reference output from MxNet for ONNX");
	$(Q)$(call sj_echo_log, 0 , " --- 1.  $(SJ_PATH_SCRIPTS)/j7/tidl/onnx_predict_output.py ");
	cd $(SJ_TIDL_PATH_FREDY)/utils/tidlModelImport && python3 $(SJ_PATH_SCRIPTS)/j7/tidl/onnx_predict_output.py 
	$(Q)$(call sj_echo_log, 0 , " --- Trace $(SJ_TIDL_PATH_FREDY)/utils/tidlModelImport/trace ");
	$(Q)$(call sj_echo_log, 0 , " --- 0. Example script to Reference output from MxNet for ONNX done!");

# install the model zoo to SDKs/
tidl-model-zoo-download:
	$(Q)$(call sj_echo_log, 0 , " --- 0. download the model zoo");
	$(Q)if [ ! -f $(SJ_PATH_J7_SDK)/models-zoo ]; then \
		$(ECHO) "please download from ssh://git@10.85.130.233:7999/psdkra/models-zoo.git"; \
		cd $(SJ_PATH_DOWNLOAD) && git clone ssh://git@10.85.130.233:7999/psdkra/models-zoo.git; \
	fi
	$(Q)$(call sj_echo_log, 0 , " --- 1. download the model zoo ---done ");


tidl-caffe-lane-dection-run-on-EVM:
	$(Q)$(ECHO) "1. lane dection, plase check the branch: lane-dection, tested on SDK0703 "
	$(Q)$(ECHO) "2. build  and instlal the images to SD card"
	$(Q)$(ECHO) "3. update the app_tidl_cam.cfg "
	scp $(SJ_PATH_DOWNLOAD)/models-zoo/lane_model/caffe_lane_detection/app_tidl_cam.cfg root@$(SJ_EVM_IP):/opt/vision_apps
	$(Q)$(ECHO) "4. update the net  "
	scp $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/testvecs/config/tidl_models/caffe/tidl_net_lane_dection_512x512.bin root@$(SJ_EVM_IP):/opt/vision_apps
	$(Q)$(ECHO) "5. update the io  "
	scp $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/testvecs/config/tidl_models/caffe/tidl_io_lane_dection_512x512_1.bin root@$(SJ_EVM_IP):/opt/vision_apps
	$(Q)$(ECHO) "6. Run on EVM: ./run_app_tidl_cam.sh  !!! "

tidl-model-run-on-evm-setup:
	$(Q)$(ECHO) "If you run test on EVM "
	$(Q)$(ECHO) "export LD_LIBRARY_PATH=\$$LD_LIBRARY_PATH:/usr/lib"
	$(Q)$(ECHO) "cd /opt/ti_tester"
	$(Q)$(ECHO) "./TI*"

tidl-src-download-setup:
	$(Q)$(call sj_echo_log, 0 , " --- 1. download the tidl src code ");
	$(SJ_PATH_SCRIPTS)/j7/j7_c7x_mma.sh -i
	$(Q)$(call sj_echo_log, 0 , " --- 2. downlaod the tidl src code done !!!");

tidl-src-build-pc:
	$(eval $(call sj_tidl_path,SJ_TIDL_PATH_FREDY))
	$(Q)$(call sj_echo_log, 0 , " --- 1. build the pdk depency");
	$(MAKE) -C $(SJ_PATH_PDK)/packages/ti/build osal_nonos ipc  csl sciclient udma dmautils BOARD=j721e_hostemu CORE=c7x-hostemu BUILD_PROFILE=release  -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, 0 , " --- 2. build the pc all");
	$(MAKE) -C $(SJ_TIDL_PATH_FREDY)/../  all TARGET_PLATFORM=PC -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, 0 , " --- 3. Tensorflow-lite runtime");
	$(MAKE) -C $(SJ_TIDL_PATH_FREDY)/../  it TIDL_BUILD_TFLITE_IMPORT_LIB=1
	$(Q)$(call sj_echo_log, 0 , " --- 4. Tensorflow-lite runtime");
	$(MAKE) -C $(SJ_TIDL_PATH_FREDY)/../  it TIDL_BUILD_ONNX_IMPORT_LIB=1
	$(Q)$(call sj_echo_log, 0 , " --- 5. Tensorflow-lite runtime");
	$(MAKE) -C $(SJ_TIDL_PATH_FREDY)/../  it TIDL_BUILD_RELAY_IMPORT_LIB=1
	$(Q)$(call sj_echo_log, 0 , " --- 6. build all done");

tidl-src-addon-packages:
	$(Q)$(call sj_echo_log, 0 , " --- 1. setup the flatbuffers");
	$(SJ_PATH_SCRIPTS)/ubuntu/setup/setup-flatbuffers.sh -p $(SJ_PATH_PSDKRA)  -i yes
	$(Q)$(call sj_echo_log, 0 , " --- 1. setup the flatbuffers - done");
	$(Q)$(call sj_echo_log, 0 , " --- 2. setup the opencv");
	$(SJ_PATH_SCRIPTS)/ubuntu/setup/setup-opencv.sh -p $(SJ_PATH_PSDKRA) -v -i yes
	$(Q)$(call sj_echo_log, 0 , " --- 2. setup the opencv done");
	$(Q)$(call sj_echo_log, 0 , " --- 3. setup the protobuf");
	$(SJ_PATH_SCRIPTS)/ubuntu/setup/setup-protobuf.sh -p $(SJ_PATH_PSDKRA) -i yes
	$(Q)$(call sj_echo_log, 0 , " --- 3. setup the protobuf done");
	$(Q)$(call sj_echo_log, 0 , " --- 4. setup the tensorflow");
	cd $(SJ_PATH_PSDKRA)/ && git clone --depth 1 --single-branch -b tidl-j7 https://github.com/TexasInstruments/tensorflow.git
	$(Q)$(call sj_echo_log, 0 , " --- 4. setup the tensorflow done");
	$(Q)$(call sj_echo_log, 0 , " --- 5. setup the onnx");
	cd $(SJ_PATH_PSDKRA)/ && git clone --depth 1 --single-branch -b tidl-j7 https://github.com/TexasInstruments/onnxruntime.git
	$(Q)$(call sj_echo_log, 0 , " --- 5. setup the onnx done");
	$(Q)$(call sj_echo_log, 0 , " --- 6. setup the tvm");
	cd $(SJ_PATH_PSDKRA)/ &&  git clone --single-branch -b tidl-j7 https://github.com/TexasInstruments/tvm ;\
	cd tvm ; git submodule init ; git submodule update --init --recursive
	$(Q)$(call sj_echo_log, 0 , " --- 6. setup the tvm done");

tidl-src-build-dependent:
	$(eval $(call sj_tidl_path,SJ_TIDL_PATH_FREDY))
	sudo apt install graphviz-dev ;\
	export TIDL_GRAPHVIZ_PATH=/usr; \
	cd $(SJ_TIDL_PATH_FREDY)/../ && TARGET_PLATFORM=PC make gv

tidl-src-build-evm:
	$(eval $(call sj_tidl_path,SJ_TIDL_PATH_FREDY))
	$(Q)$(call sj_echo_log, 0 , " --- 1. build the tidl src code");
	$(MAKE) -C $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`  all  -s -j$(CPU_NUM)
	$(Q)$(call sj_echo_log, 0 , " --- 2. build the tidl src code");

tidl-edgeai-tidl-tools-setup: 
	$(Q)$(call sj_echo_log, 0 , " --- 1. setup the edgeai : $(SJ_PATH_EDGEAI_TIDL_TOOLS) ");
	$(Q)$(call sj_echo_log, 0 , " --- 1. setup the scripts : $(SJ_PATH_SCRIPTS)/j7/install_edgeai.sh ");
	./scripts/j7/install_edgeai.sh --soctype $(SJ_SOC_TYPE) -i yes
	$(Q)$(call sj_echo_log, 0 , " --- 1. setup the edgeai sdk --done!!!");

tidl-edgeai-tidl-tools-validate: check_paths_EDGEAI_TIDL_TOOLS
	$(Q)$(call sj_echo_log, 0 , " --- 1. setup the edgeai : $(SJ_PATH_EDGEAI_TIDL_TOOLS) ");
	$(Q)$(call sj_echo_log, 0 , " --- 1. setup the scripts : $(SJ_PATH_SCRIPTS)/j7/install_edgeai.sh ");
	./scripts/j7/install_edgeai.sh --soctype $(SJ_SOC_TYPE) -b yes
	$(Q)$(call sj_echo_log, 0 , " --- 1. setup the edgeai sdk --done!!!");


tidl-edgeai-tidl-tools-run-tensorflow: check_paths_EDGEAI_TIDL_TOOLS
	$(Q)$(call sj_echo_log, 0 , " --- 1. setup the edgeai : $(SJ_PATH_EDGEAI_TIDL_TOOLS) ");
	$(Q)$(call sj_echo_log, 0 , " --- 1. setup the scripts : $(SJ_PATH_SCRIPTS)/j7/install_edgeai.sh ");
	./scripts/j7/install_edgeai.sh --soctype $(SJ_SOC_TYPE) -r yes -m tensorflow
	$(Q)$(call sj_echo_log, 0 , " --- 1. setup the edgeai sdk --done!!!");

tidl-edgeai-tidl-tools-run-onnx: check_paths_EDGEAI_TIDL_TOOLS
	$(Q)$(call sj_echo_log, 0 , " --- 1. setup the edgeai : $(SJ_PATH_EDGEAI_TIDL_TOOLS) ");
	$(Q)$(call sj_echo_log, 0 , " --- 1. setup the scripts : $(SJ_PATH_SCRIPTS)/j7/install_edgeai.sh ");
	./scripts/j7/install_edgeai.sh --soctype $(SJ_SOC_TYPE) -r yes -m onnx
	$(Q)$(call sj_echo_log, 0 , " --- 1. setup the edgeai sdk --done!!!");

tidl-edgeai-tflite-env-setup:
	$(Q)$(ECHO) "cd $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/tflrt/  && source prepare_model_compliation_env.sh"
	cd $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/tflrt/  && source ./prepare_model_compliation_env.sh  &&  python3 ./tflrt_delegate.py -c
	$(Q)$(ECHO) "# env setup and compile done !!!"

tidl-edgeai-tflite-run-on-pc:
	$(Q)$(ECHO) "cd $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/tflrt/  && source prepare_model_compliation_env.sh"
	cd $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/tflrt/  && source ./prepare_model_compliation_env.sh  &&  python3 ./tflrt_delegate.py
	$(Q)$(ECHO) "# env setup and compile done !!!"

tidl-edgeai-onnxrt-env-setup:
	$(Q)$(ECHO) "cd $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/onnxrt/  && source prepare_model_compliation_env.sh"
	cd $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/onnxrt/  && source ./prepare_model_compliation_env.sh  && python3 onnxrt_ep.py -c
	$(Q)$(ECHO) "# env setup and compile done !!!"

tidl-edgeai-onnxrt-run-on-pc:
	$(Q)$(ECHO) "cd $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/tflrt/  && source prepare_model_compliation_env.sh"
	cd $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/tflrt/ && source ./prepare_model_compliation_env.sh  &&  python3  python3 onnxrt_ep.py -c
	$(Q)$(ECHO) "# env setup and compile done !!!"

tidl-edgeai-tvm-dir-env-setup:
	$(Q)$(ECHO) "cd $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/onnxrt/  && source prepare_model_compliation_env.sh"
	cd $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/onnxrt/  && source ./prepare_model_compliation_env.sh  && python3 tvm-compilation-tflite-example.py --pc-inference ; \
	python3 tvm-compilation-onnx-example.py --pc-inference
	$(Q)$(ECHO) "# env setup and compile done !!!"

tidl-edgeai-tvm-dir-run-on-pc:
	$(Q)$(ECHO) "cd $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/tflrt/  && source prepare_model_compliation_env.sh"
	cd $(SJ_PATH_PSDKRA)/`ls $(SJ_PATH_PSDKRA) | grep tidl`/ti_dl/test/tflrt/ && source ./prepare_model_compliation_env.sh  &&  python3 dlr-inference-example.py
	$(Q)$(ECHO) "# env setup and compile done !!!"

tidl-edgeai-tensorflow-env-setup:
	$(eval $(call sj_tidl_path,SJ_TIDL_PATH_FREDY))
	$(eval SJ_TIDL_TYPE=tensorflow)
	$(Q)$(ECHO) "1. Download the model"
	echo "cd $(SJ_TIDL_PATH_FREDY)/test/tflrt && source prepare_model_compliation_env.sh"
	cd $(SJ_TIDL_PATH_FREDY)/test/tflrt && source ./prepare_model_compliation_env.sh
	$(Q)$(ECHO) " Done !!! "

tidl-notebooks-setup:
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

tidl-edgeai-ai-tensorflow:
	# pip install tensorflow -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	pip3 install --upgrade pip -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	pip3 install tensorflow -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	pip3 install --upgrade tensorflow-cpu  -i http://pypi.douban.com/simple --trusted-host pypi.douban.com
	#To update TensorFlow to the latest version, add --upgrade flag to the above commands.

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
	$(call sj_tidl_path_print,config,onnx);
	$(eval $(call sj_tidl_path,SJ_TIDL_PATH_FREDY))
	echo ${SJ_TIDL_PATH_FREDY}


tidl-help:
	$(call sj_echo_log, 0 , "TIDL HELP" );
	# tidl-tflite-env-setup
	# tidl-tflite-run-on-pc
	# tidl-notebooks-setup
	# tidl-run-on-evm-setup  
	# tidl-tensorflow-env-setup  
	# tidl-tvm-dir-env-setup
	# tidl-tvm-dir-run-on-pc
	# tidl-onnxrt-env-setup  
	# tidl-onnxrt-run-on-pc
	# -------------lane-dection-------------------  
	# tidl-caffe-lane-dection-setup                          
	# tidl-caffe-lane-dection-import 
	# tidl-caffe-lane-dection-run-on-pc                                       
	# tidl-caffe-lane-dection-run-on-EVM  
	# -------------onnx-------------------                                 
                   