#!/bin/sh
#################################################################################
# This script will backup all database listed in the variable "mydatabase"  	#
# and will save them in the folder specify below				                #
#									                                          	#
# NOTE: this script work only with Mysql		                               	#
#				                                        					   	#
# Created By Giuseppe Faro 		                        				     	#
#################################################################################

#################################################################################
# Add other database respecting the same format	in the example	           		#
# example add 'DatabaseName' below the other DB  			                	#
#################################################################################

mydatabase=(
  'phpmyadmin' 
  
  )
  
################################# Settings ######################################
# Change myuser if you dont want that root is the owner of the backup file  	#
#################################################################################

mydbuser="" 				    # User on the Database
mypass=""          		    	# password for the Database
myuser=""				        # Owner of backup files after the Chown
backupfolder="/var/backup "		# Folder for the DB Backup files ( You have to create the backup
file_perm="440"				    # File Permissions ( default 440 - read-read-none)



#################################### Script #####################################

mkdir -p $backupfolder
n_db=${#mydatabase[@]}
now="$(date +'%d_%m_%Y_%H_%M_%S')"
logfile="$backupfolder/"backup_log_"$(date +'%Y_%m')".txt

for (( i=0;i<$n_db;i++)); do
fullpathbackupfile="$backupfolder/${mydatabase[${i}]}_$now.gz"
	mysqldump --user=$mydbuser --password=$mypass --default-character-set=utf8 ${mydatabase[${i}]} | gzip > "$fullpathbackupfile"

	echo "mysqldump for "${mydatabase[${i}]} " completed at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
	chown $myuser "$fullpathbackupfile"
	chmod $file_perm "$fullpathbackupfile"
done

chown $myuser "$logfile"
echo "file permission changed to "$myuser >> "$logfile"
echo "Removing file older than 30 days" >> "$logfile"

# if
#
#
#
#
#

find "$backupfolder" -name $mydatabase"_*"  -mtime +30 >> "$logfile"
find "$backupfolder" -name $mydatabase"_*"  -mtime +30 -exec rm {} \;
echo "Backup completed at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
echo "*****************" >> "$logfile"

exit 0





