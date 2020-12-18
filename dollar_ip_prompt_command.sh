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