#!/usr/bin/expect -f
#############################################################################################
# This script is using for installing the keywriter                                         #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-02-18 
# @update : fredy  V1                                                                       # 
##############################################################################################

# ---Args
# $1 Keywriter package
set package  [lindex $argv 0]
# $2 PDK_PATH
set install_path [lindex $argv 1].

#key write Package Name
# set KeywirtePgName    [exec echo $package | cut -d / -f 6 | cut -d . -f 1]

# set timeout -1
# set time [exec date +%Y%m%d]
# set PSDKLA [exec echo "$SJ_PATH_PSDKRA"]
# set run_command $env(HOME)
set UserName $env(USER)
puts  "--- key_write_package : $package" 
puts  "--- install_path      : $install_path" 
# puts  "--- KeywirtePgName    : $KeywirtePgName" 
puts  "--- UserName          : $UserName" 
spawn $package

set count 100;
while {$count > 0 } {   
    expect {
        "Please choose an option" { send "13\r"; exp_continue }
        "Enter] to continue:" { send "\r"; exp_continue }
        "Do you accept this license?" { send "y\r"; exp_continue }
        "/home/$UserName]" { send "$install_path\r"; exp_continue }
        "TI Deep Learning Product for Jacinto 7 " { send "Y\r"; exp_continue }
        "Is the selection above correct?" { send "Y\r"; exp_continue }
        "Do you want to continue?" { send "Y\r"; exp_continue }
        # "View Readme file?" { send "Y\r"; exp_continue }
       eof { }
       timeout { puts "timeout waiting for response" ; close ; exit }
   }
   set times [ expr $count-1];
}


# expect "Enter] to continue:"
# send -- "\r"

# expect "Enter] to continue:"
# send -- "\r"

# expect "Enter] to continue:"
# send -- "\r"
# expect "Enter] to continue:"
# send -- "\r"
# expect "Enter] to continue:"
# send -- "\r"
# expect "Enter] to continue:"
# send -- "\r"
# expect "\[Enter] to continue:"
# send -- "\r\t"

# expect "Enter] to continue:"
# send -- "\r\t"

# expect "Enter] to continue:"
# send -- "\r\t"



# expect eof



# set count 5;
# while {$count > 0 } {
# puts "count : $count\n";
# set count [expr $count-1];
# }
