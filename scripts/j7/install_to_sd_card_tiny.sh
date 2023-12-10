
bootfs_file=$PWD/boot-j7-evm.tar.gz
#rootfs_file=$PWD/tisdk-default-image-j7-evm.tar.xz
rootfs_file=$PWD/tisdk-tiny-image-j7-evm.tar.xz

bootfs_folder=/media/$USER/BOOT
rootfs_folder=/media/$USER/rootfs


update_rootfs()
{

    echo "Installing $SJ_PATH_PSDKLA/filesystem/tisdk-tiny-image-j7-evm.tar.xz to $SJ_PATH_PSDKRA ..."
    if [ ! -f $rootfs_file ]
    then
        cp -v $SJ_PATH_PSDKLA/filesystem/tisdk-tiny-image-j7-evm.tar.xz $SJ_PATH_PSDKRA
        echo "Installing $SJ_PATH_PSDKLA/filesystem/tisdk-tiny-image-j7-evm.tar.xz to $SJ_PATH_PSDKRA ... Done"
    else
        echo "Continue:$PWD/tisdk-tiny-image-j7-evm.tar.xz found !!!"
    fi
}


untar_bootfs()
{
    if [ -d $bootfs_folder ]
    then
        echo "Installing $bootfs_file to $bootfs_folder ..."
        if [ -f $bootfs_file ]
        then
            cd $bootfs_folder
            tar -xf $bootfs_file
            cd -
            sync
            echo "Installing $bootfs_file to $bootfs_folder ... Done"
        else
            echo "ERROR: $bootfs_file not found !!!"
        fi
    else
        echo "ERROR: $bootfs_folder not found !!!"
    fi
}

untar_rootfs()
{
    if [ -d $rootfs_folder ]
    then
        echo "Installing $rootfs_file to $rootfs_folder ..."
        if [ -f $rootfs_file ]
        then
            cd $rootfs_folder
            sudo chmod 777 .
            sudo tar --same-owner -xf $rootfs_file .
            cd -
	    sudo mkdir $rootfs_folder/opt/
            sudo mkdir $rootfs_folder/lib/firmware
            sudo chmod 777 $rootfs_folder/opt/
            sudo chmod 777 $rootfs_folder/lib/firmware
            sudo chmod 777 $rootfs_folder/etc/security/
            sudo chmod 666 $rootfs_folder/etc/security/limits.conf
            sudo chmod 777 $rootfs_folder/boot
            sudo chmod 777 $rootfs_folder/usr/lib
            sudo chmod 777 $rootfs_folder/usr/include
            sync
            echo "Installing $rootfs_file to /media/$USER/$rootfs_folder ... Done"
        else
            echo "ERROR: $rootfs_file not found !!!"
        fi
    else
        echo "ERROR: $rootfs_folder not found !!!"
    fi

}

update_rootfs
untar_bootfs
untar_rootfs
