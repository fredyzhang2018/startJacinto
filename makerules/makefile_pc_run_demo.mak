##########################################
#                                        #
# Run demo on PC				         #
#                                        #
##########################################
# 1. C7x kernel application
c7x_kernel_application_cfg_show:
	cat $(VISION_SDK_BUILD_PATH)/apps/basic_demos/app_c7x_kernel/config/app.cfg
c7x_kernel_application_cfg_show_bmp1:
	cd $(resouce_PATH)/c7x_kernel_application/  && ffplay img_1.bmp 
c7x_kernel_application_cfg_show_bmp2:
	cd $(resouce_PATH)/c7x_kernel_application/  && ffplay img_2.bmp 
	
c7x_kernel_application_cfg:
	cp $(resouce_PATH)/c7x_kernel_application/c7x_kernel_application.cfg  $(VISION_SDK_BUILD_PATH)/apps/basic_demos/app_c7x_kernel/config/app.cfg
#	cp $(PSDKRA_PATH)/tiovx/conformance_tests/test_data/psdkra/app_c7x/img_2.bmp /home/fredy/install/jacinto7/resource/c7x_kernel_application
#	cp $(PSDKRA_PATH)/tiovx/conformance_tests/test_data/psdkra/app_c7x/img_1.bmp /home/fredy/install/jacinto7/resource/c7x_kernel_application
c7x_kernel_application_run:
	cd $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/  && ./vx_app_c7x_kernel --cfg $(VISION_SDK_BUILD_PATH)/apps/basic_demos/app_c7x_kernel/config/app.cfg
c7x_kernel_application_run_show: c7x_kernel_application_run
	cd $(resouce_PATH)/c7x_kernel_application  && ffplay app_c7x_out_img.bmp
# 2. C7x kernel application_or
c7x_kernel_application_or_cfg_show:
	cat $(VISION_SDK_BUILD_PATH)/apps/basic_demos/app_c7x_kernel_or/config/app.cfg
c7x_kernel_application_or_cfg_show_bmp1:
	cd $(resouce_PATH)/c7x_kernel_application_or/  && ffplay img_1.bmp 
c7x_kernel_application_or_cfg_show_bmp2:
	cd $(resouce_PATH)/c7x_kernel_application_or/  && ffplay img_2.bmp 
c7x_kernel_application_or_cfg:
	cp $(resouce_PATH)/c7x_kernel_application_or/c7x_kernel_application_or.cfg  $(VISION_SDK_BUILD_PATH)/apps/basic_demos/app_c7x_kernel_or/config/app.cfg
c7x_kernel_application_or_run:
	cd $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/  && ./vx_app_c7x_kernel_or --cfg $(VISION_SDK_BUILD_PATH)/apps/basic_demos/app_c7x_kernel_or/config/app.cfg
c7x_kernel_application_or_run_show: c7x_kernel_application_or_run
	cd $(resouce_PATH)/c7x_kernel_application_or  && ffplay app_c7x_out_img_or.bmp

# 2. C7x kernel application_xor
c7x_kernel_application_xor_cfg_show:
	cat $(VISION_SDK_BUILD_PATH)/apps/basic_demos/app_c7x_kernel_xor/config/app.cfg
c7x_kernel_application_xor_cfg_show_bmp1:
	cd $(resouce_PATH)/c7x_kernel_application_xor/  && ffplay img_1.bmp 
c7x_kernel_application_xor_cfg_show_bmp2:
	cd $(resouce_PATH)/c7x_kernel_application_xor/  && ffplay img_2.bmp 
c7x_kernel_application_xor_cfg:
	cp $(resouce_PATH)/c7x_kernel_application_xor/c7x_kernel_application_xor.cfg  $(VISION_SDK_BUILD_PATH)/apps/basic_demos/app_c7x_kernel_xor/config/app.cfg
c7x_kernel_application_xor_run:
	cd $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/  && ./vx_app_c7x_kernel_xor --cfg $(VISION_SDK_BUILD_PATH)/apps/basic_demos/app_c7x_kernel_xor/config/app.cfg
c7x_kernel_application_xor_run_show: c7x_kernel_application_xor_run
	cd $(resouce_PATH)/c7x_kernel_application_xor  && ffplay app_c7x_out_img_xor.bmp
		
# 3	
dense_optical_flow_cfg_show:
	cat $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/dense_optical_flow.cfg
dense_optical_flow_cfg_show_bmp1:
	cd $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/  && ffplay img_1.bmp 
dense_optical_flow_cfg_show_bmp2:
	cd $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/  && ffplay img_2.bmp 
dense_optical_flow_cfg:
	cp $(VISION_SDK_BUILD_PATH)/apps/basic_demos/app_c7x_kernel/config/app.cfg  $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/dense_optical_flow.cfg
	cp $(PSDKRA_PATH)/tiovx/conformance_tests/test_data/psdkra/app_c7x/img_2.bmp $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/
	cp $(PSDKRA_PATH)/tiovx/conformance_tests/test_data/psdkra/app_c7x/img_1.bmp $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/
dense_optical_flow_run:
	cd $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/  && ./vx_app_dense_optical_flow --cfg $(VISION_SDK_BUILD_PATH)/apps/basic_demos/app_dof/config/app.cfg

dense_optical_flow_run_show:
	cd $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/  && ./vx_app_dense_optical_flow --cfg dense_optical_flow.cfg
	cd $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/  && ffplay app_c7x_out_img.bmp

# 3. Stereo Disparity Engine
stereo_disparity_engine_cfg_show:
	cat $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/stereo_disparity_engine.cfg
stereo_disparity_engine_cfg_show_bmp1:
	cd $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/  && ffplay img_1.bmp 
stereo_disparity_engine_cfg_show_bmp2:
	cd $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/  && ffplay img_2.bmp 
stereo_disparity_engine_cfg:
	cp $(VISION_SDK_BUILD_PATH)/apps/basic_demos/app_c7x_kernel/config/app.cfg  $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/stereo_disparity_engine.cfg
	cp $(PSDKRA_PATH)/tiovx/conformance_tests/test_data/psdkra/app_c7x/img_2.bmp $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/
	cp $(PSDKRA_PATH)/tiovx/conformance_tests/test_data/psdkra/app_c7x/img_1.bmp $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/
stereo_disparity_engine_run:
	cd $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/  && ./vx_app_stereo_depth --cfg stereo_disparity_engine.cfg
stereo_disparity_engine_run_show:
	cd $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/  && ./vx_app_stereo_depth --cfg stereo_disparity_engine.cfg
	cd $(VISION_SDK_BUILD_PATH)/out/PC/x86_64/LINUX/$(PROFILE)/  && ffplay app_c7x_out_img.bmp
#vision_sdk_all: apps_clean depend 
#	$(MAKE) -C $(VISION_SDK_BUILD_PATH) vision_sdk -s -j$(CPU_NUM)

#depend:
#	$(MAKE) -C $(VISION_SDK_BUILD_PATH) depend -s -j$(CPU_NUM)

##########################################
#                                        #
# Tutorial          			         #
#                                        #
##########################################
vx_tutorial_exe_run:
	@echo "fredy>>>>>: please confirm VX_TEST_DATA_PATH"
	$(TUTORIAL_RUN_PATH)/$(PROFILE)/vx_tutorial_exe
vx_tutorial_exe_mk:
	$(MAKE) -C $(PSDKRA_PATH)/tiovx -s -j$(CPU_NUM)
vx_tutorial_exe_show_orignal:
	cd $(VX_TEST_DATA_PATH) && ffplay colors.bmp
vx_tutorial_exe_show_save: vx_tutorial_exe_show_orignal
	cd $(VX_TEST_DATA_PATH) && ffplay vx_tutorial_image_load_save_out.bmp
vx_tutorial_exe_show_roi: vx_tutorial_exe_show_orignal
	cd $(VX_TEST_DATA_PATH) && ffplay vx_tutorial_image_crop_roi.bmp
vx_tutorial_exe_show_channel: 
	cd $(VX_TEST_DATA_PATH) && ffplay vx_tutorial_image_extract_channel_out.bmp
vx_tutorial_exe_show_histogram: 
	cd $(VX_TEST_DATA_PATH) && ffplay vx_tutorial_image_histogram_out.bmp

