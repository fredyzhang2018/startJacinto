#!/usr/bin/expect -f
#############################################################################################
# This script is using for installing the keywriter                                         #    
# @Author : Fredy Zhang                                                                     #
# @email  ：fredyzhang2018@gmail.com 																#				
# @date   ：2022-03-19 
# @update : fredy  V1                                                                       # 
##############################################################################################

# ---Args
# $1 install package name
set SERVER_IP      [lindex $argv 0]
# $2 install package 
set REMOTE_IP    [lindex $argv 1]
  
set timeout 6000
# set time [exec date +%Y%m%d]
# set PSDKLA [exec echo "$SJ_PATH_PSDKRA"]
# set run_command $env(HOME)
set UserName $env(USER)
puts  "--- SERVER_IP : $SERVER_IP" 
puts  "--- REMOTE_IP : $REMOTE_IP" 
# puts  "--- Pkg_Name          : $Pkg_Name" 
puts  "--- UserName          : $UserName" 

spawn ssh fredy@$SERVER_IP

set count 100;
while {$count > 0 } {   
    expect {
        "password:" { send "fan\r"; exp_continue }
        "password for fredy" { send "fan\r"; exp_continue }
        "Last login:" { send "ls /var/atlassian/application-data/\r"; exp_continue }
        "confluence" { send " cd /var/atlassian/application-data/ && \
                            sudo  tar -zcvf bitbucket.tar.gz ./bitbucket/  && 
                             ls \r"; exp_continue }
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
