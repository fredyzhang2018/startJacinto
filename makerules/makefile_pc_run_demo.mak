########################################################################################
#                                                                                      #
# Run demo on PC																	   #
# for EMULATION mode, please make susre 											   #
#		BUILD_EMULATION_MODE=yes                                                       #
#		BUILD_TARGET_MODE=no			                                               #
#                                                                                      #
########################################################################################

# cfg file
SJ_APPS_PROFILE ?= release
# only one demo can be set as yes
SJ_APPS_DEMO_DOF  ?= no
SJ_APPS_DEMO_TIDL ?= no
SJ_APPS_DEMO_TIDL2 ?= yes
SJ_APPS_DEMO_STEREO ?= no
SJ_APPS_DEMO_SINGLE_CAMERA ?= no
# Image Classification :  dl_demos/app_tidl   app_tidl  app_oc.cfg 
# DOF  Demo            :   basic_demos/app_dof app_dense_optical_flow
ifeq ($(SJ_APPS_DEMO_DOF),yes)
SJ_APPS_RUN_DEMO_FOLDER ?= basic_demos/app_dof
SJ_APPS_RUN_DEMO_NAME   ?= app_dense_optical_flow
SJ_APPS_DEMO_CFG        ?= app.cfg
SJ_APPS_DEMO_OUTPUT     ?= dof_out
endif
ifeq ($(SJ_APPS_DEMO_STEREO),yes)
SJ_APPS_RUN_DEMO_FOLDER ?= basic_demos/app_stereo
SJ_APPS_RUN_DEMO_NAME   ?= app_stereo_depth 
SJ_APPS_DEMO_CFG        ?= app.cfg
SJ_APPS_DEMO_OUTPUT     ?= stereo_out
endif
ifeq ($(SJ_APPS_DEMO_TIDL),yes)
SJ_APPS_RUN_DEMO_FOLDER ?= dl_demos/app_tidl
SJ_APPS_RUN_DEMO_NAME   ?= app_tidl
SJ_APPS_DEMO_CFG        ?= app_oc.cfg
SJ_APPS_DEMO_OUTPUT     ?= app_tidl_out
endif 
ifeq ($(SJ_APPS_DEMO_TIDL2),yes)
SJ_APPS_RUN_DEMO_FOLDER ?= dl_demos/app_tidl2
SJ_APPS_RUN_DEMO_NAME   ?= app_tidl2
SJ_APPS_DEMO_CFG        ?= app_oc.cfg
SJ_APPS_DEMO_OUTPUT     ?= app_tidl_out2
endif 
ifeq ($(SJ_APPS_DEMO_SINGLE_CAMERA),yes)
SJ_APPS_RUN_DEMO_FOLDER ?= basic_demos/app_single_cam
SJ_APPS_RUN_DEMO_NAME   ?= app_single_cam
SJ_APPS_DEMO_CFG        ?= app.cfg
SJ_APPS_DEMO_OUTPUT     ?= app_single_cam
endif 

#  ./vx_app_c7x_kernel --cfg /ti/j7/workarea/vision_apps/apps/basic_demos/app_c7x_kernel/config/app.cfg
#  ./vx_app_dense_optical_flow --cfg /ti/j7/workarea/vision_apps/apps/basic_demos/app_dof/config/app.cfg
#./vx_app_tidl --cfg ~/startJacinto/sdks/ti-processor-sdk-rtos-j721e-evm-08_01_00_11/vision_apps/apps/dl_demos/app_tidl/config/app_oc.cfg
apps-run-demo:
	$(Q)$(call sj_echo_log, 0 , " --- 1. Run Demo ");
ifeq ($(SJ_APPS_DEMO_STEREO),yes)
	export APP_STEREO_DATA_PATH=$(SJ_PATH_PSDKRA)/tiovx/conformance_tests/test_data/psdkra/stereo_test_data && \
	cd $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_APPS_PROFILE)/  && \
	./vx_$(SJ_APPS_RUN_DEMO_NAME) --cfg $(SJ_PATH_VISION_SDK_BUILD)/apps/$(SJ_APPS_RUN_DEMO_FOLDER)/config/$(SJ_APPS_DEMO_CFG)
else
	cd $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_APPS_PROFILE)/  && \
	./vx_$(SJ_APPS_RUN_DEMO_NAME) --cfg $(SJ_PATH_VISION_SDK_BUILD)/apps/$(SJ_APPS_RUN_DEMO_FOLDER)/config/$(SJ_APPS_DEMO_CFG)
endif
ifeq ($(SJ_APPS_DEMO_STEREO),yes)
	$(Q)$(call sj_echo_log, 0 , " --- 2. Check the Result $(SJ_PATH_PSDKRA)/tiovx/conformance_tests/test_data/psdkra/stereo_test_data/Stereo0001/output ");
	$(Q)ls -l $(SJ_PATH_PSDKRA)/tiovx/conformance_tests/test_data/psdkra/stereo_test_data/Stereo0001/output
else 
	$(Q)$(call sj_echo_log, 0 , " --- 2. Check the Result $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_APPS_PROFILE)/$(SJ_APPS_DEMO_OUTPUT) ");
	$(Q)ls -l $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_APPS_PROFILE)/$(SJ_APPS_DEMO_OUTPUT)
endif
	$(Q)$(call sj_echo_log, 0 , " --- 3. config file : $(SJ_PATH_VISION_SDK_BUILD)/apps/$(SJ_APPS_RUN_DEMO_FOLDER)/config/$(SJ_APPS_DEMO_CFG) ");
	$(Q)$(call sj_echo_log, 0 , " --- 4. Done Thanks  ");

# test TIDL demo 
APPS_FREDY_MODEL ?= yes
apps-run-demo-tidl:
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
	$(Q)$(call sj_echo_log, 0 , "# network file  : $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_net_$(ti_dl_MODEL).bin ");
	$(Q)$(call sj_echo_log, 0 , "#  I/O    file  : $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_io_$(ti_dl_MODEL)1.bin ");
	$(Q)$(call sj_echo_log, 0 , " --- 0. Config the Model PATH ");
ifeq ($(APPS_FREDY_MODEL),yes)
	$(Q)$(call sj_echo_log, 0 , " --- 0. APPS_FREDY_MODEL = $(APPS_FREDY_MODEL) ");
	sed -i "/^tidl_config_file_path/c tidl_config_file_path    $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_io_$(ti_dl_MODEL)_1.bin"  $(SJ_PATH_VISION_SDK_BUILD)/apps/$(SJ_APPS_RUN_DEMO_FOLDER)/config/$(SJ_APPS_DEMO_CFG)
	sed -i "/^tidl_network_file_path/c tidl_network_file_path  $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_net_$(ti_dl_MODEL).bin"  $(SJ_PATH_VISION_SDK_BUILD)/apps/$(SJ_APPS_RUN_DEMO_FOLDER)/config/$(SJ_APPS_DEMO_CFG)
else
	$(Q)$(call sj_echo_log, 0 , " --- 0. APPS_FREDY_MODEL = $(APPS_FREDY_MODEL) ");
	sed -i "/^tidl_config_file_path/c tidl_config_file_path    /ti/j7/workarea/tiovx/conformance_tests/test_data/tivx/tidl_models/tidl_io_mobilenet_v1_1.bin"  $(SJ_PATH_VISION_SDK_BUILD)/apps/$(SJ_APPS_RUN_DEMO_FOLDER)/config/$(SJ_APPS_DEMO_CFG)
	sed -i "/^tidl_network_file_path/c tidl_network_file_path  /ti/j7/workarea/tiovx/conformance_tests/test_data/tivx/tidl_models/tidl_net_mobilenet_v1.bin"  $(SJ_PATH_VISION_SDK_BUILD)/apps/$(SJ_APPS_RUN_DEMO_FOLDER)/config/$(SJ_APPS_DEMO_CFG)
endif 
	$(Q)$(call sj_echo_log, 0 , " --- 1. Run Demo ");
	cd $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_APPS_PROFILE)/  && \
	./vx_$(SJ_APPS_RUN_DEMO_NAME) --cfg $(SJ_PATH_VISION_SDK_BUILD)/apps/$(SJ_APPS_RUN_DEMO_FOLDER)/config/$(SJ_APPS_DEMO_CFG)
	$(Q)$(call sj_echo_log, 0 , " --- 2. Check the Result $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_APPS_PROFILE)/app_tidl_out/ ");
	$(Q)ls -l $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_APPS_PROFILE)/app_tidl_out/
	$(Q)$(call sj_echo_log, 0 , " --- 3. config file : $(SJ_PATH_VISION_SDK_BUILD)/apps/$(SJ_APPS_RUN_DEMO_FOLDER)/config/$(SJ_APPS_DEMO_CFG) ");
	$(Q)$(call sj_echo_log, 0 , " --- 4. Done Thanks  ");


##########################################
#                                        #
# Tutorial          			         #
#                                        #
##########################################
tiovx_tutorial_exe_run:
	@echo "fredy>>>>>: please confirm SJ_PATH_VX_TEST_DATA"
	export VX_TEST_DATA_PATH=$(SJ_PATH_VX_TEST_DATA) && $(SJ_PATH_TUTORIAL_RUN)/$(SJ_PROFILE)/vx_tutorial_exe
tiovx_tutorial_exe_build:
	$(MAKE) -C $(SJ_PATH_PSDKRA)/tiovx -s -j$(CPU_NUM)
tiovx_tutorial_exe_show_orignal:
	cd $(SJ_PATH_VX_TEST_DATA) && ffplay colors.bmp
tiovx_tutorial_exe_show_save: vx_tutorial_exe_show_orignal
	cd $(SJ_PATH_VX_TEST_DATA) && ffplay vx_tutorial_image_load_save_out.bmp
tiovx_tutorial_exe_show_roi: vx_tutorial_exe_show_orignal
	cd $(SJ_PATH_VX_TEST_DATA) && ffplay vx_tutorial_image_crop_roi.bmp
tiovx_tutorial_exe_show_channel: 
	cd $(SJ_PATH_VX_TEST_DATA) && ffplay vx_tutorial_image_extract_channel_out.bmp
tiovx_tutorial_exe_show_histogram: 
	cd $(SJ_PATH_VX_TEST_DATA) && ffplay vx_tutorial_image_histogram_out.bmp

# please set the below parameter. 
SJ_TIOVX_GENERATE_DIR=kernel_test
SJ_TIOVX_GENETATE_SCRIPT=my_kernel_wrapper.py
tiovx-pyovx-generate-new-kernel:
	$(Q)$(call sj_echo_log, 0 , " --- start to generate the kernel for test !!!");
	export CUSTOM_APPLICATION_PATH=$(SJ_PATH_VISION_SDK_BUILD)/kernels/$(SJ_TIOVX_GENERATE_DIR) && \
	export VISION_APPS_PATH=$(SJ_PATH_VISION_SDK_BUILD) && \
	python3 $(SJ_PATH_RESOURCE)/psdkra/pyovx/$(SJ_TIOVX_GENETATE_SCRIPT)
	$(Q)$(call sj_echo_log, 0 , " --- check the below path: $(SJ_PATH_VISION_SDK_BUILD)/kernels/test !!!");

# please set the below parameter. 
SJ_TIOVX_APP_DEMO_NAME=user_kernel_pytiovx_uc
tiovx-pyovx-generate-new-app:
	$(Q)$(call sj_echo_log, 0 , " --- start to generate the app for test !!!");
	export VISION_APPS_PATH=$(SJ_PATH_VISION_SDK_BUILD) && \
	mkdir -p $(SJ_PATH_VISION_SDK_BUILD)/apps/vx_tutorial_graph_$(SJ_TIOVX_APP_DEMO_NAME) && \
	cp $(SJ_PATH_RESOURCE)/psdkra/pyovx/vx_tutorial_graph_$(SJ_TIOVX_APP_DEMO_NAME).py $(SJ_PATH_VISION_SDK_BUILD)/apps/vx_tutorial_graph_$(SJ_TIOVX_APP_DEMO_NAME) && \
	cd $(SJ_PATH_VISION_SDK_BUILD)/apps/vx_tutorial_graph_$(SJ_TIOVX_APP_DEMO_NAME) && python3 ./vx_tutorial_graph_$(SJ_TIOVX_APP_DEMO_NAME).py
	$(Q)$(call sj_echo_log, 0 , " --- check the below path: $(SJ_PATH_VISION_SDK_BUILD)/apps/vx_tutorial_graph_$(SJ_TIOVX_APP_DEMO_NAME) !!!");

tiovx-pyovx-generate-new-app-run:
	cd $(SJ_PATH_VISION_SDK_BUILD)//out/PC/x86_64/LINUX/$(SJ_PROFILE)/ &&  ./vx_app_vx_tutorial_graph_$(SJ_TIOVX_APP_DEMO_NAME)

