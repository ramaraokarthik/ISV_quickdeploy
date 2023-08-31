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
echo -e "${GREEN}${BOLD}Open your cloud console. Click the hamburger icon."
echo "Hover one  "Compute Engine"  and then click VM Instances"
echo "Look for for the vm name that you gave when you subscribed"
echo "for gitlab. If default it will be of the form"
echo "gitlab-vm-x-vm ( x will be a numeral)"
echo "Copy the "External IP" and respond to the following question"
echo "Incase you have associated that IP to a domain name, give the"
echo -e  "domain name as the answer to the followign question ${NC}${NORM}"
sleep 5
read -p "Do you have a domain associated with the IP (repond with only y or n) : " domn
read -p "Enter the IP address of the server or associated domain name : " addr
sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl
sudo apt-get install -y postfix
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
if  [ "$domn" == "y" ]
then
 echo ""
 echo -e "${GREEN}${BOLD}Using URL gitlab.$addr ${NC}${NORM}"
 echo ""

 sudo EXTERNAL_URL="https:gitlab.$addr" apt-get install gitlab-ee
else [ "$domn" == "n"] 
 echo ""
 echo -e "${GREEN}${BOLD}Using IP $addr ${NC}${NORM}"
 echo ""
 sudo EXTERNAL_URL="http:$addr" apt-get install gitlab-ee
fi
