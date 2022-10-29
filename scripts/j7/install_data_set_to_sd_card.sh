
data_set_file=$1

rootfs_folder=/media/$USER/rootfs

untar_file()
{
    if [ -d $rootfs_folder ]
    then
        echo "Installing $data_set_file to $test_data_folder ..."
        if [ -f $data_set_file ]
        then
            mkdir -p $test_data_folder
            tar -xf $data_set_file $tar_arg -C $test_data_folder
            sync
            echo "Installing $data_set_file to $test_data_folder/ ... Done"
        else
            echo "ERROR: $data_set_file not found !!!"
        fi
    else
        echo "ERROR: $rootfs_folder not found !!!"
    fi
}

if [[ $data_set_file == *psdk_rtos_ti_data_set_*.tar.gz ]]
then

    if [[ $data_set_file == *psdk_rtos_ti_data_set_ptk*.tar.gz ]]
    then
        test_data_folder=$rootfs_folder/opt/vision_apps
    else
        test_data_folder=$rootfs_folder/opt/vision_apps/test_data
        tar_arg="--strip 2"
    fi
    untar_file

else

    echo "Usage: $0 <path/to/psdk_rtos_auto_ti_data_set*.tar.gz>"
    echo "       Pass one of the 2 data sets provided on the PSDK RTOS download page."

fi
