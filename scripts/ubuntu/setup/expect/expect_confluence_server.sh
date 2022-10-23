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
  
set timeout 600
set time [exec date +%Y_%m_%d]
# set PSDKLA [exec echo "$SJ_PATH_PSDKRA"]
# set run_command $env(HOME)
set UserName $env(USER)
puts  "--- SERVER_IP : $SERVER_IP" 
puts  "--- REMOTE_IP : $REMOTE_IP" 
puts  "--- time                : $time" 
puts  "--- UserName  --        : $UserName" 

spawn ssh fredy@$SERVER_IP

expect "password:"
send "fan\r";

expect "Last login:"
send "scp /home/$UserName/atlassian/share/backups/backup-$time.zip fredy@$REMOTE_IP:/home/fredy/backup \r";

expect "fredy@$REMOTE_IP's password:"
send "fredy\r";

expect "100%"
send "exit\r "

expect eof

# spawn ssh fredy@$SERVER_IP
# set count 100;
# while {$count > 0 } {   
#     expect {
#         "fredy@10.85.130.233's password" { send "fan\r"; exp_continue }
#         "fredy@10.85.130.156's password" { send "fredy\r"; exp_continue }
#         "Last login:" { send "scp /home/$UserName/atlassian/share/backups/backup-$time.zip fredy@$REMOTE_IP:/home/fredy/backup\r"; exp_continue}
#        eof { send "exit\r"; }
#        timeout { puts "timeout waiting for response" ; close ; exit }
#    }
#    set times [ expr $count-1];
# }

# nothing beyond this line 
