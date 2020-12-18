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
