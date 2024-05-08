# Edit this file to suit your specific build needs
#
# Board Support: j7200_evm j721e_evm
SJ_G_BOARD = j721e_evm
# mpu1_0, mcu1_0, mcu1_1, mcu2_0, mcu2_1, mcu3_0, mcu3_1, c66xdsp_1, c66xdsp_2, c7
SJ_G_CORE = mcu1_0
# can_eth_gateway_app depend_can_eth_gateway depend_can_generator 
#  if you encountered some issues, please run : depend_can_eth_gateway depend_can_generator
SJ_G_MODULES =  can_eth_gateway_app  can_traffic_generator_app
# Build Profile : debug or release
SJ_G_BUILD_PROFILE= debug
# Tools: send_1722.out and recv_1722.out from TI.
# Ethernet Interface : Changes to yours. 
SJ_G_ETH0 = enp0s31f6
SJ_G_ETH0_MAC = 00:68:eb:87:17:b1
SJ_G_ETH1 = enx0068eb8717b3
SJ_G_ETH1_MAC = 00:68:eb:87:17:b3
# Gateway MAC: read from log or ccs console
SJ_G_GATEWAY_MAC = 70:ff:76:1d:92:c3

# Build the demo
gateway_build: check_paths_PSDKRA
	$(Q)$(call sj_echo_log, info , "1. gateway-build ....."); 
	$(Q)echo "board : $(SJ_G_BOARD)  modules: $(SJ_G_MODULES)  cores: $(SJ_G_CORE) BUILD_PROFILE=$(SJ_G_BUILD_PROFILE)  "
	$(MAKE) -C $(SJ_PATH_PSDKRA)/gateway-demos can_eth_gateway_app        BOARD=$(SJ_G_BOARD)                   BUILD_PROFILE=$(SJ_G_BUILD_PROFILE)	-j$(CPU_NUM)
	$(MAKE) -C $(SJ_PATH_PSDKRA)/gateway-demos can_traffic_generator_app  BOARD=$(SJ_G_BOARD) CORE=$(SJ_G_CORE) BUILD_PROFILE=$(SJ_G_BUILD_PROFILE) -j$(CPU_NUM)
	$(Q)echo "build board : $(SJ_G_BOARD)  modules: $(SJ_G_MODULES)  cores: $(SJ_G_CORE) BUILD_PROFILE=$(SJ_G_BUILD_PROFILE) done!"
	$(Q)$(call sj_echo_log, info , "1. gateway-build ..... done!"); 
	
gateway_install_pc_tools: check_paths_PSDKRA
	$(Q)$(call sj_echo_log, info , "1. gateway-install-pc-tools ....."); 
	$(Q)echo "board : $(SJ_G_BOARD)  modules: $(SJ_G_MODULES)  cores: $(SJ_G_CORE) BUILD_PROFILE=$(SJ_G_BUILD_PROFILE)  "
	$(MAKE) -C $(SJ_PATH_PSDKRA)/gateway-demos/pctools    all 	 -j$(CPU_NUM)
	$(Q)$(CPR)  $(SJ_PATH_PSDKRA)/gateway-demos/pctools  $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3/test
	$(Q)echo "build board : $(SJ_G_BOARD)  modules: $(SJ_G_MODULES)  cores: $(SJ_G_CORE) BUILD_PROFILE=$(SJ_G_BUILD_PROFILE) done!"
	$(Q)$(call sj_echo_log, info , "1. gateway-install-pc-tools ..... done!"); 

# run CAN2ETH Demo : CAN ID is 208
gateway_can2eth:
	$(Q)$(call sj_echo_log, info , "1. gateway-can2eth ....."); 
	cd $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3/test/pctools ; \
	sudo ./recv_1722.out --eth_interface $(SJ_G_ETH0) --timeout 12 --pipes 0 --verbosity verbose &
	cd $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3/test; \
	./pcanfdtst tx ETH_ONLY --bitrate 1000000 --dbitrate 5000000 --clock 80000000 -n 100 -ie 0xD0 --fd -l 64 --tx-pause-us 1 /dev/pcanusbfd32
	$(Q)$(call sj_echo_log, info , "1. gateway-can2eth ..... done!"); 

gateway_sent_can_frame:
	$(Q)$(call sj_echo_log, info , "1. gateway-sent-can-frame ....."); 
	cd $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3/test; \
	./pcanfdtst tx ETH_ONLY --bitrate 1000000 --dbitrate 5000000 --clock 80000000 -n 1000 -ie 0xD0 --fd -l 64 --tx-pause-us 1000 /dev/pcanusbfd32
	cd $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3/test; \
	./pcanfdtst tx ETH_ONLY --bitrate 1000000 --dbitrate 5000000 --clock 80000000 -n 1000 -ie 0xE0 --fd -l 64 --tx-pause-us 1000 /dev/pcanusbfd32
	$(Q)$(call sj_echo_log, info , "1. gateway-sent-can-frame .....done!"); 

gateway_receive_can_frame_over_ethernet:
	$(Q)$(call sj_echo_log, info , "1. gateway-receive-can-frame-over-ethernet ....."); 
	cd $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3/test/pctools ; \
	sudo ./recv_1722.out --eth_interface $(SJ_G_ETH0) --timeout 12 --pipes 0 --verbosity verbose
	# cd $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3/test/pctools; \
	# sudo ./recv_1722.out --eth_interface $(SJ_G_ETH1) --timeout 12 --pipes 0 --verbosity verbose
	$(Q)$(call sj_echo_log, info , "1. gateway-receive-can-frame-over-ethernet ..... done!"); 
# ETH2ETH Demo CANID is 240
gateway_eth2eth: 
	$(Q)$(call sj_echo_log, info , "1. gateway eth2eth ....."); 
	cd $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3/test/; \
	sudo ./pctools/recv_1722.out --eth_interface $(SJ_G_ETH1) --timeout 12 --pipes 0 --verbosity verbose &
	cd $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3/test/; \
	sudo ./pctools/send_1722.out --eth_interface $(SJ_G_ETH0)       --gateway_mac $(SJ_G_GATEWAY_MAC) --dst_mac $(SJ_G_ETH1_MAC) --ipg 1000 --route ETH --num_packets 10 
	$(Q)$(call sj_echo_log, info , "1. gateway eth2eth ..... done!"); 

gateway_eth2eth_sent: 
	$(Q)$(call sj_echo_log, info , "1. gateway eth2eth sent ....."); 
	cd $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3/test/; \
	sudo ./pctools/recv_1722.out --eth_interface $(SJ_G_ETH1) --timeout 12 --pipes 0 --verbosity verbose &
	cd $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3/test/; \
	sudo ./pctools/send_1722.out --eth_interface $(SJ_G_ETH0)       --gateway_mac $(SJ_G_GATEWAY_MAC) --dst_mac $(SJ_G_ETH1_MAC) --ipg 1000 --route ETH --num_packets 10 
	# cd $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3/test/; \
	# sudo ./pctools/recv_1722.out --eth_interface $(SJ_G_ETH1) --timeout 12 --pipes 0 --verbosity verbose
	# cd $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3/test/; \
	# sudo ./pctools/send_1722.out --eth_interface $(SJ_G_ETH1) --gateway_mac $(SJ_G_GATEWAY_MAC) --dst_mac $(SJ_G_ETH0_MAC) --ipg 1000 --route ETH --num_packets 10 
	# cd $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3/test/; \
	# sudo ./pctools/recv_1722.out --eth_interface $(SJ_G_ETH0) --timeout 12 --pipes 0 --verbosity verbose
	$(Q)$(call sj_echo_log, info , "1. gateway eth2eth sent ..... done!"); 

gateway_eth2eth_receive: 
	$(Q)$(call sj_echo_log, info , "1. gateway eth2eth receive ....."); 
	cd $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3/test/; \
	sudo ./pctools/recv_1722.out --eth_interface $(SJ_G_ETH1) --timeout 12 --pipes 0 --verbosity verbose
	$(Q)$(call sj_echo_log, info , "1. gateway eth2eth receive ..... done!"); 
# Set Hash Table
# lookup table inside the gateway application with 256 entries. 
#	Each entry has two masks: The masks tell which ports are open for Transmit. 
#		one for Ethernet 
#       one for CAN.
# eth2eth CANID is 0xf0 
# can2eth CANID is 0xd0
gateway_set_hash_table: 
	$(Q)$(call sj_echo_log, info , "1. gateway demo set hash table ....."); 
	cd $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3/test/; \
	sudo ./pctools/send_1722.out --eth_interface $(SJ_G_ETH0)  --can_id  0xf0  --update_hash_table 1 --can_mask 0x0 --eth_mask 0xf 
	cd $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3/test/; \
	sudo ./pctools/send_1722.out --eth_interface $(SJ_G_ETH1)  --can_id  0xD0  --update_hash_table 1 --can_mask 0x0 --eth_mask 0xf
	$(Q)$(call sj_echo_log, info , "1. gateway demo set hash table .....done!"); 
# run out of box demo
gateway_run_oob:
	$(Q)$(call sj_echo_log, info , "1. gateway demo run oob ....."); 
	cd $(SJ_PATH_JACINTO)/tools/peak-linux-driver-8.9.3/test/; \
	python3 pctools/run_demo.py --iterations 1 --run_time 30 --system_test 0 --gui_enabled 0 --oob_mode 1
	$(Q)$(call sj_echo_log, info , "1. gateway demo run oob ..... done!"); 

gateway_clean:
	$(Q)$(call sj_echo_log, info , "1. gateway demo clean ....."); 
	$(MAKE) -C $(SJ_PATH_PSDKRA)/gateway-demos allclean
	$(Q)$(call sj_echo_log, info , "1. gateway demo clean ..... done!"); 

gateway_help:
	$(Q)$(call sj_echo_log, info , "# gateway_help....."); 
	$(Q)$(call sj_echo_log, info , "# Available build targets are:"); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	# $(MAKE) -C $(SJ_PATH_PSDKRA)/gateway-demos help
	$(Q)$(call sj_echo_log, help , "gateway-clean", " "); 
	$(Q)$(call sj_echo_log, help , "gateway-build", " "); 
	$(Q)$(call sj_echo_log, help , "gateway-can2eth", " "); 
	$(Q)$(call sj_echo_log, help , "gateway-eth2eth", " "); 
	$(Q)$(call sj_echo_log, info , "# gateway-help..... done!"); 
	$(Q)$(call sj_echo_log, help , "#########################################################"); 
	$(Q)$(call sj_echo_log, info , "# gateway_help..... done!"); 

