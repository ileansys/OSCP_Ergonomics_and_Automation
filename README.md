# OSCP
## OSCP Ergonomic Scripts and Configs

__config.bak__ - A terminator config file that will be used to launch terminator and execute commands like ($ autorecon $ip) 
             across different IP folders using broadcast all mode.

__autoterm.sh__ - A script that will replace the placeholder ProjectX and #1,2,3,4,5 with the ProjectName and the target IP's.

```bash
# Example - terminators config file is reset using config.bak and reconfigured with the new projects IPs
# $ ./autoterm.sh
# Project Name: OSCP_X
# IPs: 10.10.10.10 10.10.10.23 10.10.10.34 10.10.10.45 10.10.10.60

#!/bin/bash
# Restore original config
cp ~/.config/terminator/config.bak ~/.config/terminator/config
# Ask user for IPs
count=0
read -a project -p 'Project Name: '
read -a arr -p 'IPs: ' 
for elem in ${arr[@]}
do
  count=$((count+1))
  sed -i "s/projectX/$project/g" ~/.config/terminator/config 
  sed -i "s/#$count/$elem/g" ~/.config/terminator/config 
done


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
