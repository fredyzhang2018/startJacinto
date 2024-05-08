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
apps_pc_run_demo:
	$(Q)$(call sj_echo_log, info , "1. apps_run_demo ...  ");
ifeq ($(SJ_APPS_DEMO_STEREO),yes)
	export APP_STEREO_DATA_PATH=$(SJ_PATH_PSDKRA)/tiovx/conformance_tests/test_data/psdkra/stereo_test_data && \
	cd $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_APPS_PROFILE)/  && \
	./vx_$(SJ_APPS_RUN_DEMO_NAME) --cfg $(SJ_PATH_VISION_SDK_BUILD)/apps/$(SJ_APPS_RUN_DEMO_FOLDER)/config/$(SJ_APPS_DEMO_CFG)
else
	cd $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_APPS_PROFILE)/  && \
	./vx_$(SJ_APPS_RUN_DEMO_NAME) --cfg $(SJ_PATH_VISION_SDK_BUILD)/apps/$(SJ_APPS_RUN_DEMO_FOLDER)/config/$(SJ_APPS_DEMO_CFG)
endif
ifeq ($(SJ_APPS_DEMO_STEREO),yes)
	$(Q)$(call sj_echo_log, info , "2. Check the Result $(SJ_PATH_PSDKRA)/tiovx/conformance_tests/test_data/psdkra/stereo_test_data/Stereo0001/output ");
	$(Q)ls -l $(SJ_PATH_PSDKRA)/tiovx/conformance_tests/test_data/psdkra/stereo_test_data/Stereo0001/output
else 
	$(Q)$(call sj_echo_log, info , "2. Check the Result $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_APPS_PROFILE)/$(SJ_APPS_DEMO_OUTPUT) ");
	$(Q)ls -l $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_APPS_PROFILE)/$(SJ_APPS_DEMO_OUTPUT)
endif
	$(Q)$(call sj_echo_log, info , "3. config file : $(SJ_PATH_VISION_SDK_BUILD)/apps/$(SJ_APPS_RUN_DEMO_FOLDER)/config/$(SJ_APPS_DEMO_CFG) ");
	$(Q)$(call sj_echo_log, info , "4. apps_run_demo ... done! ");

# test TIDL demo 
APPS_FREDY_MODEL ?= yes
apps_pc_run_demo_tidl:
	$(Q)$(call sj_echo_log, info , "1. apps_run_demo_tidl ...  ");
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
	$(Q)$(call sj_echo_log, info , "# network file  : $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_net_$(ti_dl_MODEL).bin ");
	$(Q)$(call sj_echo_log, info , "#  I/O    file  : $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_io_$(ti_dl_MODEL)1.bin ");
	$(Q)$(call sj_echo_log, info , "0. Config the Model PATH ");
ifeq ($(APPS_FREDY_MODEL),yes)
	$(Q)$(call sj_echo_log, info , "0. APPS_FREDY_MODEL = $(APPS_FREDY_MODEL) ");
	sed -i "/^tidl_config_file_path/c tidl_config_file_path    $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_io_$(ti_dl_MODEL)_1.bin"  $(SJ_PATH_VISION_SDK_BUILD)/apps/$(SJ_APPS_RUN_DEMO_FOLDER)/config/$(SJ_APPS_DEMO_CFG)
	sed -i "/^tidl_network_file_path/c tidl_network_file_path  $(SJ_TIDL_PATH_FREDY)/test/testvecs/config/tidl_models/$(SJ_TIDL_TYPE)/tidl_net_$(ti_dl_MODEL).bin"  $(SJ_PATH_VISION_SDK_BUILD)/apps/$(SJ_APPS_RUN_DEMO_FOLDER)/config/$(SJ_APPS_DEMO_CFG)
else
	$(Q)$(call sj_echo_log, info , "0. APPS_FREDY_MODEL = $(APPS_FREDY_MODEL) ");
	sed -i "/^tidl_config_file_path/c tidl_config_file_path    /ti/j7/workarea/tiovx/conformance_tests/test_data/tivx/tidl_models/tidl_io_mobilenet_v1_1.bin"  $(SJ_PATH_VISION_SDK_BUILD)/apps/$(SJ_APPS_RUN_DEMO_FOLDER)/config/$(SJ_APPS_DEMO_CFG)
	sed -i "/^tidl_network_file_path/c tidl_network_file_path  /ti/j7/workarea/tiovx/conformance_tests/test_data/tivx/tidl_models/tidl_net_mobilenet_v1.bin"  $(SJ_PATH_VISION_SDK_BUILD)/apps/$(SJ_APPS_RUN_DEMO_FOLDER)/config/$(SJ_APPS_DEMO_CFG)
endif 
	$(Q)$(call sj_echo_log, info , "1. Run Demo ");
	cd $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_APPS_PROFILE)/  && \
	./vx_$(SJ_APPS_RUN_DEMO_NAME) --cfg $(SJ_PATH_VISION_SDK_BUILD)/apps/$(SJ_APPS_RUN_DEMO_FOLDER)/config/$(SJ_APPS_DEMO_CFG)
	$(Q)$(call sj_echo_log, info , "2. Check the Result $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_APPS_PROFILE)/app_tidl_out/ ");
	$(Q)ls -l $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_APPS_PROFILE)/app_tidl_out/
	$(Q)$(call sj_echo_log, info , "3. config file : $(SJ_PATH_VISION_SDK_BUILD)/apps/$(SJ_APPS_RUN_DEMO_FOLDER)/config/$(SJ_APPS_DEMO_CFG) ");
	$(Q)$(call sj_echo_log, info , "1. apps_run_demo_tidl ...  done! ");

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
tiovx_pyovx_generate_new_kernel:
	$(Q)$(call sj_echo_log, info , "start to generate the kernel for test !!!");
	export CUSTOM_APPLICATION_PATH=$(SJ_PATH_VISION_SDK_BUILD)/kernels/$(SJ_TIOVX_GENERATE_DIR) && \
	export VISION_APPS_PATH=$(SJ_PATH_VISION_SDK_BUILD) && \
	python3 $(SJ_PATH_RESOURCE)/psdkra/pyovx/$(SJ_TIOVX_GENETATE_SCRIPT)
	$(Q)$(call sj_echo_log, info , "check the below path: $(SJ_PATH_VISION_SDK_BUILD)/kernels/test !!!");

# please set the below parameter. 
SJ_TIOVX_APP_DEMO_NAME=user_kernel_pytiovx_uc
tiovx_pyovx_generate_new_app:
	$(Q)$(call sj_echo_log, info , "start to generate the app for test !!!");
	export VISION_APPS_PATH=$(SJ_PATH_VISION_SDK_BUILD) && \
	mkdir -p $(SJ_PATH_VISION_SDK_BUILD)/apps/vx_tutorial_graph_$(SJ_TIOVX_APP_DEMO_NAME) && \
	cp $(SJ_PATH_RESOURCE)/psdkra/pyovx/vx_tutorial_graph_$(SJ_TIOVX_APP_DEMO_NAME).py $(SJ_PATH_VISION_SDK_BUILD)/apps/vx_tutorial_graph_$(SJ_TIOVX_APP_DEMO_NAME) && \
	cd $(SJ_PATH_VISION_SDK_BUILD)/apps/vx_tutorial_graph_$(SJ_TIOVX_APP_DEMO_NAME) && python3 ./vx_tutorial_graph_$(SJ_TIOVX_APP_DEMO_NAME).py
	$(Q)$(call sj_echo_log, info , "check the below path: $(SJ_PATH_VISION_SDK_BUILD)/apps/vx_tutorial_graph_$(SJ_TIOVX_APP_DEMO_NAME) !!!");

tiovx_pyovx_generate_new_app_run:
	cd $(SJ_PATH_VISION_SDK_BUILD)//out/PC/x86_64/LINUX/$(SJ_PROFILE)/ &&  ./vx_app_vx_tutorial_graph_$(SJ_TIOVX_APP_DEMO_NAME)


# Apps build: 
SJ_APPS_BASIC_DEMO=apps.basic_demos.app_c7x_kernel.c7x.J721S2.FREERTOS.C7120.release
SJ_APPS_BASIC_DEMO_TARGET=$(SJ_PATH_PSDKRA)/vision_apps/out/J721S2/A72/LINUX/release/vx_app_c7x*
apps_basic_demo_vision_build: 
	$(Q)$(call sj_echo_log, info , "1. apps_basic_demo_vision_build ...... ");
	$(Q)$(call sj_echo_log, warning , "Set the SJ_APPS_BASIC_DEMO to build new apps ...... ");
	cd $(SJ_PATH_PSDKRA)/vision_apps && make $(SJ_APPS_BASIC_DEMO)
	ls -l $(SJ_APPS_BASIC_DEMO_TARGET)
	$(Q)$(call sj_echo_log, info , "1. apps_basic_demo_vision_build ...... done!");

apps_basic_demo_vfb_build: 
	$(Q)$(call sj_echo_log, info , "1. apps_basic_demo_vfb_build ...... ");
	cd $(SJ_PATH_PSDKRA)/vision_apps && make apps.basic_demos.app_vfb_image_display.J721S2.LINUX.A72.release_clean
	cd $(SJ_PATH_PSDKRA)/vision_apps && make apps.basic_demos.app_vfb_image_display.J721S2.LINUX.A72.release
	ls -l $(SJ_PATH_PSDKRA)/vision_apps/out/J721S2/A72/LINUX/release/vx_app_vfb*
	$(Q)$(call sj_echo_log, info , "1. apps_basic_demo_vfb_build ...... done!");
	

#==============================================================================
# QT the staus. 
#==============================================================================	

apps_qt_showimage_download:
	$(Q)$(call sj_echo_log, info , "1. apps_basic_demo_vision_build ...... ");
	$(Q)$(call sj_echo_log, file , "download to", "$(SJ_PATH_APPS)/QT/image_show_qt");
	$(Q)if [ ! -d  $(SJ_PATH_APPS)/QT/image_show_qt ] ; then \
		cd $(SJ_PATH_APPS)/QT/  && git clone $(SJ_GIT_SERVER)/scm/psdkla/image_show_qt.git ; \
	else \
		echo "$(SJ_PATH_SDK)/QT/image_show_qt already exist !!!"; \
	fi
	$(Q)$(call sj_echo_log, info , "1. apps_basic_demo_vision_build ...... done!");

apps_qt_showimage_build:
	$(Q)$(call sj_echo_log, info , "1. apps_qt_showimage_build ...... ");
	$(Q)$(call sj_echo_log, file , "apps path", "$(SJ_PATH_APPS)/QT/image_show_qt");
	$(Q)$(call sj_echo_log, file , "README", "$(SJ_PATH_APPS)/image_show_qt/readme.md");
	cd $(SJ_PATH_PSDKLA)/ && source linux-devkit/environment-setup && cd $(SJ_PATH_APPS)/QT/image_show_qt && ./makeImgShow
	$(Q)$(call sj_echo_log, file , "image", "$(SJ_PATH_APPS)/QT/image_show_qt/showImage");
	$(Q)$(call sj_echo_log, info , "1. apps_qt_showimage_build ...... done!");


apps_qt_qopenglwidget_download:
	$(Q)$(call sj_echo_log, info , "1. apps_qt_qopenglwidget_download ...... ");
	$(Q)$(call sj_echo_log, file , "apps path", "$(SJ_PATH_APPS)/QT/shadow-map-using-QOpenGLWidget");
	$(Q)if [ ! -d  $(SJ_PATH_APPS)/QT/shadow-map-using-QOpenGLWidget ] ; then \
		cd $(SJ_PATH_APPS)/QT/  && git clone $(SJ_GIT_SERVER)/scm/psdkla/shadow-map-using-QOpenGLWidget.git ; \
	else \
		echo "$(SJ_PATH_APPS)/QT/shadow-map-using-QOpenGLWidget already exist !!!"; \
	fi
	$(Q)$(call sj_echo_log, info , "1. apps_qt_qopenglwidget_download ...... done! ");

apps_qt_qopenglwidget_build:
	$(Q)$(call sj_echo_log, info , "1. apps_qt_qopenglwidget_build ...... ");
	$(Q)$(call sj_echo_log, file , "apps path", "$(SJ_PATH_APPS)/QT/shadow-map-using-QOpenGLWidget");
	cd $(SJ_PATH_PSDKLA)/ && source linux-devkit/environment-setup && cd $(SJ_PATH_APPS)/QT/shadow-map-using-QOpenGLWidget && ./makeqt
	$(Q)$(call sj_echo_log, info , "1. apps_qt_qopenglwidget_build ...... done!");

#==============================================================================
# Apps : helloworld
#==============================================================================	
apps_linux_helloworld_download:
	$(Q)$(call sj_echo_log, info , "1. apps_basic_demo_vision_build ...... ");
	$(Q)$(call sj_echo_log, file , "download to", "$(SJ_PATH_APPS)/helloworld");
	$(Q)if [ ! -d  $(SJ_PATH_APPS)/helloworld ] ; then \
		cd $(SJ_PATH_APPS)/  && git clone $(SJ_GIT_SERVER)/scm/psdkla/helloworld.git ; \
	else \
		echo "$(SJ_PATH_SDK)/helloworld already exist !!!"; \
	fi
	$(Q)$(call sj_echo_log, info , "1. apps_basic_demo_vision_build ...... done!");

apps_linux_helloworld_build:
	$(Q)$(call sj_echo_log, info , "1. apps_linux_helloworld_build ...... ");
	$(Q)$(call sj_echo_log, file , "Apps PATH", "$(SJ_PATH_APPS)/helloworld");
	$(Q)$(call sj_echo_log, file , "README", "$(SJ_PATH_APPS)/helloworld/readme.md");
	cd $(SJ_PATH_PSDKLA)/ && source linux-devkit/environment-setup && cd $(SJ_PATH_APPS)/helloworld/ && make
	$(Q)$(call sj_echo_log, file , "App Image", "$(SJ_PATH_APPS)/helloworld/helloworld");
	$(Q)$(call sj_echo_log, info , "1. apps_linux_helloworld_build ...... done!");

apps_linux_helloworld_clean:
	$(Q)$(call sj_echo_log, info , "1. apps_linux_helloworld_clean ...... ");
	$(Q)$(call sj_echo_log, file , "Apps PATH", "$(SJ_PATH_APPS)/helloworld");
	cd $(SJ_PATH_PSDKLA)/ && source linux-devkit/environment-setup && cd $(SJ_PATH_APPS)/helloworld/ && make clean
	$(Q)$(call sj_echo_log, info , "1. apps_linux_helloworld_clean ...... done!");

#==============================================================================
# Apps : fbimagesave
#==============================================================================	
apps_linux_fbimagesave_download:
	$(Q)$(call sj_echo_log, info , "1. apps_linux_fbimagesave_download ...... ");
	$(Q)$(call sj_echo_log, file , "download to", "$(SJ_PATH_APPS)/fb_image_save");
	$(Q)if [ ! -d  $(SJ_PATH_APPS)/fb_image_save ] ; then \
		cd $(SJ_PATH_APPS)/  && git clone $(SJ_GIT_SERVER)/scm/psdkla/fb_image_save.git ; \
	else \
		echo "$(SJ_PATH_SDK)/fb_image_save already exist !!!"; \
	fi
	$(Q)$(call sj_echo_log, info , "1. apps_linux_fbimagesave_download ...... done!");


apps_linux_fbimagesave_build:
	$(Q)$(call sj_echo_log, info , "1. apps_linux_fbimagesave_build ...... ");
	$(Q)$(call sj_echo_log, file , "App PATH", "$(SJ_PATH_APPS)/fb_image_save");
	$(Q)$(call sj_echo_log, file , "README", "$(SJ_PATH_APPS)/fb_image_save/readme.md");
	cd $(SJ_PATH_PSDKLA)/ && source linux-devkit/environment-setup && cd $(SJ_PATH_APPS)/fb_image_save/ && make
	$(Q)$(call sj_echo_log, file , "App Image", "$(SJ_PATH_APPS)/fb_image_save/fb_image_save");
	$(Q)$(call sj_echo_log, info , "1. apps_linux_fbimagesave_build ...... done!");

apps_linux_fbimagesave_clean:
	$(Q)$(call sj_echo_log, info , "1. apps_linux_fbimagesave_clean ...... ");
	$(Q)$(call sj_echo_log, file , "download to", "$(SJ_PATH_APPS)/fb_image_save");
	cd $(SJ_PATH_PSDKLA)/ && source linux-devkit/environment-setup && cd $(SJ_PATH_APPS)/fb_image_save/ && make clean
	$(Q)$(call sj_echo_log, info , "1. apps_linux_fbimagesave_clean ...... done!");


#==============================================================================
# Apps : fbimagesave
#==============================================================================	
apps_linux_kmsfbshot_download:
	$(Q)$(call sj_echo_log, info , "1. apps_linux_kmsfbshot_download ...... ");
	$(Q)$(call sj_echo_log, file , "download to", "$(SJ_PATH_APPS)/kmsfbshot");
	$(Q)if [ ! -d  $(SJ_PATH_APPS)/kmsfbshot ] ; then \
		cd $(SJ_PATH_APPS)/  && git clone $(SJ_GIT_SERVER)/scm/psdkla/kmsfbshot.git ; \
	else \
		echo "$(SJ_PATH_SDK)/kmsfbshot already exist !!!"; \
	fi
	$(Q)$(call sj_echo_log, info , "1. apps_linux_kmsfbshot_download ...... done!");


apps_linux_kmsfbshot_build:
	$(Q)$(call sj_echo_log, info , "1. apps_linux_kmsfbshot_build ...... ");
	$(Q)$(call sj_echo_log, file , "App PATH", "$(SJ_PATH_APPS)/kmsfbshot");
	$(Q)$(call sj_echo_log, file , "README", "$(SJ_PATH_APPS)/kmsfbshot/readme.md");
	cd $(SJ_PATH_PSDKLA)/ && source linux-devkit/environment-setup && cd $(SJ_PATH_APPS)/kmsfbshot/ && make
	$(Q)$(call sj_echo_log, file , "App Image", "$(SJ_PATH_APPS)/kmsfbshot/kmsfbshot");
	$(Q)$(call sj_echo_log, info , "1. apps_linux_kmsfbshot_build ...... done!");

apps_linux_kmsfbshot_clean:
	$(Q)$(call sj_echo_log, info , "1. apps_linux_kmsfbshot_clean ...... ");
	$(Q)$(call sj_echo_log, file , "download to", "$(SJ_PATH_APPS)/kmsfbshot_clean");
	cd $(SJ_PATH_PSDKLA)/ && source linux-devkit/environment-setup && cd $(SJ_PATH_APPS)/kmsfbshot_clean/ && make clean
	$(Q)$(call sj_echo_log, info , "1. apps_linux_kmsfbshot_clean ...... done!");


#==============================================================================
# Stradvision: CIIE Demo
#==============================================================================	
apps_demo_sv_front_download:
	$(Q)$(call sj_echo_log, info , "1. apps_demo_sv_front_download ...... ");
	cd $(SJ_PATH_J7_SDK) && git clone ssh://git@10.85.130.233:7999/com/demo-ciie.git
	$(Q)$(call sj_echo_log, info , "1. apps_demo_sv_front_download ...... done");

apps_demo_sv_front_setup_sd: check_paths_sd_boot check_paths_sd_rootfs
	$(Q)$(call sj_echo_log, info , "1. apps_demo_sv_front_setup_sd ...... ");
	cd $(SJ_PATH_J7_SDK)/demo-ciie/stradVision_front_camera/sv_v_2_0_0_rel_20210910/sv_v2_0_0_rel ; \
	tar -zxvf BOOT_sv_v2_0_0_rel.tar.gz -C $(SJ_BOOT)/../; \
	sudo tar -zxvf rootfs_sv_v2_0_0_rel.tar.gz -C $(SJ_ROOTFS)/../; \
	sync
	echo "#    Demo setup done!!!"
	$(Q)$(call sj_echo_log, info , "1. apps_demo_sv_front_setup_sd ......");

apps_demo_sv_front_run:
	$(Q)$(call sj_echo_log, info , "1. apps_demo_sv_front_run ......");
	# the EVM IP is : 192.168.0.200 , please confirm your IP. 
	# 1.  boot the board and click icon. 
	# 2.  click Front VT Demo
	# 3.  run vision_tester
	cd $(SJ_PATH_J7_SDK)/demo-ciie/stradVision_front_camera/sv_v_2_0_0_rel_20210910/sv_v2_0_0_rel/vision_tester && ./run_vt.sh
	$(Q)$(call sj_echo_log, info , "1. apps_demo_sv_front_run ...... done");

apps_help:
	$(Q)$(call sj_echo_log, info , "1. apps_help ... "); 
	$(Q)$(call sj_echo_log, info , "# Available build targets are:"); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, help , "apps_pc_run_demo"               , "pc apps demo run ... "); 
	$(Q)$(call sj_echo_log, help , "apps_pc_run_demo_tidl"          , "pc apps demo tidl runs..."); 
	$(Q)$(call sj_echo_log, help , "apps_basic_demo_vfb_build"      , "pc apps basic demo vfb building...");
	$(Q)$(call sj_echo_log, help , "apps_basic_demo_vision_build"   , "pc apps basic demo vfb building... setting before building");  
	$(Q)$(call sj_echo_log, help , "apps_qt_showimage_download"     , "ep qt showimage demo downloading..."); 
	$(Q)$(call sj_echo_log, help , "apps_qt_showimage_build"        , "ep qt showimage demo building..."); 
	$(Q)$(call sj_echo_log, help , "apps_qt_qopenglwidget_download" , "ep qt qopenglwidget demo downloading ..."); 
	$(Q)$(call sj_echo_log, help , "apps_qt_qopenglwidget_build"    , "ep qt qopenglwidget demo building ..."); 
	$(Q)$(call sj_echo_log, help , "apps_linux_helloworld_download" , "ep demo downloading..."); 
	$(Q)$(call sj_echo_log, help , "apps_linux_helloworld_build"    , "ep demo building..."); 
	$(Q)$(call sj_echo_log, help , "apps_linux_helloworld_clean"    , "ep demo cleaning..."); 
	$(Q)$(call sj_echo_log, help , "apps_linux_fbimagesave_download", "ep demo downloading..."); 
	$(Q)$(call sj_echo_log, help , "apps_linux_fbimagesave_build"   , "ep demo building..."); 
	$(Q)$(call sj_echo_log, help , "apps_linux_fbimagesave_clean"   , "ep demo cleaning..."); 
	$(Q)$(call sj_echo_log, help , "apps_demo_sv_front_download"    , "ep demo sv CIIE..."); 
	$(Q)$(call sj_echo_log, help , "apps_demo_sv_front_setup_sd"    , "ep demo sv CIIE ..."); 
	$(Q)$(call sj_echo_log, help , "apps_demo_sv_front_run"         , "ep demo sv CIIE..."); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, info , "1. apps_help ... done! "); 