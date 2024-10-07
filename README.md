# OSCP
## OSCP Ergonomic Scripts and Configs

__config.bak__ - A terminator config file that will be used to launch terminator and execute commands like ($ autorecon $ip) 
             across different IP folders using broadcast all mode.

__autoterm.sh__ - A script that will replace the placeholder ProjectX and #1,2,3,4,5 with the ProjectName and the target IP's.


__autobof.sh__ - A script for generating 'full hex shellcode characterset' -> 'hex shellcode with deducted badchars' -> 'msfpayload'. Autobof will automatically generate payloads and modify exploit.py payload variable. Autobof's primary use is to aid in exploit creation while exploring vulnerable binaries with debuggers such as immunity or edb.  

__badcharset.py__ - A script for generating the full hex shellcode.  

__exploit.py__ - A python script for testing for simple buffer overflow.  

__dollar_ip_prompt_command.sh__ - Has a PROMPT_COMMAND env variable that will track a directory named using an IP on the current path (pwd)
                             and it will set the $ip env variable to that IP named directory. The code should be place on .bashrc or .zshrc. For zsh you have to add the line ```bash precmd() { eval "$PROMPT_COMMAND" }``` at the end of the .zshrc file

