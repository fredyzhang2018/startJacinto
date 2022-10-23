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
  
set timeout 1200
set time [exec date +%Y%m%d]
# set PSDKLA [exec echo "$SJ_PATH_PSDKRA"]
# set run_command $env(HOME)
set UserName $env(USER)
puts  "--- SERVER_IP : $SERVER_IP" 
puts  "--- REMOTE_IP : $REMOTE_IP" 
puts  "--- time      : $time" 
puts  "--- UserName          : $UserName" 

spawn ssh fredy@$SERVER_IP

set count 100;
while {$count > 0 } {   
    expect {
        "fredy@10.85.130.233's password" { send "fan\r";  exp_continue }
        "fredy@10.85.130.156's password" { send "fredy\r"; exp_continue }
        "Last login:" { send "ls -l /var/atlassian/application-data/bitbucket.tar.gz \r"; exp_continue }
        "/var/atlassian/application-data/bitbucket.tar.gz" { send "cd /var/atlassian/application-data/ && \
                scp ./bitbucket.tar.gz fredy@$REMOTE_IP:/home/fredy/backup/bitbucket_backup_$time.tar.gz \r"; exp_continue }
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
