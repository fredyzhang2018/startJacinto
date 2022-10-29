#! /bin/sh
# mk-card.sh

should_I_stay()
{
  DEFLT="N";
  echo "Do you want to continue (y/n)? [${DEFLT}]: $C"
        RDVAR=$DEFLT
        read RDVAR

  case $RDVAR in
                "") RDVAR=$DEFLT;;
  esac

  ANSWER=$RDVAR
  case $ANSWER in
           Y|y) ;;
           *)   echo "Script ended, no action performed."
           exit 0 ;;
  esac
}

usage ()
{
  echo "Usage: $0 <drive>"
  echo "E.g: $0 /dev/mmcblk0"
}

check_if_mounted ()
{
  mount | grep "^$DRIVE"
  [ "$?" = "0" ] && echo "++ ERROR: Umount any partition on $DRIVE ++" && exit 1
}

check_if_main_drive ()
{
  mount | grep " on / type " > /dev/null
  if [ "$?" != "0" ] 
  then
    echo "-- WARNING: not able to determine current filesystem device"
  else
    main_dev=`mount | grep " on / type " | awk '{print $1}'`
    echo "-- Main device is: $main_dev"
    echo $main_dev | grep "$DRIVE" > /dev/null
    [ "$?" = "0" ] && echo "++ ERROR: $DRIVE seems to be current main drive ++" && exit 1
  fi

}


export LC_ALL=C

# Check if the script was started as root or with sudo
user=`id -u`
[ "$user" != "0" ] && echo "++ Must be root/sudo ++" && exit

if [ $# -ne 1 ]; then
  echo "Need one parameter"
  usage
  exit 1;
fi

DRIVE=$1

[ ! -b $DRIVE ] && echo "++ ERROR: $DRIVE is not a block device" && usage && exit 1

check_if_main_drive
check_if_mounted

echo "The drive $DRIVE will be erased and re-formated"
should_I_stay

dd if=/dev/zero of=$DRIVE bs=1024 count=1024

sync

cat << END | fdisk $DRIVE
n
p
1

+128M
n
p
2


t
1
c
a
1
w
END

sync
# handle various device names.

PARTITION1=${DRIVE}1
if [ ! -b ${PARTITION1} ]; then
	PARTITION1=${DRIVE}p1
fi

PARTITION2=${DRIVE}2
if [ ! -b ${PARTITION2} ]; then
	PARTITION2=${DRIVE}p2
fi

# now make partitions.
if [ -b ${PARTITION1} ]; then
	mkfs.vfat -F 32 -n "BOOT" ${PARTITION1}
else
	echo "Cant find boot partition in /dev"
fi

if [ -b ${PARITION2} ]; then
	mkfs.ext4 -L "rootfs" ${PARTITION2}
else
	echo "Cant find rootfs partition in /dev"
fi

exit 0

