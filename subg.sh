#! /bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

mkdir /root/Recon/$1
dir=/root/Recon/$1

echo '_____________________________________________'
echo  "${red} Subdomain Enumuration ${reset}"
echo '---------------------------------------------'
amass enum -d $1  > $dir/file.txt;
subfinder -d $1 >> $dir/file.txt;
python3 /root/Tools/github-search/github-subdomains.py -t 7da6812ba03d7ee7de9c022e9dcb5c19632ce642 -d $1 >> $dir/file.txt;
cat $dir/file.txt | grep $1 | sort -u > $dir/_subdomain;
cat $dir/_subdomain | httpx | $dir/_resolved;
rm $dir/file.txt
