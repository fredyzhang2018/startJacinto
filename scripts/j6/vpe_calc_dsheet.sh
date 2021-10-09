
samples=1000
vpeclk=266000000

INP=(
"1920 540 yuyv"
"1280 720 yuyv"
"1920 1080 yuyv"
"320 240 yuyv"
"720 240 nv12"
"720 240 yuyv"
)

OUP=(
"1920 1080 yuyv 1"
"1920 1080 yuyv 0"
"1920 1080 rgb24 0"
"640 480 nv12 0"
"1280 720 yuyv 1"
"720 480 yuyv 1"
)

OPS=(
"DEI"
"SC"
"CSC"
"CSC + SC"
"DEI + SC"
"DEI + CSC"
)

UTL=(
"1920 * 1080"
"1920 * 1080"
"1920 * 1080"
"640 * 480"
"1280 * 720"
"720 * 480"
)
echo "" > wiki

echo
echo -e "VPE performance measurement utility"
echo -e "  - Using testvpe file2file app with /dev/null as i/p and o/p files."
echo -e "  - Using /dev/video0 as VPE device"
echo -e "  - Measuring processing times for $samples samples"
echo
printf "%25s %25s %15s %20s %15s %15s\n" "<input size>" "<output size>" "<operation>" "<processing time>" "<FPS>" "<HW util>"
echo

for i in `seq 0 5`
do
	inp=${INP["$i"]}
	oup=${OUP["$i"]}
	ops=${OPS["$i"]}
	utl=${UTL["$i"]}
	time=`time testvpe /dev/null $inp /dev/null $oup 1 $samples 2>&1 >/dev/null | grep real`
	time=`echo $time | awk -F" " '{ print $3 }' | cut -d 's' -f1`
	fps=`echo "scale=2; $samples / $time" | bc`
	hwutil=`echo "scale=2; $utl * $fps * 100 / $vpeclk" | bc`

	printf "%25s %25s %15s %20s %15s %15s\n" "$inp" "$oup" "$ops" "$time seconds" "$fps" "$hwutil%"

	echo "|- " >> wiki
	echo "| $ops $inp to $oup" >> wiki
	echo "| $time s" >> wiki
	echo "| $fps" >> wiki
	echo "| $hwutil%" >> wiki
done

echo
