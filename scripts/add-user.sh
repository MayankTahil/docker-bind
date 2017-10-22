#!/bin/sh
# Add new webmin user from the command shell on Linux
# In BSD there might be minor changes in the script required
# Written by hip0
# Thu Jul  8 14:40:11 EEST 2010
# Licensed under GPL v2
# http://www.gnu.org/licenses/gpl2.txt


webmin_etc_path=/data/webmin/etc;
webmin_passwd=miniserv.users;
webmin_acl_file=webmin.acl;
passwd_file=/etc/passwd;
webmin_init_script=/etc/init.d/webmin;
change_pass_loc=/usr/share/webmin/changepass.pl;
USER="admin"

acl= "dhcpd bind8"

get_user_id=$(id -u $USER)
if [ "$get_user_id" != "" ]; then
# add user to miniserv.users and webmin.acl files
echo "$USER:12ZWQKVLRpihs:$get_user_id" >> $webmin_etc_path/$webmin_passwd
echo "$USER: dhcpd bind8" >> $webmin_etc_path/webmin.acl
# Restart webmin to enable webmin read the new user
$webmin_init_script restart;
else
echo "$USER is not existant in $passwd_file or some kind of fatal error occured!";
fi

if [ "$PASSWORD" != "" ]; then
$change_pass_loc $webmin_etc_path $USER $PASSWORD;
fi

