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
cat $dir/file.txt | grep $1 | sort -u > $dir/_subdomain;
cat $dir/_subdomain | httpx -silent | tee $dir/test_resolved;
bash /root/Tools/subzzZ/subzzZ -d $1 -s | sed 's/:8443$//' |  sed 's/:81$//' |  sed 's/:80$//' |  sed 's/:443$//' | sed 's/:8080$//' |  sed 's/:8000$//' |  sed 's/:10000$//' | sed 's/:9000$//' >> $dir/test_resolved
cat $dir/test_resolved | sort -u > $dir/_resolved
rm $dir/test_resolved
rm $dir/file.txt
