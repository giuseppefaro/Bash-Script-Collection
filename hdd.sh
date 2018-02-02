#!/bin/bash
#################################################################################
#script Check Faulty hardware 
#
#


# run linuxchk
#linuxchk='/tools/SITE/etc/bin/linuxchk'
#$linuxchk

##Check HDD and mountpoint
lsblk



disk_available=$(lsscsi  | awk '{if (NR!=1){ print $6}'})

disk_n="$disk_available" | wc -l
echo $disk_n

# check SMART Status ( create a for to get all the hard disk checked )
#for (( i=0;i<$disk_n;i++));do        
#        sudo smartctl -a "${disk_available[${i}]}"| grep 'SMART Health Status:'
#done

echo "space"


# check SMART Status ( create a for to get all the hard disk checked )
sudo smartctl -a /dev/sda | grep 'SMART Health Status:'


## List of the error need will be checked in /var/log/messages
errormsg=( "has fallen off the bus" 
                "Buffer I/O error on device")
                                                
# this part count how many string are included in the var $errormsg
errormsg_db=${#errormsg[@]} 

# Starting to check common error in /var/log/messages
for (( i=0;i<$errormsg_db;i++));do
        less /var/log/messages | grep "${errormsg[${i}]}"
        echo "No error like " ${errormsg[${i}]}
done

disk_available=$(lsscsi  | awk '{if (NR!=1){ print $6}'})
echo $disk_available

# HDD disk space left <25%

# check space left on /u/


# Check badblocks

echo -e 'Do you want check for badblocks\n. Hit enter to skip\n. Type /dev/sda or /dev/sdb to check a specific disk'
echo -e 'This is the list of your available disk'
echo $disk_available
read sel

if $sel is empty skip if not run badblocks
 
if [ -z $sel ];then
        exit
else
        echo Starting badblock on $sel
        sudo badblocks $sel
        exit
fi
exit 0
