#!/bin/bash
clear
rm -rf main.sh
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
NC='\e[0m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
cd /root

# System version number
if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this script as root"
    exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
    echo "OpenVZ is not supported"
    exit 1
fi

read -p " Masukan User Pengguna Script (bebas) : " usersc
echo "${usersc}" > /root/.arthor
localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
if [[ "$hst" != "$dart" ]]; then
    echo "$localip $(hostname)" >> /etc/hosts
fi
export IP=$( curl -sS icanhazip.com )

if [[ $( uname -m | awk '{print $1}' ) == "x86_64" ]]; then
    echo -e ""
else
    echo -e "${EROR} Your Architecture Is Not Supported ( ${YELLOW}$( uname -m )${NC} )"
    exit 1
fi

# Checking System
if [[ $( cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g' ) == "ubuntu" ]]; then
    echo -e ""
elif [[ $( cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g' ) == "debian" ]]; then
    echo -e ""
else
    echo -e "${EROR} Your OS Is Not Supported ( ${YELLOW}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${NC} )"
    exit 1
fi

if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this script as root"
    exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
    echo "OpenVZ is not supported"
    exit 1
fi

sleep 1
echo -e "[ ${tyblue}NOTES${NC} ] Auto Script VPS By FV STORE"
sleep 1
echo -e "[ ${tyblue}NOTES${NC} ] Support On OS Debian 10 & Ubuntu 18/20 LTS"
sleep 1
read -p "[ ${green}INFO${NC} ] Press [ Enter ] to continue installation"
sleep 1
clear

function LOGO() {
    echo -e "
    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║    $Green╔═╗╔╦╗╔═╗╔═╗╔═╗╔╦╗╔═╗╦  ╦╔═╗╔╦╗  ╦  ╦╔═╗╔╦╗$NC   ║
    ║    $Green╠═╣ ║ ║ ║║  ╠═╣║║║║╣ �║  ║╚═╗ ║   ║  ║╠═╣║║║$NC   ║
    ║    $Green╩ ╩ ╩ ╚═╝╚═╝╩ ╩╩ ╩╚═╝╚═╝╩╚═╝ ╩   ╚═╝╩╩ ╩╩ ╩$NC   ║
    ║    ${YELLOW}Copyright${FONT} (C)$GRAY https://github.com/zhets$NC       ║
    ║                                                              ║
    ╚══════════════════════════════════════════════════════════════╝
          ${RED} SCRIPT AUTO INSTALL FREE ${FONT}    
           ${RED} SCRIPT MOD BY XDXL ${FONT}
   ${RED}JANGAN MENGGUNAKAN LAYANAN VPN UNTUK INSTALLASI !${FONT}"
}

checking_sc() {
    echo "Checking system..."
}

curl "ipinfo.io/org?token=7a814b6263b02c" > /root/.isp
curl "ipinfo.io/city?token=7a814b6263b02c" > /root/.city
curl "ipinfo.io/region?token=7a814b6263b02c" > /root/.region

secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}

start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

echo -e "[ ${green}INFO${NC} ] Aight good ... installation file is ready"
sleep 2

mkdir -p /etc/xray
touch /etc/xray/domain
mkdir -p /var/lib/xdxl >/dev/null 2>&1
echo "IP=" >> /var/lib/xdxl/ipvps.conf

echo ""
sudo apt update -y
sudo apt update -y
sudo apt dist-upgrade -y
sudo apt-get remove --purge ufw firewalld -y 
sudo apt-get remove --purge exim4 -y 
sudo apt install -y at screen curl jq bzip2 gzip coreutils rsyslog iftop \
    htop zip unzip net-tools sed gnupg gnupg1 \
    bc sudo apt-transport-https build-essential dirmngr libxml-parser-perl neofetch screenfetch git lsof \
    openssl openvpn easy-rsa fail2ban tmux \
    stunnel4 vnstat squid3 \
    dropbear libsqlite3-dev \
    socat cron bash-completion ntpdate xz-utils sudo apt-transport-https \
    gnupg2 dnsutils lsb-release chrony
sudo apt-get install nodejs -y
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1
apt install -y bzip2 gzip coreutils screen curl unzip
apt install -y git curl python ruby jq curl at
apt install wondershaper -y
gem install lolcat

apt -y install vnstat > /dev/null 2>&1
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev > /dev/null 2>&1
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
NET=$(ip route show default | awk '/default/ {print $5}')
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
/etc/init.d/vnstat status
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6

sudo apt install -y libnss3-dev libnspr4-dev pkg-config libpam0g-dev libcap-ng-dev libcap-ng-utils libselinux1-dev libcurl4-nss-dev flex bison make libnss3-tools libevent-dev xl2tpd pptpd

# Install Swap & Gotop
gotop_latest="$(curl -s https://api.github.com/repos/xxxserxxx/gotop/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
gotop_link="https://github.com/xxxserxxx/gotop/releases/download/v$gotop_latest/gotop_v"$gotop_latest"_linux_amd64.deb"
curl -sL "$gotop_link" -o /tmp/gotop.deb
dpkg -i /tmp/gotop.deb >/dev/null 2>&1

# Buat swap sebesar 1G
dd if=/dev/zero of=/swapfile bs=1024 count=1048576
mkswap /swapfile
chown root:root /swapfile
chmod 0600 /swapfile >/dev/null 2>&1
swapon /swapfile >/dev/null 2>&1
sed -i '$ i\/swapfile      swap swap   defaults    0 0' /etc/fstab

# Singkronisasi jam
chronyd -q 'server 0.id.pool.ntp.org iburst'
chronyc sourcestats -v
chronyc tracking -v

wget -q https://raw.githubusercontent.com/zhets/sc/main/xray/bbr.sh && chmod +x bbr.sh && ./bbr.sh

function pasang_domain() {
    clear
    LOGO
    echo -e "   ╔══════════════════════════════════════╗"
    echo -e "   |        \e[1;32mSETUP DOMAIN\033[0m             |"
    echo -e "   ╠══════════════════════════════════════╣"
    echo -e "     \e[1;32m1)\e[0m Gunakan Domain Sendiri"
    echo -e "     \e[1;32m2)\e[0m Gunakan Domain Random"
    echo -e "   ════════════════════════════════════════"
    read -p "   Choose Options From [ 1 - 2 ] : " host
    echo ""
    if [[ $host == "1" ]]; then
        echo -e "   \e[1;32mMasukan Domain Kamu !$NC"
        read -p "   Subdomain: " pp
        echo "$pp" > /root/domain
        echo "IP=$pp" > /var/lib/xdxl/ipvps.conf
    elif [[ $host == "2" ]]; then
        wget -q https://raw.githubusercontent.com/zhets/free/main/cf.sh && chmod +x cf.sh && ./cf.sh
        rm -f /root/cf.sh
        clear
    else
        echo -e " Input dengan benar !!!"
        sleep 2
        pasang_domain
    fi
}

# Function untuk install web admin panel
install_webadmin() {
    clear
    LOGO
    echo -e "   ╔══════════════════════════════════════╗"
    echo -e "   |      \e[1;32mINSTALL WEB ADMIN PANEL\033[0m     |"
    echo -e "   ╠══════════════════════════════════════╣"
    echo -e "     \e[1;32m1)\e[0m Install Webmin"
    echo -e "     \e[1;32m2)\e[0m Install Cockpit"
    echo -e "     \e[1;32m3)\e[0m Install Ajenti"
    echo -e "     \e[1;32m4)\e[0m Kembali ke Menu Utama"
    echo -e "   ════════════════════════════════════════"
    read -p "   Pilih opsi [1-4]: " webadmin_option
    
    case $webadmin_option in
        1)
            echo -e "[ ${green}INFO${NC} ] Installing Webmin..."
            # Install Webmin
            echo "deb https://download.webmin.com/download/repository sarge contrib" | tee /etc/apt/sources.list.d/webmin.list
            wget -q -O - http://www.webmin.com/jcameron-key.asc | apt-key add -
            apt update
            apt install -y webmin
            systemctl enable webmin
            systemctl start webmin
            echo -e "[ ${green}INFO${NC} ] Webmin installed on port 10000"
            echo -e "[ ${green}INFO${NC} ] Access: https://$(curl -s icanhazip.com):10000"
            read -p "Press any key to continue..."
            ;;
        2)
            echo -e "[ ${green}INFO${NC} ] Installing Cockpit..."
            # Install Cockpit
            apt install -y cockpit
            systemctl enable cockpit
            systemctl start cockpit
            echo -e "[ ${green}INFO${NC} ] Cockpit installed on port 9090"
            echo -e "[ ${green}INFO${NC} ] Access: https://$(curl -s icanhazip.com):9090"
            read -p "Press any key to continue..."
            ;;
        3)
            echo -e "[ ${green}INFO${NC} ] Installing Ajenti..."
            # Install Ajenti
            wget -O- https://raw.github.com/ajenti/ajenti/master/scripts/install-ubuntu.sh | sh
            echo -e "[ ${green}INFO${NC} ] Ajenti installed on port 8000"
            echo -e "[ ${green}INFO${NC} ] Access: http://$(curl -s icanhazip.com):8000"
            read -p "Press any key to continue..."
            ;;
        4)
            return
            ;;
        *)
            echo -e "[ ${red}ERROR${NC} ] Invalid option"
            sleep 2
            install_webadmin
            ;;
    esac
}

# Function untuk uninstall script
uninstall_script() {
    clear
    LOGO
    echo -e "   ╔══════════════════════════════════════╗"
    echo -e "   |        \e[1;31mUNINSTALL SCRIPT\033[0m          |"
    echo -e "   ╠══════════════════════════════════════╣"
    echo -e "   ${red}PERINGATAN: Tindakan ini akan menghapus semua${NC}"
    echo -e "   ${red}komponen yang diinstall oleh script ini!${NC}"
    echo -e "   ════════════════════════════════════════"
    read -p "   Apakah Anda yakin ingin melanjutkan? (y/n): " confirm
    
    if [[ $confirm != "y" && $confirm != "Y" ]]; then
        echo -e "[ ${green}INFO${NC} ] Uninstall dibatalkan"
        sleep 2
        return
    fi
    
    echo -e "[ ${yell}INFO${NC} ] Memulai uninstall..."
    
    # Fungsi untuk menghapus service
    remove_services() {
        systemctl stop ws-dropbear
        systemctl stop ws-stunnel
        systemctl disable ws-dropbear
        systemctl disable ws-stunnel
        rm -f /etc/systemd/system/ws-dropbear.service
        rm -f /etc/systemd/system/ws-stunnel.service
        systemctl daemon-reload
        echo -e "[ ${green}INFO${NC} ] Services dihapus"
    }

    # Fungsi untuk menghapus file dan direktori
    remove_files() {
        rm -f /usr/local/bin/ws-dropbear
        rm -f /usr/local/bin/ws-stunnel
        rm -rf /etc/xray
        rm -rf /var/lib/xdxl
        rm -f /root/.arthor
        rm -f /root/.isp
        rm -f /root/.city
        rm -f /root/.region
        rm -f /swapfile
        rm -f /etc/systemd/system/ws-dropbear.service
        rm -f /etc/systemd/system/ws-stunnel.service
        rm -f /usr/local/sbin/menu
        rm -rf /usr/local/sbin/*
        rm -f /root/log-install.txt
        rm -f /etc/log-create-user.log
        rm -f /opt/.ver
        echo -e "[ ${green}INFO${NC} ] File dan direktori dihapus"
    }

    # Fungsi untuk menghapus paket yang diinstall
    remove_packages() {
        apt-get remove --purge -y at screen curl jq bzip2 gzip coreutils rsyslog iftop \
        htop zip unzip net-tools sed gnupg gnupg1 bc apt-transport-https build-essential \
        dirmngr libxml-parser-perl neofetch screenfetch git lsof openssl openvpn easy-rsa \
        fail2ban tmux stunnel4 vnstat squid3 dropbear libsqlite3-dev socat cron bash-completion \
        ntpdate xz-utils gnupg2 dnsutils lsb-release chrony nodejs wondershaper

        apt-get autoremove -y
        apt-get clean
        echo -e "[ ${green}INFO${NC} ] Paket dihapus"
    }

    # Fungsi untuk menghapus konfigurasi dan data aplikasi
    purge_configs() {
        apt-get purge -y ufw firewalld exim4
        rm -rf /etc/ssh/*_key*
        rm -rf /etc/openvpn
        rm -rf /etc/squid3
        rm -rf /etc/dropbear
        rm -rf /etc/fail2ban
        rm -rf /etc/stunnel4
        rm -rf /etc/vnstat
        echo -e "[ ${green}INFO${NC} ] Konfigurasi dihapus"
    }

    # Eksekusi uninstall
    echo -e "[ ${yell}INFO${NC} ] Menghentikan services..."
    remove_services

    echo -e "[ ${yell}INFO${NC} ] Menghapus file dan direktori..."
    remove_files

    echo -e "[ ${yell}INFO${NC} ] Menghapus paket yang diinstall..."
    remove_packages

    echo -e "[ ${yell}INFO${NC} ] Menghapus konfigurasi..."
    purge_configs

    echo -e "[ ${green}SUCCESS${NC} ] Uninstall selesai!"
    read -p "Reboot sekarang? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        reboot
    else
        exit 0
    fi
}

# Function untuk menu utama
main_menu() {
    while true; do
        clear
        LOGO
        echo -e "   ╔══════════════════════════════════════╗"
        echo -e "   |         \e[1;32mMAIN MENU\033[0m              |"
        echo -e "   ╠══════════════════════════════════════╣"
        echo -e "     \e[1;32m1)\e[0m Install SSH & OpenVPN"
        echo -e "     \e[1;32m2)\e[0m Install XRAY"
        echo -e "     \e[1;32m3)\e[0m Install Backup System"
        echo -e "     \e[1;32m4)\e[0m Install Web Admin Panel"
        echo -e "     \e[1;31m5)\e[0m Uninstall Script"
        echo -e "     \e[1;32m6)\e[0m Exit"
        echo -e "   ════════════════════════════════════════"
        read -p "   Pilih opsi [1-6]: " main_option
        
        case $main_option in
            1)
                echo -e "\e[33m══════════════════════════════════════════════════════\033[0m"
                echo -e "$green          Install SSH                $NC"
                echo -e "\e[33m══════════════════════════════════════════════════════\033[0m"
                sleep 2
                wget https://raw.githubusercontent.com/zhets/free/main/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
                ;;
            2)
                echo -e "\e[33m══════════════════════════════════════════════════════\033[0m"
                echo -e "$green          Install XRAY              $NC"
                echo -e "\e[33m══════════════════════════════════════════════════════\033[0m"
                sleep 2
                wget https://raw.githubusercontent.com/zhets/free/main/insxray.sh && chmod +x insxray.sh && ./insxray.sh
                ;;
            3)
                echo -e "\e[33m══════════════════════════════════════════════════════\033[0m"
                echo -e "$green          Install backup             $NC"
                echo -e "\e[33m══════════════════════════════════════════════════════\033[0m"
                sleep 2
                wget https://raw.githubusercontent.com/zhets/sc/main/backup/set-br && chmod +x set-br.sh && ./set-br.sh
                ;;
            4)
                install_webadmin
                ;;
            5)
                uninstall_script
                ;;
            6)
                echo -e "[ ${green}INFO${NC} ] Exiting..."
                exit 0
                ;;
            *)
                echo -e "[ ${red}ERROR${NC} ] Invalid option"
                sleep 2
                ;;
        esac
    done
}

# Panggil fungsi pasang_domain
pasang_domain

# Install Websocket
echo -e "\e[33m══════════════════════════════════════════════════════\033[0m"
echo -e "$green          Install Websocket             $NC"
echo -e "\e[33m══════════════════════════════════════════════════════\033[0m"
sleep 2
wget -O /usr/local/bin/ws-dropbear https://raw.githubusercontent.com/zhets/sc/main/sshws/dropbear-ws.py
wget -O /usr/local/bin/ws-stunnel https://raw.githubusercontent.com/zhets/sc/main/sshws/ws-stunnel
chmod +x /usr/local/bin/ws-dropbear
chmod +x /usr/local/bin/ws-stunnel

wget https://raw.githubusercontent.com/zhets/free/main/free.zip
unzip free.zip
chmod +x menu/*
mv menu/* /usr/local/sbin/
rm -rf menu free.zip

cat> /etc/systemd/system/ws-dropbear.service << END
[Unit]
Description=Websocket Python By XDXL STORE
Documentation=https://google.com
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /usr/local/bin/ws-dropbear 2095
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

cat> /etc/systemd/system/ws-stunnel.service << END
[Unit]
Description=SSH Over Websocket Python OTTIN network
Documentation=https://google.com
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
Restart=on-failure
ExecStart=/usr/bin/python -O /usr/local/bin/ws-stunnel

[Install]
WantedBy=multi-user.target
END

cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
menu
END

chmod 644 /root/.profile
mkdir -p /etc/xray/limit
mkdir -p /etc/xray/limit/ip

if [ -f "/root/log-install.txt" ]; then
    rm /root/log-install.txt > /dev/null 2>&1
fi
if [ -f "/etc/afak.conf" ]; then
    rm /etc/afak.conf > /dev/null 2>&1
fi
if [ ! -f "/etc/log-create-user.log" ]; then
    echo "Log All Account " > /etc/log-create-user.log
fi

history -c
echo $serverV > /opt/.ver
aureb=$(cat /home/re_otm)
b=11
if [ $aureb -gt $b ]
then
    gg="PM"
else
    gg="AM"
fi

# Panggil menu utama
main_menu

# Cleanup
rm /root/main.sh >/dev/null 2>&1
rm /root/ins-xray.sh >/dev/null 2>&1
rm /root/insshws.sh >/dev/null 2>&1
rm /root/ssh-vpn.sh >/dev/null 2>&1

secs_to_human "$(($(date +%s) - ${start}))" | tee -a log-install.txt
echo -ne "[ ${yell}WARNING${NC} ] Do you want to reboot now? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
    exit 0
else
    reboot
fi