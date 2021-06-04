#! /bin/bash

#telegram_bot
telegram_api_key="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
telegram_chat_id="xxxxxxx"

#input
while [ -n "$1" ]; do
                    case "$1" in
                        -d | --domain)
                        target=$2
                        shift
                        ;;
                        -a | --api)
                        api=$3
                        shift
                        ;;
                        -tg | --telegram)
                        silent=True ;;
                        *) echo -e $red"[-]"$end "Unknown Option: $1"
                        ;;
          esac
shift
done

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

if [ $target ]
then
	mkdir /root/Recon/$target >> /dev/null 2>&1
	dir=/root/Recon/$target

	echo '_____________________________________________'
	echo  "${red} Subdomain Enumuration ${reset}"
	echo '---------------------------------------------'
	curl -s -X POST "https://api.telegram.org/bot$telegram_api_key/sendMessage" -d chat_id="$telegram_chat_id" -d text="*Subg Launched*" -d parse_mode="MarkdownV2" &> /dev/null;
	amass enum -d $target > $dir/file.txt;
	echo '_____________________________________________'
	echo  "${green} Amass scan completed ${reset}"
	echo '---------------------------------------------'
	subfinder -d $target -silent >> $dir/file.txt;
	cat $dir/file.txt | grep $target | sort -u > $dir/_subdomain;
	cat $dir/_subdomain | httpx -silent | tee $dir/test_resolved;
	cat $dir/test_resolved | sort -u > $dir/_resolved
	rm $dir/test_resolved
	rm $dir/file.txt
	if [ $silent ]
	then
		curl -s -X POST "https://api.telegram.org/bot$telegram_api_key/sendMessage" -d chat_id="$telegram_chat_id" -d text="*subdomain enumeration completed*" -d parse_mode="MarkdownV2" &> /dev/null;
	fi

	echo '_____________________________________________'
	echo  "${red} Nuclei Scan ${reset}"
	echo '---------------------------------------------'
	cat $dir/_resolved | nuclei -t /root/nuclei-templates/exposures -o $dir/_nuclei-exposures -silent;
	echo  "${red} 1.Exposures ${reset}"
	cat $dir/_resolved | nuclei -t /root/nuclei-templates/network -o $dir/_nuclei-network -silent;
	echo  "${red} 2.Network ${reset}"
	cat $dir/_resolved | nuclei -t /root/nuclei-templates/technologies -o $dir/_nuclei-technologies -silent;
	echo  "${red} 3.Technologies ${reset}"
	cat $dir/_resolved | nuclei -t /root/nuclei-templates/cves -o $dir/_nuclei-cves -silent;
	echo  "${red} 4.Cves ${reset}"
	cat $dir/_resolved | nuclei -t /root/nuclei-templates/exposed-panels -o $dir/_nuclei-exposed-panels -silent;
	echo  "${red} 5.exposed-panels ${reset}"
	cat $dir/_resolved | nuclei -t /root/nuclei-templates/fuzzing -o $dir/_nuclei-fuzzing -silent;
	echo  "${red} 6.Fuzzing ${reset}"
	cat $dir/_resolved | nuclei -t /root/nuclei-templates/iot -o $dir/_nuclei-iot -silent;
	echo  "${red} 7.Iot ${reset}"
	cat $dir/_resolved | nuclei -t /root/nuclei-templates/miscellaneous -o $dir/_nuclei-miscellaneous -silent;
	echo  "${red} 8.Miscellaneous ${reset}"
	cat $dir/_resolved | nuclei -t /root/nuclei-templates/vulnerabilities -o $dir/_nuclei-vulnerabilities -silent;
	echo  "${red} 9.Vulnerabilities ${reset}"
	cat $dir/_resolved | nuclei -t /root/nuclei-templates/default-logins -o $dir/_nuclei-default-logins -silent;
	echo  "${red} 10.Default-logins ${reset}"
	cat $dir/_resolved | nuclei -t /root/nuclei-templates/exposed-tokens -o $dir/_nuclei-exposed-tokens -silent;
	echo  "${red} 11.Exposed-tokens ${reset}"
	cat $dir/_resolved | nuclei -t /root/nuclei-templates/headless -o $dir/_nuclei-headless -silent;
	echo  "${red} 12.Headless ${reset}"
	cat $dir/_resolved | nuclei -t /root/nuclei-templates/misconfiguration -o $dir/_nuclei-misconfiguration -silent;
	echo  "${red} 13.Misconfiguration ${reset}"
	cat $dir/_resolved | nuclei -t /root/nuclei-templates/takeovers -o $dir/_nuclei-takeovers -silent;
	echo  "${red} 14.Takeovers ${reset}"
	cat $dir/_resolved | nuclei -t /root/nuclei-templates/workflows -o $dir/_nuclei-workflows -silent;
	echo  "${red} 15.Workflows ${reset}"
	cat $dir/_resolved | nuclei -t /root/nuclei-templates/others -o $dir/_nuclei-others -silent;
	echo  "${red} 16.Others ${reset}"
	cat $dir/_resolved | nuclei -t /root/nuclei-templates/dns -o $dir/_nuclei-dns -silent;
	echo  "${red} 17.Dns ${reset}"
	if [ $silent ]
	then
	curl -s -X POST "https://api.telegram.org/bot$telegram_api_key/sendMessage" -d chat_id="$telegram_chat_id" -d text="*nuclei scan completed*" -d parse_mode="MarkdownV2" &> /dev/null;
	fi

	
	if [ $silent ]
	then
	curl -s -X POST "https://api.telegram.org/bot$telegram_api_key/sendMessage" -d chat_id="$telegram_chat_id" -d text="*Subdomain Enumeration Completed*" -d parse_mode="MarkdownV2" &> /dev/null;
	fi

else
	 echo "Argument: ./subg.sh [-d/--domain] required"
fi

