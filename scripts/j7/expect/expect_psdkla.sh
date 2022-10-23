#!/usr/bin/expect -f
#############################################################################################
# This script is using for installing the keywriter                                         #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-02-18 
# @update : fredy  V1                                                                       # 
##############################################################################################

# ---Args
# $1 install package name
set Pkg_PATH      [lindex $argv 0]
# $2 install package 
set Install_PATH  [lindex $argv 1]
  
set Pkg_Name       [exec echo $Install_PATH | cut -d / -f 6 ]


set timeout 600
# set time [exec date +%Y%m%d]
# set PSDKLA [exec echo "$SJ_PATH_PSDKRA"]
# set run_command $env(HOME)
set UserName $env(USER)
puts  "--- Pkg_PATH : $Pkg_PATH" 
puts  "--- Install_PATH      : $Install_PATH" 
puts  "--- Pkg_Name          : $Pkg_Name" 
puts  "--- UserName          : $UserName" 
spawn $Pkg_PATH

set count 100;
while {$count > 0 } {   
    expect {
        "Please choose an option" { send "13\r"; exp_continue }
        "Enter] to continue:" { send "\r"; exp_continue }
        "Do you accept this license?" { send "y\r"; exp_continue }
        "/home/$UserName/$Pkg_Name" { send "$Install_PATH\r"; exp_continue }
        "Do you want to continue?" { send "Y\r"; exp_continue }
        "View Readme file?" { send "Y\r"; exp_continue }
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
