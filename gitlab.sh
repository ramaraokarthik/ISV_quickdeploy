#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
BOLD=$(tput bold)
NORM=$(tput sgr0)

echo -e "${RED}${BOLD}         APAC ISV QuickDeploy for Gitlab ${NC}${NORM}"
echo ""
echo ""
sleep 2
echo -e "${GREEN}${BOLD}##!! Open your cloud console. Click the hamburger icon."
echo "##!! Hover one  "Compute Engine"  and then click VM Instances"
echo "##!! Look for for the vm name that you gave when you subscribed"
echo "##!! for gitlab. If default it will be of the form"
echo "##!! gitlab-vm-x-vm ( x will be a numeral)"
echo "##!! Copy the "External IP" and respond to the following question"
echo "##!! Incase you have associated that IP to a domain name, give the"
echo -e  "##!! domain name as the answer to the followign question ${NC}${NORM}"
sleep 4
read -p "Do you have a domain associated with the IP (repond with only y or n) : " domn
read -p "Enter the IP address of the server or associated domain name : " addr
######Incase of a reinstall
# sudo apt-get update
# sudo apt-get install -y curl openssh-server ca-certificates tzdata perl
# sudo apt-get install -y postfix
# curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
###############


if  [ "$domn" == "y" ]
then
 URL=gitlab.$addr
 echo ""
 echo -e "${GREEN}${BOLD}Using URL $URL  ${NC}${NORM}"
 echo ""

#######Reinstall 
 #sudo EXTERNAL_URL="https:gitlab.$addr" apt-get install gitlab-ee

sudo sed -i "s/external_url 'http:\/\/gitlab.example.com'/external_url 'http:\/\/$URL'/" /etc/gitlab/gitlab.rb 

else [ "$domn" == "n"] 
 echo ""
 echo -e "${GREEN}${BOLD}Using IP $addr ${NC}${NORM}"
 echo ""
 # sudo EXTERNAL_URL="http:$addr" apt-get install gitlab-ee
 sudo sed -i "s/external_url 'http:\/\/gitlab.example.com'/external_url 'http:\/\/$addr'/" /etc/gitlab/gitlab.rb 
fi

read -p "Do you have a License Key (repond with only y or n) : " lic
if  [ "$lic" == "y" ]
then
 #read -p "Please copy and paste the key : " key
 echo "Input your key and press ctrl D"
 key=$(cat)
 sudo touch /etc/gitlab/licensefile
 sudo chmod 777 /etc/gitlab/licensefile
 sudo echo $key > /etc/gitlab/licensefile
 sudo sed -i "s/# gitlab_rails\['initial_license_file'\] \= '\/etc\/gitlab\/company.gitlab\-license'/gitlab_rails\['initial_license_file'\] \= '\/etc\/gitlab\/licensefffile'/" /etc/gitlab/gitlab.rb
fi
sudo  gitlab-ctl reconfigure
echo "##!! Open the browser and connect to the gitlab instance with the IP address or gitlab.<domain name given above>"
echo "##!! Login with the root credentals below and change password immediately. Add uses and administer the instance"
echo "##!! Login name : root"
pass=$(sudo awk '$1=="Password:"{print $2}' /etc/gitlab/initial_root_password)
echo " Password: $pass"
echo "Reset Password using UI"

