# /usr/bin/bash	


cleaning_txt () {
	echo "[+] Cleaning up text files"
	sed -i 's/*.//g' /root/Desktop/"$web _site"/subfinder_domain.txt
	sed -i 's/ /\n/g' /root/Desktop/"$web _site"/knockpy_domains.txt
	sed -i 's/    <TD>//g' /root/Desktop/"$web _site"/crtsh_domains.txt
	sed -i 's/<\/TD>//g' /root/Desktop/"$web _site"/crtsh_domains.txt
	sed -i 's/*.//g' /root/Desktop/"$web _site"/crtsh_domains.txt
	sed -i 's/<BR>/\n/g' /root/Desktop/"$web _site"/crtsh_domains.txt
}

finding_subdomain()
{
	echo "[+] finding subdomains using subfinder"
	subfinder -d "$web" -o /root/Desktop/"$web _site"/subfinder_domain.txt
	
	echo "[+] finding subdomains using knock"

	python3 recon-my-way/knock/knockpy/knockpy.py "$web" | grep "$web" > /root/Desktop/"$web _site"/knockpy_domain.txt
	grep "$web" /root/Desktop/"$web _site"/knockpy_domain.txt > /root/Desktop/"$web _site"/knockpy_domains.txt
	rm knockpy_domain.txt

	echo "[+] finding subdomains using crt.sh"
	curl https://crt.sh/?q=%25."$web" | grep "$web\|<TD>" > /root/Desktop/"$web _site"/crtsh_domains.txt
	

}

finding_paths_and_port()
{
	echo "[+] finding google dork information"
	./Fast-Google-Dorks-Scan/FGDS.sh "$web" | grep "http" > /root/Desktop/"$web _site"/google_doc_info.txt
	
	echo "[+] using nmap to find ports"
	nmap -sV -p- -A "$web" > /root/Desktop/"$web _site"/nmap_info.txt
	
}

finding_path_dirsearch()
{
	echo "[+] finding paths using dirsearch with common wordlist"
	python3 recon-my-way/dirsearch/dirsearch.py -u "$web" -w recon-my-way/dirsearch/common.txt > /root/Desktop/"$web _site"/dirsearch_paths.txt

}

main()
{
	
	echo "[+] Executing the script"
	mkdir -p /root/Desktop/"$web _site"

	finding_subdomain
	
	finding_paths_and_port
	finding_path_dirsearch
	
	echo "[+] Cleaning up the text"
	cleaning_txt
	
}

echo "Enter the name of the site: "
read web
echo "[+] performing recon of website : $web"

if [[ $web -eq "" ]]
then
	echo "[-] no website given"
else
	main
fi


