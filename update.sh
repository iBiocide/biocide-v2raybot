#!/bin/bash

# Written By: biocide

if [ "$(id -u)" -ne 0 ]; then
    echo -e "\033[33mPlease run as root\033[0m"
    exit
fi

wait

echo " "

PS3=" Please Select Action: "
options=("Update bot" "Update panel" "Backup" "Delete" "Donate" "Exit")
select opt in "${options[@]}"
do
	case $opt in
		"Update bot")
			echo " "
			read -p "Are you sure you want to update?[y/n]: " answer
			echo " "
			if [ "$answer" != "${answer#[Yy]}" ]; then
			mv /var/www/html/biocide/baseInfo.php /root/
      			# mv /var/www/html/biocide/settings/values.php /root/
			sudo apt-get install -y git
			sudo apt-get install -y wget
			sudo apt-get install -y unzip
			sudo apt install curl -y
			echo -e "\n\e[92mUpdating ...\033[0m\n"
			sleep 4
			rm -r /var/www/html/biocide/
			echo -e "\n\e[92mWait a few seconds ...\033[0m\n"
			sleep 3
			git clone https://github.com/biocidedev/biocide.git /var/www/html/biocide
			sudo chown -R www-data:www-data /var/www/html/biocide/
			sudo chmod -R 755 /var/www/html/biocide/
			sleep 3
			mv /root/baseInfo.php /var/www/html/biocide/
      			# mv /root/values.php /var/www/html/biocide/settings/
# 			if [ $? -ne 0 ]; then
# 			echo -e "\n\e[41mError: The update failed!\033[0m\n"
# 			exit 1
# 			else
			
			sleep 1

   			db_namebiocide=$(cat /var/www/html/biocide/baseInfo.php | grep '$dbName' | cut -d"'" -f2)
		      	db_userbiocide=$(cat /var/www/html/biocide/baseInfo.php | grep '$dbUserName' | cut -d"'" -f2)
		      	db_passbiocide=$(cat /var/www/html/biocide/baseInfo.php | grep '$dbPassword' | cut -d"'" -f2)
			bot_token=$(cat /var/www/html/biocide/baseInfo.php | grep '$botToken' | cut -d"'" -f2)
			bot_token2=$(cat /var/www/html/biocide/baseInfo.php | grep '$botToken' | cut -d'"' -f2)
			bot_url=$(cat /var/www/html/biocide/baseInfo.php | grep '$botUrl' | cut -d'"' -d"'" -f2)
			
			filepath="/var/www/html/biocide/baseInfo.php"
			
			bot_value=$(cat $filepath | grep '$admin =' | sed 's/.*= //' | sed 's/;//')
			
                        MESSAGE="🤖 biocide robot has been successfully updated! "$'\n\n'"🔻token: <code>${bot_token}</code>"$'\n'"🔻admin: <code>${bot_value}</code> "$'\n'"🔻phpmyadmin: <code>https://domain.com/phpmyadmin</code>"$'\n'"🔹db name: <code>${db_namebiocide}</code>"$'\n'"🔹db username: <code>${db_userbiocide}</code>"$'\n'"🔹db password: <code>${db_passbiocide}</code>"$'\n\n'"📢 @biocidech "
			
   			curl -s -X POST "https://api.telegram.org/bot${bot_token}/sendMessage" -d chat_id="${bot_value}" -d text="$MESSAGE" -d parse_mode="html"
			
			curl -s -X POST "https://api.telegram.org/bot${bot_token2}/sendMessage" -d chat_id="${bot_value}" -d text="$MESSAGE" -d parse_mode="html"
			
			sleep 1
        
			url="${bot_url}install/install.php?updateBot"
			curl $url

   			url3="${bot_url}install/install.php?updateBot"
			curl $url3

   			echo -e "\n\e[92mUpdating ...\033[0m\n"
      
			sleep 2

                        # url2="${bot_url}updateShareConfig.php"
  			# curl $url2
     
			# sleep 1
   
			sudo rm -r /var/www/html/biocide/webpanel
			sudo rm -r /var/www/html/biocide/install
			rm /var/www/html/biocide/createDB.php
			rm /var/www/html/biocide/updateShareConfig.php
			rm /var/www/html/biocide/README.md
			rm /var/www/html/biocide/README-fa.md
			rm /var/www/html/biocide/LICENSE
			rm /var/www/html/biocide/update.sh
			rm /var/www/html/biocide/biocide.sh
  			rm /var/www/html/biocide/tempCookie.txt
  			rm /var/www/html/biocide/settings/messagebiocide.json
			clear
			
			echo -e "\n\e[92mThe script was successfully updated! \033[0m\n"
			
# 			fi

			else
			  echo -e "\e[41mCancel the update.\033[0m\n"
			fi

			break ;;
		
		"Update panel")
			echo " "
			read -p "Are you sure you want to update?[y/n]: " answer
			echo " "
			if [ "$answer" != "${answer#[Yy]}" ]; then
			
			sudo apt-get install -y php-ssh2
			sudo apt-get install -y libssh2-1-dev libssh2-1

			destination_dir=$(find /var/www/html -type d -name "*biopanel*" | head -n 1)

			if [ -z "$destination_dir" ]; then
			    RANDOM_NUMBER=$(( RANDOM % 10000000 + 1000000 ))
			    mkdir "/var/www/html/biopanel${RANDOM_NUMBER}"
			    echo "Directory created: biopanel${RANDOM_NUMBER}"
			    echo "Folder created successfully!"
			    sudo mkdir /root/updatebiocide
   			    sleep 1
			    touch /root/updatebiocide/bioup.txt
			    sudo chmod -R 777 /root/updatebiocide/bioup.txt
			    sleep 1
			    ASAS="$"
			    echo "${ASAS}path = '${RANDOM_NUMBER}';" >> /root/updatebiocide/bioup.txt
			else
			    echo "Folder already exists."
			fi
			
			

			 destination_dir=$(find /var/www/html -type d -name "*biopanel*" | head -n 1)

			 cd /var/www/html/
			 wget -O biocidepanel.zip https://github.com/biocidedev/biocide/releases/download/9.1.2/biocidepanel.zip

			 file_to_transfer="/var/www/html/biocidepanel.zip"
			 destination_dir=$(find /var/www/html -type d -name "*biopanel*" | head -n 1)

			 if [ -z "$destination_dir" ]; then
			   echo "Error: Could not find directory containing 'bio' in '/var/www/html'"
			   exit 1
			 fi

			 mv "$file_to_transfer" "$destination_dir/" && yes | unzip "$destination_dir/biocidepanel.zip" -d "$destination_dir/" && rm "$destination_dir/biocidepanel.zip" && sudo chmod -R 755 "$destination_dir/" && sudo chown -R www-data:www-data "$destination_dir/" 


			wait


			echo -e "\n\e[92mUpdating ...\033[0m\n"
			
			bot_token=$(cat /var/www/html/biocide/baseInfo.php | grep '$botToken' | cut -d"'" -f2)
			bot_token2=$(cat /var/www/html/biocide/baseInfo.php | grep '$botToken' | cut -d'"' -f2)
			
			filepath="/var/www/html/biocide/baseInfo.php"
			
			bot_value=$(cat $filepath | grep '$admin =' | sed 's/.*= //' | sed 's/;//')
			
			MESSAGE="🕹 biocide panel has been successfully updated!"

			curl -s -X POST "https://api.telegram.org/bot${bot_token}/sendMessage" -d chat_id="${bot_value}" -d text="$MESSAGE"
			curl -s -X POST "https://api.telegram.org/bot${bot_token2}/sendMessage" -d chat_id="${bot_value}" -d text="$MESSAGE"
			
			sleep 1
			
			if [ $? -ne 0 ]; then
			echo -e "\n\e[41mError: The update failed!\033[0m\n"
			exit 1
			else
			
# 			echo -e '\e[31m'

# 			find /var/www/html -type d -name "*biopanel*" -print | sed "s|/var/www/html|& \n\n\nPanel: https://yourdomain.com|g"
			
# 			echo -e '\033[0m'




# 			echo -e ' '
# 			echo -e ' '

# 			read -p "Enter the domain: " domainname
			
# 			if [ "$domainname" = "" ]; then

# 			exit

# 			else
			
			
# 			DOMAIN_NAME="$domainname"
			
# 			PATHS=$(cat /root/updatebiocide/bioup.txt | grep '$path' | cut -d"'" -f2)
# 			PATHS=$(cat /root/confbiocide/dbrootbiocide.txt | grep '$path' | cut -d"'" -f2)
# 			(crontab -l | grep -v "backupnutif.php") | crontab -
			
# 			(crontab -l ; echo "* * * * * curl https://${DOMAIN_NAME}/biopanel${PATHS}/backupnutif.php >/dev/null 2>&1") | sort - | uniq - | crontab -
# 			(crontab -l ; echo "* * * * * curl https://${DOMAIN_NAME}/biopanel${PATHS}/backupnutif.php >/dev/null 2>&1") | sort - | uniq - | crontab -
# 			fi
			
			clear

			echo -e ' '

			
# 			PATHS2=$(cat /root/confbiocide/dbrootbiocide.txt | grep '$path' | cut -d"'" -f2)
# 			PATHS3=$(cat /root/updatebiocide/bioup.txt | grep '$path' | cut -d"'" -f2)
# 			if [ -d "/root/confbiocide/dbrootbiocide.txt" ]; then
#                             echo -e "\e[92mPanel: \e[31mhttps://${DOMAIN_NAME}/biopanel${PATHS}\033[0m\n"
# 			    (crontab -l ; echo "* * * * * curl https://${DOMAIN_NAME}/biopanel${PATHS}/backupnutif.php >/dev/null 2>&1") | sort - | uniq - | crontab -
# 			else
# 			    echo -e "\e[92mPanel: \e[31mhttps://${DOMAIN_NAME}/biopanel${PATHS3}\033[0m\n"
# 			    (crontab -l ; echo "* * * * * curl https://${DOMAIN_NAME}/biopanel${PATHS3}/backupnutif.php >/dev/null 2>&1") | sort - | uniq - | crontab -
# 			fi
			
			
		
			echo -e "\e[92mThe script was successfully updated!\033[0m\n"
			
			fi




			else
			  echo -e "\e[41mCancel the update.\033[0m\n"
			fi

			break ;;
		"Backup")
			echo " "
			wait

			(crontab -l ; echo "0 * * * * ./dbbackupbiocide.sh") | sort - | uniq - | crontab -
			
			wget https://raw.githubusercontent.com/biocidedev/biocide/main/dbbackupbiocide.sh | chmod +x dbbackupbiocide.sh
			./dbbackupbiocide.sh
   
			wget https://raw.githubusercontent.com/biocidedev/biocide/main/dbbackupbiocide.sh | chmod +x dbbackupbiocide.sh
			./dbbackupbiocide.sh
			
			echo -e "\n\e[92m The backup settings have been successfully completed.\033[0m\n"

			break ;;
		"Delete")
			echo " "
			
			wait
			
			passs=$(cat /root/confbiocide/dbrootbiocide.txt | grep '$pass' | cut -d"'" -f2)
   			userrr=$(cat /root/confbiocide/dbrootbiocide.txt | grep '$user' | cut -d"'" -f2)
			pathsss=$(cat /root/confbiocide/dbrootbiocide.txt | grep '$path' | cut -d"'" -f2)
			pathsss=$(cat /root/confbiocide/dbrootbiocide.txt | grep '$path' | cut -d"'" -f2)
			passsword=$(cat /var/www/html/biocide/baseInfo.php | grep '$dbPassword' | cut -d"'" -f2)
   			userrrname=$(cat /var/www/html/biocide/baseInfo.php | grep '$dbUserName' | cut -d"'" -f2)
			
			mysql -u $userrr -p$passs -e "DROP DATABASE biocide;" -e "DROP USER '$userrrname'@'localhost';" -e "DROP USER '$userrrname'@'%';"

			sudo rm -r /var/www/html/biopanel${pathsss}
			sudo rm -r /var/www/html/biocide
			
			clear
			
			sleep 1
			
			(crontab -l | grep -v "messagebiocide.php") | crontab -
			(crontab -l | grep -v "rewardReport.php") | crontab -
			(crontab -l | grep -v "warnusers.php") | crontab -
			(crontab -l | grep -v "backupnutif.php") | crontab -
			
			echo -e "\n\e[92m Removed successfully.\033[0m\n"
			break ;;
		"Donate")
			echo " "
			echo -e "\n\e[91mBanksaderat ( nosrat ): \e[36m6037691526973185\033[0m\n\e[91mTron(trx): \e[36mTY8j7of18gbMtneB8bbL7SZk5gcntQEemG\n\e[91mBitcoin: \e[36mbc1qcnkjnqvs7kyxvlfrns8t4ely7x85dhvz5gqge4\033[0m\n"
			exit 0
			break ;;
		"Exit")
			echo " "
			break
			;;
			*) echo "Invalid option!"
	esac
done
