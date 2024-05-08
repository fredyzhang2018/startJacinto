#############################################################################################
# This script is using for ubuntu Command Reference, Please don't run command on  Ubuntu.         #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-03-23                                                                      # 
# @update : fredy  V1@ 2022-03-23                                                                       # 
##############################################################################################
exit 1
####################################################################################################
# --- ubuntu basic                                                                                     #
#################################################################################################### 
sudo lsb_release -a # check the ubuntu version


####################################################################################################
# --- Openssl                                                                                      #
#################################################################################################### 
# # 1) Generate RSA key:
openssl genrsa -out key.pem 1024 
openssl rsa -in key.pem -text -noout 
# # 2) Save public key in pub.pem file:
openssl rsa -in key.pem -pubout -out pub.pem 
openssl rsa -in pub.pem -pubin -text -noout 
# # 3) Encrypt some data:
echo test test test > file.txt 
openssl rsautl -encrypt -inkey pub.pem -pubin -in file.txt -out file.bin 
# # 4) Decrypt encrypted data:
$ openssl rsautl -decrypt -inkey key.pem -in file.bin 

# shell function
echo "${FUNCNAME[0]}" # function name. 

####################################################################################################
# --- Openssl  SSH agent:                                                                                     #
#################################################################################################### 
ssh-agent -s
ssh-agent bash
ssh-add ~/.ssh/id_rsa
####################################################################################################
# --- Git submodule:         https://git-scm.com/docs/git-submodule/                                                                            #
#################################################################################################### 
git submodule add https://git.oschina.net/gaofeifps/leg.git # add remote url 
git submodule init && git submodule update

git clone https://git.oschina.net/gaofeifps/body.git
git submodule init && git submodule update
#equel to 
git clone https://git.oschina.net/gaofeifps/body.git --recursive

git submodule foreach git checkout master


This file is show how to use these basic command. proxyconfig please check here {#PROXY_SETUP}

####################################################################################################
# ---  ctrl +z ctrl +c                                                                             #
#################################################################################################### 
ctrl+z fg # can restore 
ctrl+c    # can't restore

####################################################################################################
# ---  readelf/objdump/objcopy                                                                     #
#################################################################################################### 
readelf -s 
objdump -p  /bin/ls | grep NEEDED # objdump :find needed lib dependency
####################################################################################################
# ---  network                                                                                     #
#################################################################################################### 
ufw allow 8000
ufw delete allow 8000 
check port: netstat -lpn | grep 80
check the port: ‘lsof -i:80’
check IP: ip a
check the local IP: hostname -I

sudo ufw enable : enable the firewall
sudo ufw stauts:   check the ufw status
sudo ufw allow port
sudo ufw reload
sudo ufw disable
sudo ufw default deny
sudo ufw delete allow port
#查看防火墙规则 sudo iptables -L
#开放SSH端口22
iptables -A INPUT -p tcp -i eth0 --dport ssh -j ACCEPT
#开放Web端口80
iptables -A INPUT -p tcp -i eth0 --dport 80 -j ACCEPT
#开放FTP端口21、20
iptables -A INPUT -p tcp --dport 20 -j ACCEPT
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
#删除FTP端口21、20
iptables -D INPUT -p tcp --dport 20 -j ACCEPT
iptables -D INPUT -p tcp --dport 21 -j ACCEPT
#允许loopback(不然会导致DNS无法正常关闭等问题)
IPTABLES -A INPUT -i lo -p all -j ACCEPT (如果是INPUT DROP)
IPTABLES -A OUTPUT -o lo -p all -j ACCEPT (如果是OUTPUT DROP)
#保存iptables规则
iptables-save > /etc/iptables.up.rules
#iptables规则自动保存与自动加载，修改 /etc/network/interfaces ，添加下面末尾2行脚本
iptables-apply //enable the rules.
nano /etc/network/interfaces
auto eth0
iface eth0 inet dhcp
pre-up iptables-restore < /etc/network/iptables.up.rules
post-down iptables-save > /etc/network/iptables.up.rules
####################################################################################################
# ---  DTB                                                                                     #
#################################################################################################### 
# DTB –> DTS
dtc -I dtb -O dts -o whole.dts arch/arm/boot/dts/dra72-evm-infoadas.dtb
ls -l whole.dts
# device tree DTB DTC convert
# ——————-DTB –» DTS
./dtc -I dtb -O dts \*.dtb -o \*.dts
# ———————DTS -» DTB
./dtc -I dts -O dtb -o test.dtb test.dts

####################################################################################################
# ---  pwd                                                                                     #
#################################################################################################### 
	pwd : current document folder
	pwd -P : phy path
	pwd -L : link path
####################################################################################################
# ---  mkdir                                                                                     #
#################################################################################################### 
	mkdir -m : set the permission mode
	mkdir -p : can creat multi path
	mkdir -v : display message when create new folder
####################################################################################################
# ---  rm                                                                                     #
#################################################################################################### 
	rm -f --force
	rm -i --interactive
	rm -r --recursive
	rm -v --verbose 
####################################################################################################
# ---  mv                                                                                     #
#################################################################################################### 
    mv -b --back          example:
	mv -f --force		  example:
	mv -i --interactive
	mv -u --update
	mv -t --target
####################################################################################################
# ---  cp                                                                                     #
#################################################################################################### 
	cp -t --target 
	cp -i --interactive
	cp -n --no-clobber
	cp -s --symbolic-link
	cp -f --force
	cp -u --update
####################################################################################################
# ---  cat                                                                                     #
#################################################################################################### 
	cat -A --show all
	cat -b --number-nonblack
	cat -e 
	cat -E --show-ends
	cat -n --number
	cat -s --squeeze-black
	cat -t 
	cat -T --show tabs
	cat -u 
	cat -v
####################################################################################################
# ---  nl                                                                                     #
#################################################################################################### 
	nl -n
	nl -b
####################################################################################################
# ---  which whereis locate                                                                                   #
#################################################################################################### 
	which
	whereis
	locate
####################################################################################################
# ---  find                                                                                     #
#################################################################################################### 
	find -print
	find -name 
	find -type
	find -user
	find -group
	find . -name "*.php" -exec ls -l {} \;          : find relative file and display the message
	find  .  -name "*.txt" -print	
	find  .  \( -name "*.pdf" -or -name "*.txt" \) 
	find  .  ! -name "*.txt"
	find  .  -type l -name "*.txt" -print
	find  .  -type f -name "*.php" -perm 777
	find  .  -type f -user root
	find  .  -type f  \( ! -perm 777  -and  ! -perm 644 \)
	find . -name "*.c" -exec ./command.sh {} \;
####################################################################################################
# ---  xargs                                                                                     #
#################################################################################################### 
# xargs command | xargs [选项] [command]
	find . -type f -name "*.c" | xargs wc -l
	cat b.txt | xargs -d i -n 3
	echo "1 2 3 4 5 6 7" | xargs -n 3
####################################################################################################
# ---  wc                                                                                     #
#################################################################################################### 
	wc -c :wc -c c.txt
	wc -l
	wc -m
	wc -w
	wc -L
####################################################################################################
# ---  grep                                                                                     #
#################################################################################################### 
# grep grep [选项] pattern [file]
	grep -c : serch the numble of string
	grep -i : ignore the big and little
	grep -n : output the line number
	grep -v :
	grep -r :
	grep --color=auto
	grep "root" /etc/passwd --color=auto
	cat /etc/passwd | grep "root" --color=auto
	grep -v "root" /etc/passwd | grep -v "nologin"
	grep -r "main()". 
	grep '^..j.r$' linux.words
	grep "^0[0-9]{2,3}-[0-9]{7,8}(-[0-9]{3,4})?$" telphone.txt
	alias grep='grep --color=auto'¡»
####################################################################################################
# ---  	zcat /proc/config.gz | grep LPAE                                                                                          #
#################################################################################################### 
	zcat /proc/config.gz | grep LPAE
####################################################################################################
# ---  cut                                                                                          #
#################################################################################################### 
	cut -f 1,3 -d ' ' student.txt
####################################################################################################
# ---  paste                                                                                          #
#################################################################################################### 
	paste student.txt telphone.txt
####################################################################################################
# ---  tr                                                                                          #
#################################################################################################### 
	echo 'THIS IS SHIYANLOU!' | tr 'A-Z' 'a-z'
	echo 'THIS 123 IS S1HIY5ANLOU!' | tr -d '0-9' 
####################################################################################################
# ---  cp                                                                                          #
#################################################################################################### 
5.2.22. comon
	comm [选项] 文件 1 文件 2
####################################################################################################
# ---  diff patch                                                                                          #
#################################################################################################### 
	diff -a 
	diff -c
	diff -u 
	diff -N
	diff -r

	diff -Naur old_file new_file > diff_file

	patch -pN < patch_file <== update
	patch -R -pN < patch_file <== recover 
####################################################################################################
# ---  df du                                                                                          #
#################################################################################################### 
	df -a
	df -h
####################################################################################################
# ---  strace                                                                                          #
#################################################################################################### 
5.2.26. strace
strace -f -o /tmp/log ./configure

5.2.27. pr
	a02190a0
####################################################################################################
# ---  SCP & RSYNC                                                                   #
#################################################################################################### 
# rsync的目的是实现本地主机和远程主机上的文件同步(包括本地推到远程，远程拉到本地两种同步方式)，也可以实现本地不同路径下文件的同步，但不能实现远程路径1到远程路径2之间的同步(scp可以实现)。
scp mavin@10.85.130.87:/home/mavin/Desktop/Joe_cluster/Cluster_image.img /home/fredy/Desktop/1031/
scp breakpoing continue:
scp -r
scp mavin@10.85.130.87:/home/mavin/Desktop/Joe_cluster/Cluster_image.img /home/fredy/Desktop/1031/
scp breakpoint continue
rsync -P --rsh=ssh home.tar 192.168.1.1:/home/home.tar
alias scpr="rsync -P --rsh=ssh"
	
rsync -avz documents fredy@192.168.*.*:/home/fredy/work/ -----------------not work 
rsync -avz documents/ fredy@192.168.*.*:/home/fredy/work/pc -----------------works well. 
-v ：观察模式，可以列出更多的资讯；
-q ：与 -v  相反，安静模式，输出的资讯比较少；
-r ：递回复制！可以针对”目录”来处理！很重要！
-u ：仅更新 (update)，不会覆盖目标的新档案；
-l ：复制连结档的属性，而非连结的目标原始档案内容；
-p ：复制时，连同属性 (permission) 也保存不变！
-g ：保存原始档案的拥有群组；
-o ：保存原始档案的拥有人；
-D ：保存原始档案的装置属性 (device)
-t ：保存原始档案的时间参数；
-I ：忽略更新时间 (mtime) 的属性，档案比对上会比较快速；
-z ：加上压缩的参数！
-e ：使用的通道协定，例如使用 ssh 通道，则 -e ssh
-a ：相当于 -rlptgoD ，所以这个 -a 是最常用的参数了！

verified below command:
	rsync -r temp temp1/
	rsync -r temp fredy@10.85.130.60:/home/fredy/work/test/temp1/
	rsync temp/  --- list the files
	rsync -arvzP --rsh=ssh temp fredy@10.85.130.60:/home/fredy/work/test/temp1/
	rsync -avP  MyDocuments/ fredy@10.85.130.60:/home/fredy/work/pc
####################################################################################################
# ---  nohup                                                                                       #
#################################################################################################### 
- nohop command : use in console can run thread in back console.
####################################################################################################
# --- mount local disk                                                                             #
#################################################################################################### 
$ sudo mount /dev/sdb /home/mavin/bspwp/
sudo mount -t nfs -o nolock,nfsvers=3,vers=3 10.85.130.87:/home/mavin/bspwp /home/fredy/bspwp
####################################################################################################
# --- proxy Setting                                                                                #
#################################################################################################### 

wwwgate.ti.com  80
127.0.0.1  1080
####################################################################################################
# --- gdb                                                                                #
#################################################################################################### 
	compile + -g  
	#below code please run on gdb environment
	list      -> l 
	list main 
	list 10
	break      -> b
	info breakpoints
	run  -> r
	   
	display i  -> disp i
	info -> i
	step -> s
	next -> n
	print ->  p
	continue -> c
	set var name = v
	start -> st : stop at front of main
	file : load the debug file
	kill -> k : terminate the run app
	watch : see the var
	backtrace -> bt: watch the function info
	frame -> f : watch the frame stack
	quit  -> q
####################################################################################################
# --- git archive                                                                              #
#################################################################################################### 
	git archive --format=zip HEAD `git diff --name-only 31967c5   ad06de9` > a.zip
####################################################################################################
# --- fastboot                                                                              #
#################################################################################################### 
	fastboot oem spi
	fastboot flash xloader <MLO File>
	fastboot flash bootloader <u-boot.img file>
####################################################################################################
# --- sed                                                                              #
#################################################################################################### 
	sed -i s/"str1"/"str2"/g `grep "str1" -rl --include="*.[ch]" ./` replace the .c and .h file.

	sed -i s/"a0220410"/"fredy"/g `grep "a0220410" -rl --include="*.sh" ./`

	grep "a0220410" -r ./

	sed -i s/"str1"/"str2"/g `grep "str1" -rl --include="*.[ch]" ./`

	find ./ -type f  -name "*.c" | xargs  grep "vidSensorPrm"
	find ./ -type f  -name "vsdk_linux.out" | xargs  grep "vsdk_win32.exe"
####################################################################################################
# --- dmesg                                                                              #
#################################################################################################### 
prints and control the log buffer
dmesg # print log buffer
dmesg -C # clean the log buffer
dmesg -c # print then clear the log buffer
kernel log buffer size: Default size is 64KB • Adjust the size – Method
• Default size is 64KB
• Adjust the size
– Method #1: Kernel Config Option - CONFIG_LOG_BUF_SHIFT=n
• menuconfig: “General Setup”
– Method #2: uboot bootargs: log_buf_len=n
– Buffer Size = 2n
    • n=16: 64KB
    • n=17: 128KB
Adding log messages from user space
• Interface:
	/dev/kmsg
• Usage:
	echo “some comments” > /dev/kmsg
• Example:
	echo “### TESTNOTE: unplugged thumb drive” > /dev/kmsg
	echo “### TESTNOTE: waited for a couple seconds” > /dev/kmsg
	echo “### TESTNOTE: re-plugged thumb drive” > /dev/kmsg



####################################################################################################
# --- ffmpeg                                                                              #
#################################################################################################### 
## ffmpeg
video download from here: http://jell.yfish.us/
// convert video to h264
ffmpeg -i jellyfish-20-mbps-hd-h264.mkv -an -vcodec libx264 -bf 0 -vstats_file h264.stat 1920x1080_00.h264
ffmpeg -pix_fmts : List available formats for ffmpeg
ffmpeg -i xxx.h264 display videomessage
# Convert raw rgb565 image to png
ffmpeg -vcodec rawvideo -f rawvideo -pix_fmt rgb565 -s 1024x768 -i freescale_1024x768.raw -f image2 -vcodec png screen.png
# Convert png to raw rgb565
ffmpeg -vcodec png -i image.png -vcodec rawvideo -f rawvideo -pix_fmt rgb565 image.raw
ffmpeg -vcodec png -i blue.png -vcodec rawvideo -f rawvideo -pix_fmt argb image.raw
#Convert a 720x480 NV12 (YUV 420 semi-planar) image to png
ffmpeg -s 720x480 -pix_fmt nv12 -i image-nv12.yuv -f image2 -pix_fmt rgb24 image-png.png
#Convert a 640x480 uyvy422 image to png
ffmpeg -s 640x480 -pix_fmt uyvy422 -i image-uyvy422.yuv -f image2 -pix_fmt rgb24 image-uyvy422.png
ffmpeg -s 720x480 -pix_fmt nv12 -i captdump-nv12.yuv -f image2 -pix_fmt rgb24 captdump.png

#convert mp3 audio to wav audio
ffmpeg -i test.mp3 -acodec pcm_u8 -ar 22050 test.wav
ffmpeg -i test.mp3 test.wav 

# convert image to YUV
ffmpeg -i tmp.bmp -pix_fmt yuv420p 0001.yuv

# convert image to rgb888
ffmpeg -vcodec bmp -i 4.bmp -vcodec rawvideo -f rawvideo -pix_fmt rgb24 0001.raw
# convert jpg image to bmp
ffmpeg  -i ./img_2368_352.jpg -f image2 -pix_fmt rgb24 rgb888 image.bmp
# convert mp4 to yuv420p
ffmpeg -i input.mp4 output.yuv
ffmpeg -i input.avi -r 30 output.mp4
ffmpeg -i file.avi -b 1.5M file.mp4
ffmpeg -i 1.mp4 -strict -2 -s 640x480 4.mp4
ffplay -f rawvideo -video_size 640x360 test_input_640x360_bak.yuv
ffplay -v info -f rawvideo -pixel_format nv12 -video_size 720x480  data/yuvframes.yuv
ffmpeg -i  ./test/video.mpg -r 10 -f image2 temp/%05d.png
ffmpeg -i  ./test/video.mpg  -s 480*240 -r 10 -f image2 %d.bmp
cat 1.bin 2.bin 3.bin 4.bin 5.bin 6.bin 7.bin 8.bin 9.bin 10.bin 11.bin 12.bin 13.bin 14.bin 15.bin 16.bin 17.bin 18.bin 19.bin 20.bin 21.bin 22.bin 23.bin 24.bin 25.bin 26.bin 27.bin 28.bin 29.bin 30.bin 31.bin 32.bin 33.bin 34.bin 35.bin 36.bin 37.bin 38.bin > video.bin

# extract the wav from video
ffmpeg -i ×.rmvb -f wav -ar 16000 2-20.wav
# convert items to Video
ffmpeg -threads 2 -f image2 -i ./%04d.bmp  -vcodec h264 -r 30 -t 10 -b 16000000 output.mp4
####################################################################################################
# --- fdisk gparted                                                                              #
####################################################################################################
# New harddisk 
sudo fdisk check the harddisk status sudo fdisk -l
# for New harddisk for New partition sudo sudo fdisk /dev/sdb (sdb is found by 1)
# - input m 
#   	- input p 
#   	- input w
format the harddisk sudo mkfs -t ext4 /dev/sdb1
# 2. mount the harddisk
mkdir ~/data sudo mount /dev/sdb1 ~/data df // check the mount successed
# 3. boot auto mount: config  /etc/fstab 
ls -l /dev/disk/by-uuid ls -l /dev/disk/by-uuid | grep sdb lrwxrwxrwx 1 root root 10 Apr 17 11:40 ea195de6-725c-4701-98c3-1fa6a44bc102 -> ../../sdb1 // backup old sudo cp /etc/fstab /etc/fstab.bak
# 5.3. /home/speculatecat/data
UUID=ea195de6-725c-4701-98c3-1fa6a44bc102 /home/speculatecat/data ext4 defaults 1 2 这里配置的含义如下：
UUID 为硬盘分区的 UUID 值
路径 为挂载的目标路径
分区格式 这里一般为 ext4
挂载参数 一般为默认 defaults
备份 0为不备份， 1为每天备份，2为不定期备份
检测 0为不检测，其他为优先级
# 4. boot error recover
cp /etc/fstab.bak /etc/fstab
####################################################################################################
# --- account setting                                                                             #
####################################################################################################
## account setting
### useradd
- -d 
### adduser
### passwd
# 1. 新建用户
#  一般两种方法
#  一种是adduser，这个会自动创建主目录系统shell版本，提示设置密码，创建同名group。使用：adduser username，可以用--home指定主目录，当然还有其他选项。
#  一种是useradd，如果不指定就是根目录作为主目录，啥都没有。所以一定要用-d指定主目录，用-m表示主目录不存在就创建，但是存在是不创建并且不能作为新创建用户主目录的，所以一般-d加了主目录之后加-m选项，-s指定shell版本，-M不创建主目录。
# 2. 增加sudo（root）权限
#  一般三种方法
#  一种是sudo usermod -aG sudo username
#  一种是修改/etc/sudoers文件，在root ALL=(ALL) ALL下面复制一行同样的只不过root改成你的用户名
#  一种是修改/etc/passwd 找到自己的用户一行吧里面的用户id改成0
# 3. 其他
#  修改密码都用passwd username
#  删除用户userdel username 加-r连主目录一起删除
#  删除组groupdel groupname
#  /etc/passwd 里面有用户和组等信息
#  /etc/shadow里面是账号信息加密
#  /etc/group 组信息
#  /etc/default/useradd 定义信息
#  /etc/login.defs 一些设定
#  /etc/skel 定义档目录？
####################################################################################################
# --- J6 board                                                                          #
####################################################################################################
## J6 board 
### A15 MPU DDR loading test: 
mpuload /tmp/socfifo 1000 &
pvrscope 1 0 &
pvrscope <option> <time_seconds>
pvrtune 
omapconf trace bw --tr r+w -p emif1 --m0 mpu --m1  gpu_p1 --m2 gpu_p2  --m3 dss --m4 iva_icont1
### vsdk DDR test
	1. run linux:omapconf read 0x45001008
	2. check the value is 1;
	3. run app.out 
	4. p
### test tempreture 
omapconf show opp
## boot mode 
omapconf read 0x4A0026C4
## cpu frequency test
	/sys/devices/system/cpu/cpu0/cpufreq# cat \*
	# test the current mpu frequency
	 mhz
	# test dual core MPU loading
	 mpstat 1
## gsteamer 
gst-launch-1.0 -v playbin uri=file:///home/root/Guns.wmv video-sink="waylandsink use-drm=true"
gst-launch-1.0 playbin uri=file://<path-to-file-name> video-sink=waylandsink
/run/media/mmcblk0p2/usr/share/ti/video/HistoryOfTIAV-480p.mp4
gst-launch-1.0 playbin uri=file:///run/media/mmcblk0p2/usr/share/ti/video/HistoryOfTIAV-480p.mp4 video-sink=waylandsink
v4l2-ctl -d /dev/video11 -i 0 --set-fmt-video=pixelformat=NV12 --stream-to=/test/video_test_file.yuv --stream-mmap=6 --stream-count=10 --stream-poll
aplay /usr/share/sounds/alsa/Rear_Right.wav
gst-launch-1.0 playbin uri=file:///<path_to_file> video-sink=kmssink audio-sink=alsasink
viddec3test -s 32:1920x1080 HistoryOfTI-WVGA.264 --fps 30
viddec3test -s 32:1920x1080 HistoryOfTI-WVGA.264 --fps 30
viddec3test -s 24:1280x720 /usr/share/ti/video/HistoryOfTI-WVGA.264 --fps 30
viddec3test -s 36:1280x720 /usr/share/ti/video/HistoryOfTI-WVGA.264 --fps 30
viddec3test -s 32:1280x800 /usr/share/ti/video/HistoryOfTI-WVGA.264 --fps 30
viddec3test -s 32:1280x800 /usr/share/ti/video/TearOfSteel-Short-1280x720.265 --fps 30
viddec3test -s 32:1280x800 /usr/share/ti/video/TearOfSteel-Short-1280x720.265 --fps 30
viddec3test -s 32:1920x1080 /usr/share/ti/video/video_1920x1080.264 --fps 30
./viddec3test_k --kmscube --connector 32 /usr/share/ti/video/HistoryOfTI-WVGA.264
./viddec3test_k -w 1920x1080 --fps 30 /usr/share/ti/video/HistoryOfTI-WVGA.264
./viddec3test_1 -s 36:1920x1080 /usr/share/ti/video/video_1920x1080.264 --fps 30
./gl_kmscube -s 36:1920x1080 /usr/share/ti/video/video_1920x1080.264 --fps 30
./gl_kmscube_card1 -s 24:1920x1080 /usr/share/ti/video/video_1920x1080.264 --fps 30
./gl_kmscube_card0 -s 24:1920x1080 /usr/share/ti/video/video_1920x1080.264 --fps 30
./viddec3test_k --kmscube --connector 24 /usr/share/ti/video/HistoryOfTI-WVGA.264
./gl_kmscube -s 32:1920x1080 /usr/share/ti/video/HistoryOfTI-WVGA.264 --fps 30
./gl_kmscube -s 32:1920x1080 /usr/share/ti/video/HistoryOfTI-WVGA.264 --fps 30
./gl_kmscube -s 24:1920x1080 /usr/share/ti/video/HistoryOfTI-WVGA.264 --fps 30
./gl_kmscube_card0 -s 24:1920x1080 /usr/share/ti/video/video_1920x1080.264 --fps 30
./gl_kmscube_card1 -s 24:1920x1080 /usr/share/ti/video/video_1920x1080.264 --fps 30

viddec3test -s 24:1920x1080 /usr/share/ti/video/video_1920x1080.264 --fps 30
./gl_kmscube -w 1920x1080 --fps 30 /usr/share/ti/video/HistoryOfTI-WVGA.264
./gl_kmscube  -w 640x480 --fps 24 /usr/share/ti/video/TearOfSteel-Short-720x420.264
-----------------weston
viddec3test -w 640x480 --fps 24 /usr/share/ti/video/TearOfSteel-Short-720x420.264
viddec3test -w 1920x720 --fps 24 /usr/share/ti/video/TearOfSteel-Short-720x420.264 &
Audio testing
gst-play-1.0 music_file

## vision SDK DDR test process as below: 
omapconf trace bw --tr r+w -p emif1 --m0 mpu --m1  gpu_p1 --m2 gpu_p2  --m3 dss --m4 iva_icont1 &
cd /opt/vision_sdk/
./vision_sdk_load.sh
cd /home/root/app_instrument/
./app_card0 &
./app_6L30_card0_no &
/etc/init.d/weston stop
/etc/init.d/weston restart
viddec3test -w 1920x720 --fps 24 /usr/share/ti/video/TearOfSteel-Short-720x420.264 &
cd /opt/vision_sdk/
./apps.out
1
9
/etc/init.d/weston stop
/etc/init.d/weston start
viddec3test -w 1920x720 --fps 24 /usr/share/ti/video/TearOfSteel-Short-720x420.264 &
viddec3test /usr/share/ti/video/TearOfSteel-Short-720x420.264 --kmscube -d /dev/dri/card1 --connector 24 &
./gl_kmscube -s 32:1280x720 /usr/share/ti/video/HistoryOfTI-WVGA.264 --fps 30
## psdk env
export INSTALL_DIR=”${HOME}/ti-processor-sdk-linux-automotive_dra7xx-evm_03_02_00_03” sudo dpkg-reconfigure dash export PATH=${INSTALL_DIR}/bin:$PATH cd mavin 10.85.130.87 lhlzh2001 export PATH=${INSTALL_DIR}/bin:$PATH cd ${INSTALL_DIR} export INSTALL_DIR=”${HOME}/bspwp/PSDK-03-04” cd $INSTALL_DIR

//————-remote machine———————– [fredy]10.85.130.155 VNC A12345 2 [fredy 5289] 10.85.130.241 VNC A12345 2 ssh A12345

## PSDK
sudo apt-get install git build-essential python diffstat texinfo gawk chrpath dos2unix wget unzip socat doxygen libc6:i386 libncurses5:i386 libstdc++6:i386 libz1:i386
sudo dpkg-reconfigure dash
export INSTALL_DIR="${HOME}/ti-processor-sdk-linux-automotive-dra7xx-evm-03_04_00_03"
cd $INSTALL_DIR
export PATH=${HOME}/gcc-linaro-5.3-2016.02-x86_64_arm-linux-gnueabihf/bin:$PATH

export INSTALL_DIR="${HOME}/ti-processor-sdk-linux-automotive-dra7xx-evm-03_04_00_03"
cd $INSTALL_DIR
export PATH=${HOME}/gcc-linaro-5.3-2016.02-x86_64_arm-linux-gnueabihf/bin:$PATH
## Kernel
export CROSS_COMPILE=/home/fredy/gcc-linaro-5.3-2016.02-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
export ARCH=arm
make omap2plus_defconfig 
make uImage dtbs
## make SD
sudo ${INSTALL_DIR}/bin/mksdboot.sh --device /dev/sdY --sdk ${INSTALL_DIR}
omapconf trace bw --tr r+w -p emif1 --m0 mpu --m1  gpu_p1 --m2 gpu_p2  --m3 dss --m4 iva_icont1
## EVM uenv.txt
fdtfile=dra7-evm-lcd-osd.dtb
args_mmc=part uuid mmc 0:2 uuid; setenv bootargs "console=ttyO0,115200n8 elevator=noop root=PARTUUID=${uuid} rw rootwait earlyprintk fixrtc omapdrm.num_crtc=2 consoleblank=0 cma=128M@0xB0000000 rootfstype=ext4 snd.slots_reserved=1,1"
## temp 

	\code 
	1. how to config the cpu frequency
		modify the arm frequency: uenv.txt and kernel dra7.dtsi.
	#----Flyaudio-----------------
	cat /dev/ttyUSB2 &
	echo -e "ATI\r\n" > /dev/ttyUSB2
	
	AT+QCFG="usbnet",0 //ril mode 
	AT+QCFG="usbnet",1 //ecm
	AT+QCFG="usbnet",3 //rndis
	For example: echo -e 'AT+QCFG="usbnet",3' > /dev/ttyUSB2 //change to rndis 
	
	ttyUSB0 -> DIAG
	ttyUSB1 -> ADB
	ttyUSB2 -> AT
	ttyUSB3 -> Modem
	
	echo -e "AT+CREG?" > /dev/ttyUSB2
	
	==================== VSDK0305  =========================================================================
	make -s showconfig
	make -s clean
	make -s sbl
	make -s appimage
	/home/fredy/PROCESSOR_SDK_VISION_03_05_00_00/vision_sdk/binaries/apps/tda3xx_evm_bios_all/sbl/qspi_sd/opp_nom/tda3xx-evm/sbl_qspi_sd_opp_nom_ipu1_0_release.tiimage
	
	DRA7xx:
	IPU2 log Address: 0xa02190a0
	IPU2 log Address: 0xa02190a0

	/*******************network*********************************/
	./network_ctrl.out --ipaddr 10.85.130.143 --cmd echo "helllo"
	./network_ctrl.out --ipaddr 10.85.130.108 --cmd echo "hello world"
	./network_rx.out --host_ip 10.85.130.125 --target_ip 10.85.130.108 --usetfdtp --files ./encode.m4v
	
	\codeend
