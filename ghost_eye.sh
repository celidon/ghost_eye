#!/bin/bash

menu () {
echo -ne "\n\033[1;34m[+] 1.   Whois Lookup
[+] 2.   DNS Lookup
[+] 3.   EtherApe – Graphical Network Monitor (root)
[+] 4.   Nmap Port Scan
[+] 5.   HTTP Header Grabber
[+] 6.   Clickjacking Test - X-Frame-Options Header
[+] 7.   Robots.txt Scanner
[+] 8.   Link Grabber
[+] 9.   IP Location Finder
[+] 10.  Traceroute
[+] 11.  Have I been pwned
[I] 12.  Options 1, 2, 4, 5, 9, and 10 
[D] 13.  Options 1, 2, 4, 5, 6, 7, 8, 9, and 10
[x] 14.  Exit\033[0m

\033[1;34m[+]\033[1;m \033[1;91mEnter your choice:\033[1;m "
read opt

case $opt in
    "1")
        read -rp "Enter Domain or IP Address: " target
	whois $target
        ;;
    "2")
        read -rp "Enter Domain or IP Address: " target
        dig $target +trace ANY
        ;;
    "3")
        nohup sudo etherape 2> $HOME/etherape.nohup 
        ;;
    "4")
        read -rp "Enter Domain or IP Address: " target
        nmap -Pn $target
        ;;
    "5")
        read -rp "Enter Domain or IP Address: " target
        curl -ILk $target
        ;;
    "6")
        read -rp "Enter Domain: " target
        curl -sILk $target | tee >(grep X-Frame-Options && echo -e "\033[32m\nClick Jacking Header is present\nYou can't clickjack this site!\n\033[1m" || echo -e "\033[31m\nX-Frame-Options-Header is missing!\nClickjacking is possible,this site is vulnerable to Clickjacking\n\033[1m")
        sleep .5
        ;;
    "7")
        read -rp "Enter Domain: " target
        curl -Lk $target/robots.txt
        ;;
    "8")
        read -rp "Enter Domain: " target
        curl -sI $target | grep 200 && lynx -listonly -dump $target | awk '{print $2}' | sort -u | grep -v links: || curl -sI $target | grep Location | awk '{print $2}' | lynx -listonly -dump - | awk '{print $2}' | sort -u | grep -v links:
        ;;
    "9")
        read -rp "Enter Domain or IP Address: " target
         awk -F"," '{print "IP: " $14 "\nStatus: " $1 "\nRegion: " $5 "\nCountry: " $2 "\nCity: " $6 "\nISP: " $11 "\nLat & Lon: " $8 " " $9 "\nZIP: " $7 "\nTimezone: " $10 "\nAS: " $13}' <<< `curl -s http://ip-api.com/csv/$target`
        ;;
    "10")
        read -rp "Enter Domain or IP Address: " target
        mtr -4 -rwc 1 $target
        ;;
    "11")
        read -rp "Enter Email Address: " target
        curl -s https://haveibeenpwned.com/api/v2/breachedaccount/$target | ".[] | { Title,Domain,BreachDate,Description,IsVerified }" | tr } "\n" | tr -d {,
        ;;
    "12")
        read -rp "Enter Domain or IP Address: " target
        whois $target
	dig $target +trace ANY
        nmap -Pn $target
        curl -ILk $target
        awk -F"," '{print "IP: " $14 "\nStatus: " $1 "\nRegion: " $5 "\nCountry: " $2 "\nCity: " $6 "\nISP: " $11 "\nLat & Lon: " $8 " " $9 "\nZIP: " $7 "\nTimezone: " $10 "\nAS: " $13}' <<< `curl -s http://ip-api.com/csv/$target`
        mtr -4 -rwc 1 $target
        ;;
    "13")
        read -rp "Enter Domain: " target 
	whois $target
	dig $target +trace ANY
        nmap -Pn $target
        curl -ILk $target
        curl -sILk $target | tee >(grep X-Frame-Options && echo -e "\033[32m\nClick Jacking Header is present\nYou can't clickjack this site!\n\033[1m" || echo -e "\033[31m\nX-Frame-Options-Header is missing!\nClickjacking is possible, this site is vulnerable to Clickjacking\n\033[1m");sleep .5
        curl -Lk $target/robots.txt
        curl -sI $target | grep 200 && lynx -listonly -dump $target | awk '{print $2}' | sort -u | grep -v links: || curl -sI $target | grep Location | awk '{print $2}' | lynx -listonly -dump - | awk '{print $2}' | sort -u | grep -v links:
        awk -F"," '{print "IP: " $14 "\nStatus: " $1 "\nRegion: " $5 "\nCountry: " $2 "\nCity: " $6 "\nISP: " $11 "\nLat & Lon: " $8 " " $9 "\nZIP: " $7 "\nTimezone: " $10 "\nAS: " $13}' <<< `curl -s http://ip-api.com/csv/$target`
        mtr -4 -rwc 1 $target
        ;;
    "14")
	echo Good-bye
	exit
	;; 
    *)
        echo "\nPlease make a valid numerical selection from above\n"
        ;;
esac
menu
}



echo -e " \033[1;34m"
cat ./banner
echo -e "\033[1;m
        \033[34mGhost Eye - Information Gathering Tool \033[0m
        \033[34mAuthor: Jolanda de Koff https://github.com/BullsEye0 | Bulls Eye \033[0m

              Hi there, Shall we play a game..?\n"

menu
