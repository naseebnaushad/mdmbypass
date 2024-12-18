#!/bin/bash
RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'
NC='\033[0m'
echo ""
echo -e "Auto Tools for MacOS - Targeting maverick Volume"
echo ""
PS3='Please enter your choice: '
options=("Bypass on Recovery (maverick)" "Disable Notification (SIP) (maverick)" "Disable Notification (Recovery) (maverick)" "Check MDM Enrollment (maverick)" "Exit")
select opt in "${options[@]}"; do
	case $opt in
	"Bypass on Recovery (maverick)")
		echo -e "${GRN}Bypass on Recovery for maverick"
		if [ -d "/Volumes/maverick - Data" ]; then
   			diskutil rename "maverick - Data" "Data"
		fi
		echo -e "${GRN}Create a new user on maverick"
        echo -e "${BLU}Press Enter to move to the next step, if not filled in, it will automatically receive the default value"
  		echo -e "Enter username (Default: MAC)"
		read realName
  		realName="${realName:=MAC}"
    	echo -e "${BLUE}Receive username ${RED}WRITE LINE WITHOUT MARKS ${GRN} (Default: MAC)"
      	read username
		username="${username:=MAC}"
  		echo -e "${BLUE}Enter password (default: 1234)"
    	read passw
      	passw="${passw:=1234}"
		dscl_path='/Volumes/maverick/private/var/db/dslocal/nodes/Default' 
        echo -e "${GREEN}Creating users on maverick"
  		# Create user
    	dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username"
      	dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UserShell "/bin/zsh"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
	 	dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UniqueID "501"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" PrimaryGroupID "20"
		mkdir "/Volumes/maverick/Users/$username"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" NFSHomeDirectory "/Users/$username"
	    dscl -f "$dscl_path" localhost -passwd "/Local/Default/Users/$username" "$passw"
	    dscl -f "$dscl_path" localhost -append "/Local/Default/Groups/admin" GroupMembership $username
		echo "0.0.0.0 deviceenrollment.apple.com" >> /Volumes/maverick/etc/hosts
		echo "0.0.0.0 mdmenrollment.apple.com" >> /Volumes/maverick/etc/hosts
		echo "0.0.0.0 iprofiles.apple.com" >> /Volumes/maverick/etc/hosts
        echo -e "${GREEN}Successfully blocked MDM enrollment hosts on maverick${NC}"
		# Remove config profile
  		touch /Volumes/maverick/private/var/db/.AppleSetupDone
        rm -rf /Volumes/maverick/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
		rm -rf /Volumes/maverick/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
		touch /Volumes/maverick/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
		touch /Volumes/maverick/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
		echo "----------------------"
		break
		;;
    "Disable Notification (SIP) (maverick)")
    	echo -e "${RED}Please Insert Your Password To Proceed on maverick${NC}"
        sudo rm /Volumes/maverick/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
        sudo rm /Volumes/maverick/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
        sudo touch /Volumes/maverick/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
        sudo touch /Volumes/maverick/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
        break
        ;;
    "Disable Notification (Recovery) (maverick)")
        rm -rf /Volumes/maverick/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
		rm -rf /Volumes/maverick/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
		touch /Volumes/maverick/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
		touch /Volumes/maverick/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
        break
        ;;
	"Check MDM Enrollment (maverick)")
		echo ""
		echo -e "${GRN}Check MDM Enrollment for maverick${NC}"
		echo ""
		echo -e "${RED}Please Insert Your Password To Proceed on maverick${NC}"
		echo ""
		sudo profiles show -type enrollment
		break
		;;
	"Quit")
		break
		;;
	*) echo "Invalid option $REPLY" ;;
	esac
done
