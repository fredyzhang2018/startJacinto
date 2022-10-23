
bootfs_file=$PWD/boot-j7-evm.tar.gz
rootfs_file=$PWD/tisdk-rootfs-image-j7-evm.tar.xz

bootfs_folder=/media/$USER/BOOT
rootfs_folder=/media/$USER/rootfs

tar_bootfs()
{
    if [ -d $bootfs_folder ]
    then
        echo "Creating $bootfs_file from $bootfs_folder ..."
        if [ ! -f $bootfs_file ]
        then
            cd $bootfs_folder
            tar czf $bootfs_file .
            cd -
            sync
            echo "Creating $bootfs_file from $bootfs_folder ... Done"
        else
            echo "ERROR: $bootfs_file exists NOT overwriting it, delete this file manually to create a new one !!!"
        fi
    else
        echo "ERROR: $bootfs_folder not found !!!"
    fi
}

tar_rootfs()
{
    if [ -d $rootfs_folder ]
    then
        echo "Creating $rootfs_file from $rootfs_folder ..."
        if [ ! -f $rootfs_file ]
        then
            cd $rootfs_folder
            sudo tar cpzf $rootfs_file .
            cd -
            sync
            echo "Creating $rootfs_file from $rootfs_folder ... Done"
        else
            echo "ERROR: $rootfs_file exists NOT overwriting it, delete this file manually to create a new one !!!"
        fi
    else
        echo "ERROR: $rootfs_folder not found !!!"
    fi

}

tar_bootfs
tar_rootfs
