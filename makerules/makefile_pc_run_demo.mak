##########################################
#                                        #
# Run demo on PC				         #
#                                        #
##########################################
# 1. C7x kernel application
c7x_kernel_application_cfg_show:
	cat $(SJ_PATH_VISION_SDK_BUILD)/apps/basic_demos/app_c7x_kernel/config/app.cfg
c7x_kernel_application_cfg_show_bmp1:
	cd $(SJ_PATH_RESOURCE)/c7x_kernel_application/  && ffplay img_1.bmp 
c7x_kernel_application_cfg_show_bmp2:
	cd $(SJ_PATH_RESOURCE)/c7x_kernel_application/  && ffplay img_2.bmp 
	
c7x_kernel_application_cfg:
	cp $(SJ_PATH_RESOURCE)/c7x_kernel_application/c7x_kernel_application.cfg  $(SJ_PATH_VISION_SDK_BUILD)/apps/basic_demos/app_c7x_kernel/config/app.cfg
#	cp $(SJ_PATH_PSDKRA)/tiovx/conformance_tests/test_data/psdkra/app_c7x/img_2.bmp /home/fredy/install/jacinto7/resource/c7x_kernel_application
#	cp $(SJ_PATH_PSDKRA)/tiovx/conformance_tests/test_data/psdkra/app_c7x/img_1.bmp /home/fredy/install/jacinto7/resource/c7x_kernel_application
c7x_kernel_application_run:
	cd $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_PROFILE)/  && ./vx_app_c7x_kernel --cfg $(SJ_PATH_VISION_SDK_BUILD)/apps/basic_demos/app_c7x_kernel/config/app.cfg
c7x_kernel_application_run_show: c7x_kernel_application_run
	cd $(SJ_PATH_RESOURCE)/c7x_kernel_application  && ffplay app_c7x_out_img.bmp
# 2. C7x kernel application_or
c7x_kernel_application_or_cfg_show:
	cat $(SJ_PATH_VISION_SDK_BUILD)/apps/basic_demos/app_c7x_kernel_or/config/app.cfg
c7x_kernel_application_or_cfg_show_bmp1:
	cd $(SJ_PATH_RESOURCE)/c7x_kernel_application_or/  && ffplay img_1.bmp 
c7x_kernel_application_or_cfg_show_bmp2:
	cd $(SJ_PATH_RESOURCE)/c7x_kernel_application_or/  && ffplay img_2.bmp 
c7x_kernel_application_or_cfg:
	cp $(SJ_PATH_RESOURCE)/c7x_kernel_application_or/c7x_kernel_application_or.cfg  $(SJ_PATH_VISION_SDK_BUILD)/apps/basic_demos/app_c7x_kernel_or/config/app.cfg
c7x_kernel_application_or_run:
	cd $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_PROFILE)/  && ./vx_app_c7x_kernel_or --cfg $(SJ_PATH_VISION_SDK_BUILD)/apps/basic_demos/app_c7x_kernel_or/config/app.cfg
c7x_kernel_application_or_run_show: c7x_kernel_application_or_run
	cd $(SJ_PATH_RESOURCE)/c7x_kernel_application_or  && ffplay app_c7x_out_img_or.bmp

# 2. C7x kernel application_xor
c7x_kernel_application_xor_cfg_show:
	cat $(SJ_PATH_VISION_SDK_BUILD)/apps/basic_demos/app_c7x_kernel_xor/config/app.cfg
c7x_kernel_application_xor_cfg_show_bmp1:
	cd $(SJ_PATH_RESOURCE)/c7x_kernel_application_xor/  && ffplay img_1.bmp 
c7x_kernel_application_xor_cfg_show_bmp2:
	cd $(SJ_PATH_RESOURCE)/c7x_kernel_application_xor/  && ffplay img_2.bmp 
c7x_kernel_application_xor_cfg:
	cp $(SJ_PATH_RESOURCE)/c7x_kernel_application_xor/c7x_kernel_application_xor.cfg  $(SJ_PATH_VISION_SDK_BUILD)/apps/basic_demos/app_c7x_kernel_xor/config/app.cfg
c7x_kernel_application_xor_run:
	cd $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_PROFILE)/  && ./vx_app_c7x_kernel_xor --cfg $(SJ_PATH_VISION_SDK_BUILD)/apps/basic_demos/app_c7x_kernel_xor/config/app.cfg
c7x_kernel_application_xor_run_show: c7x_kernel_application_xor_run
	cd $(SJ_PATH_RESOURCE)/c7x_kernel_application_xor  && ffplay app_c7x_out_img_xor.bmp
		
# 3	
dense_optical_flow_cfg_show:
	cat $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_PROFILE)/dense_optical_flow.cfg
dense_optical_flow_cfg_show_bmp1:
	cd $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_PROFILE)/  && ffplay img_1.bmp 
dense_optical_flow_cfg_show_bmp2:
	cd $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_PROFILE)/  && ffplay img_2.bmp 
dense_optical_flow_cfg:
	cp $(SJ_PATH_VISION_SDK_BUILD)/apps/basic_demos/app_c7x_kernel/config/app.cfg  $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(PROFILE)/dense_optical_flow.cfg
	cp $(SJ_PATH_PSDKRA)/tiovx/conformance_tests/test_data/psdkra/app_c7x/img_2.bmp $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(PROFILE)/
	cp $(SJ_PATH_PSDKRA)/tiovx/conformance_tests/test_data/psdkra/app_c7x/img_1.bmp $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(PROFILE)/
dense_optical_flow_run:
	cd $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_PROFILE)/  && ./vx_app_dense_optical_flow --cfg $(SJ_PATH_VISION_SDK_BUILD)/apps/basic_demos/app_dof/config/app.cfg

dense_optical_flow_run_show:
	cd $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_PROFILE)/  && ./vx_app_dense_optical_flow --cfg dense_optical_flow.cfg
	cd $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_PROFILE)/  && ffplay app_c7x_out_img.bmp

# 3. Stereo Disparity Engine
stereo_disparity_engine_cfg_show:
	cat $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_PROFILE)/stereo_disparity_engine.cfg
stereo_disparity_engine_cfg_show_bmp1:
	cd $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_PROFILE)/  && ffplay img_1.bmp 
stereo_disparity_engine_cfg_show_bmp2:
	cd $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_PROFILE)/  && ffplay img_2.bmp 
stereo_disparity_engine_cfg:
	cp $(SJ_PATH_VISION_SDK_BUILD)/apps/basic_demos/app_c7x_kernel/config/app.cfg  $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(PROFILE)/stereo_disparity_engine.cfg
	cp $(SJ_PATH_PSDKRA)/tiovx/conformance_tests/test_data/psdkra/app_c7x/img_2.bmp $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(PROFILE)/
	cp $(SJ_PATH_PSDKRA)/tiovx/conformance_tests/test_data/psdkra/app_c7x/img_1.bmp $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(PROFILE)/
stereo_disparity_engine_run:
	cd $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_PROFILE)/  && ./vx_app_stereo_depth --cfg stereo_disparity_engine.cfg
stereo_disparity_engine_run_show:
	cd $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_PROFILE)/  && ./vx_app_stereo_depth --cfg stereo_disparity_engine.cfg
	cd $(SJ_PATH_VISION_SDK_BUILD)/out/PC/x86_64/LINUX/$(SJ_PROFILE)/  && ffplay app_c7x_out_img.bmp
#vision_sdk_all: apps_clean depend 
#	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) vision_sdk -s -j$(CPU_NUM)

#depend:
#	$(MAKE) -C $(SJ_PATH_VISION_SDK_BUILD) depend -s -j$(CPU_NUM)

##########################################
#                                        #
# Tutorial          			         #
#                                        #
##########################################
vx_tutorial_exe_run:
	@echo "fredy>>>>>: please confirm SJ_PATH_VX_TEST_DATA"
	$(SJ_PATH_TUTORIAL_RUN)/$(SJ_PROFILE)/vx_tutorial_exe
vx_tutorial_exe_mk:
	$(MAKE) -C $(SJ_PATH_PSDKRA)/tiovx -s -j$(CPU_NUM)
vx_tutorial_exe_show_orignal:
	cd $(SJ_PATH_VX_TEST_DATA) && ffplay colors.bmp
vx_tutorial_exe_show_save: vx_tutorial_exe_show_orignal
	cd $(SJ_PATH_VX_TEST_DATA) && ffplay vx_tutorial_image_load_save_out.bmp
vx_tutorial_exe_show_roi: vx_tutorial_exe_show_orignal
	cd $(SJ_PATH_VX_TEST_DATA) && ffplay vx_tutorial_image_crop_roi.bmp
vx_tutorial_exe_show_channel: 
	cd $(SJ_PATH_VX_TEST_DATA) && ffplay vx_tutorial_image_extract_channel_out.bmp
vx_tutorial_exe_show_histogram: 
	cd $(SJ_PATH_VX_TEST_DATA) && ffplay vx_tutorial_image_histogram_out.bmp

