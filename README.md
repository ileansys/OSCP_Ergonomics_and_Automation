# OSCP
## OSCP Ergonomic Scripts and Configs

__config.bak__ - A terminator config file that will be used to launch terminator and execute commands like ($ autorecon $ip) 
             across different IP folders using broadcast all mode.

__autoterm.sh__ - A script that will replace the placeholder ProjectX and #1,2,3,4,5 with the ProjectName and the target IP's.

```bash
# Example - terminators config file is reset using config.bak and reconfigured with the new projects IPs
# $./autoterm.sh
# Insert your Kali IP (Default: 127.0.0.1): 192.168.0.104
# Insert your Kali Port (Default: 22): 2222
# Setting Kali IP to 192.168.0.104
# Setting Kali SSH Port to 2222
# Project Name: R
# IPs: 10.10.10.23 10.10.10.5
# Terminator config successfully changed.

#!/bin/bash
# Restore original config
cp ~/.config/terminator/config.bak ~/.config/terminator/config
count=0 #Counter for Number of IPs

# This host should be accessible using present ssh-keys. SSH Password setup will break terminator.
read -a kalibox -p 'Insert your Kali IP (Default: 127.0.0.1): '
# The ssh service on this host should be running on port 22 by default
read -a kaliport -p 'Insert your Kali Port (Default: 22): ' 

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
```


__dollar_ip_prompt_command.sh__ - Has a PROMPT_COMMAND env variable that will track a directory named using an IP on the current path (pwd)
                             and it will set the $ip env variable to that IP named directory. The code should be place on .bashrc or .profile.

```bash
# Example - $ip env variable is automatically set using the code below
# $ mkdir 10.10.10.5
# $ cd 10.10.10.5
# $ autorecon $ip 

function prompt_command {
	unset ip #unset IP to make sure its not assigned
	nfields=$(echo $PWD | awk -F '/' '{print NF}') #get the number of directories along the path
	for i in $(seq $nfields) #iterate through the number of directories in the path
	do
		base=$(echo $PWD | awk -v i=$i -F '/' '{print $i}') #get a specific directory
		if [[ $base =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then #if that directory is an ip
			export ip=$base #export that ip 
		fi
	done
}
export PROMPT_COMMAND=prompt_command
```

[![Watch the video](https://i1.ytimg.com/vi/vRj62ltRSiY/sddefault.jpg)](https://www.youtube.com/watch?v=vRj62ltRSiY "Click to watch demo on Youtube")
