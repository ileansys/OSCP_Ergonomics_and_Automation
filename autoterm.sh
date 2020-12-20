#!/bin/bash
# Restore original config
cp ~/.config/terminator/config.bak ~/.config/terminator/config
count=0 #Counter for Number of IPs
read -a kalibox -p 'Insert your Kali IP (Default: 127.0.0.1): ' #This host should be accessible using preset ssh-keys (.authorized_keys). SSH Password prompt won't work and it will break terminator
read -a kaliport -p 'Insert your Kali Port (Default: 22): ' #The ssh service on this host should be running on port 2222 by default

if [ -z "$kalibox" ]
then 
  kalibox="127.0.0.1";
fi 

echo "Setting Kali IP to ${kalibox}"

if [ -z "$kaliport" ]
then 
  kaliport="22";
fi

echo "Setting Kali SSH Port to ${kaliport}"

read -a project -p 'Project Name: '
read -a ips -p 'IPs: '

if [ -z "$project" ]
then 
  echo "Project Name cannot be empty"
  exit 0
fi

if [ -z "$ips" ]
then 
  echo "Please specify some IPs"
  exit 0
fi 

for elem in ${ips[@]}
do
  if [[ ! "$elem" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then 
    echo "Please specify real IPs"
    exit 0
  fi 
  count=$((count+1))
  sed -i "s/127.0.0.1/$kalibox/g" ~/.config/terminator/config
  sed -i "s/2222/$kaliport/g" ~/.config/terminator/config
  sed -i "s/projectX/$project/g" ~/.config/terminator/config 
  sed -i "s/#$count/$elem/g" ~/.config/terminator/config 
done

echo 'Terminator config successfully changed.'