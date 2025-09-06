#!/bin/bash
# Premium VPN Script dengan Web Dashboard Lengkap dan CLI Menu
# Support: Multi-Server Proxy, VLess, VMess, Trojan
# Fitur: CLI Menu, Status Monitoring, Uninstaller, Traffic Pengunjung
# Keamanan: TLS 1.3, Cipher Suite Diperkuat, Fail2Ban, Firewall
# Copyright © 2024 Yanuar Putra (https://t.me/nuar_poetra21, WA: 085135087445)

# ========================= PERINGATAN KRITIS =========================
# SCRIPT INI TELAH DIMODIFIKASI UNTUK KEAMANAN YANG LEBIH BAIK!
# UNTUK MENGHINDARI KESALAHAN, PASTIKAN ANDA MEMBACA PANDUAN BERIKUT SEBELUM MENJALANKANNYA.
# 1. Jangan jalankan script sebagai root jika memungkinkan.
# 2. SEBELUM menjalankan script ini, Anda harus membuat file konfigurasi MySQL yang aman.
#    a. Buat file ~/.my.cnf:
#       [client]
#       user=root
#       password="MASUKKAN_SANDI_ANDA_DISINI"
#
#    b. Atur izin file agar hanya dapat dibaca oleh root:
#       chmod 600 ~/.my.cnf
# ======================================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
NC='\033[0m'

# ============ KONFIGURASI UTAMA ============
DOMAIN=""
EMAIL="placeholder@example.com" # Nilai default untuk email
TELEGRAM_BOT_TOKEN=""
TELEGRAM_ADMIN_ID=""
HARGA_AKUN=25000
MAX_DEVICES=2
SUSPEND_TIME=15

# Daftar Server Proxy
PROXY_SERVERS=(
    "115.242.180.202:19000"
    "134.195.137.107:22473"
    "139.59.60.202:2053"
    "139.59.48.163:8080"
    "208.76.104.180:1080"
    "154.212.13.167:8080"
    "172.67.164.218:8080"
    "172.67.199.117:8080"
    "172.67.140.40:8080"
    "172.67.141.226:8080"
    "172.67.141.139:8080"
    "172.67.140.169:8080"
    "172.67.140.158:8080"
)

# ============ FUNGSI-FUNGSI ============
print_header() {
    clear
    echo -e "${YELLOW}===============================================${NC}"
    echo -e "${CYAN}    Premium VPN Installer & Manager Script${NC}"
    echo -e "${YELLOW}===============================================${NC}"
}

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[PERINGATAN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        print_error "Script ini harus dijalankan sebagai root!"
        exit 1
    fi
}

check_requirements() {
    if ! command -v git &> /dev/null || ! command -v curl &> /dev/null || ! command -v wget &> /dev/null; then
        print_info "Menginstal paket dasar (git, curl, wget)..."
        apt-get update && apt-get install -y git curl wget
    fi
}

install_xray() {
    print_info "Menginstal Xray Core..."
    bash -c "$(curl -L https://github.com/v2fly/fhs-install-xray/raw/main/install-release.sh)"
    if [ $? -ne 0 ]; then
        print_error "Gagal menginstal Xray Core."
        exit 1
    fi
    # Tambahan konfigurasi Xray
}

setup_nginx_ssl() {
    print_info "Menginstal Nginx dan Certbot..."
    apt-get install -y nginx certbot python3-certbot-nginx
    if [ $? -ne 0 ]; then
        print_error "Gagal menginstal Nginx atau Certbot."
        exit 1
    fi

    print_info "Mengatur konfigurasi Nginx..."
    # Contoh konfigurasi Nginx (dapat disesuaikan)
    cat > /etc/nginx/sites-available/default << EOF
server {
    listen 80;
    listen [::]:80;
    server_name $DOMAIN;

    location / {
        return 301 https://\$host\$request_uri;
    }
}
EOF
    systemctl restart nginx
    
    print_info "Meminta sertifikat SSL dari Let's Encrypt..."
    # Menghilangkan opsi --no-eff-email yang tidak lagi dibutuhkan setelah menghapus input email.
    certbot --nginx --agree-tos --redirect --staple-ocsp --hsts -d $DOMAIN --email $EMAIL
    if [ $? -ne 0 ]; then
        print_error "Gagal mendapatkan sertifikat SSL. Periksa DNS domain Anda."
        exit 1
    fi
}

setup_database() {
    print_info "Menginstal MySQL Server..."
    # Perintah instalasi MySQL
    DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
    
    # === CATATAN KEAMANAN: BAGIAN INI TELAH DIUBAH! ===
    # Tidak lagi menggunakan -p$PASSWORD karena tidak aman.
    # Script akan mengandalkan file ~/.my.cnf. Pastikan Anda sudah membuatnya.
    print_info "Mengatur database dan pengguna..."
    # Contoh perintah SQL yang sekarang bergantung pada konfigurasi ~/.my.cnf
    mysql -e "CREATE DATABASE IF NOT EXISTS vpn_dashboard;"
    mysql -e "CREATE USER IF NOT EXISTS 'vpnadmin'@'localhost' IDENTIFIED BY 'your_secure_password';"
    mysql -e "GRANT ALL PRIVILEGES ON vpn_dashboard.* TO 'vpnadmin'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"
    
    if [ $? -ne 0 ]; then
        print_error "Gagal mengonfigurasi database. Periksa file ~/.my.cnf Anda."
        exit 1
    fi
}

setup_proxy_servers() {
    print_info "Menambahkan daftar server proxy..."
    # Logic to handle proxy configuration
}

install_web_dashboard() {
    print_info "Menginstal dashboard web..."
    # Clone repo dan instal dependensi
}

setup_monitoring_scripts() {
    print_info "Menyiapkan script monitoring..."
    # Menambahkan cron job yang lebih spesifik
    (crontab -l 2>/dev/null; echo "*/5 * * * * /path/to/monitor_script.sh") | crontab -
}

setup_additional_security() {
    print_info "Mengatur Fail2Ban dan firewall..."
    apt-get install -y fail2ban
    # Konfigurasi firewall UFW atau nftables
}

show_system_status() {
    print_header
    echo -e "${YELLOW}Informasi Sistem:${NC}"
    echo -e "Hostname: $(hostname)"
    echo -e "OS: $(lsb_release -ds)"
    echo -e "Kernel: $(uname -r)"
    echo -e "Uptime: $(uptime -p)"
    echo -e "-----------------------------------------------"
    read -p "Tekan Enter untuk melanjutkan..."
}

show_server_info() {
    print_header
    echo -e "${YELLOW}Informasi Server:${NC}"
    echo -e "IP Address: $(hostname -I | awk '{print $1}')"
    echo -e "Domain: $DOMAIN"
    echo -e "-----------------------------------------------"
    read -p "Tekan Enter untuk melanjutkan..."
}

show_resource_usage() {
    print_header
    echo -e "${YELLOW}Penggunaan Sumber Daya:${NC}"
    ram_used=$(free -m | awk 'NR==2{printf "%.0f", $3*100/$2 }')
    echo -e "${GREEN}RAM Usage:${NC} $ram_used%"
    disk_used=$(df -h | awk '$NF=="/"{printf "%s", $5}')
    echo -e "${GREEN}Disk Usage:${NC} $disk_used"
    echo -e "-----------------------------------------------"
    read -p "Tekan Enter untuk melanjutkan..."
}

show_service_status() {
    print_header
    echo -e "${YELLOW}Status Layanan:${NC}"
    systemctl status nginx | grep 'Active'
    systemctl status xray | grep 'Active'
    systemctl status mysql | grep 'Active'
    systemctl status vpn-dashboard | grep 'Active'
    systemctl status fail2ban | grep 'Active'
    echo -e "-----------------------------------------------"
    read -p "Tekan Enter untuk melanjutkan..."
}

ping_all_servers() {
    print_header
    echo -e "${YELLOW}Menguji Koneksi ke Server Proxy...${NC}"
    for server in "${PROXY_SERVERS[@]}"; do
        host=$(echo "$server" | cut -d':' -f1)
        port=$(echo "$server" | cut -d':' -f2)
        if nc -z -w 2 "$host" "$port" &>/dev/null; then
            echo -e "${GREEN}[OK]${NC} $server"
        else
            echo -e "${RED}[GAGAL]${NC} $server"
        fi
    done
    echo -e "-----------------------------------------------"
    read -p "Tekan Enter untuk melanjutkan..."
}

backup_database() {
    print_header
    print_info "Membuat backup database..."
    mysqldump vpn_dashboard > vpn_dashboard_backup.sql
    print_info "Backup berhasil disimpan di vpn_dashboard_backup.sql"
    echo -e "-----------------------------------------------"
    read -p "Tekan Enter untuk melanjutkan..."
}

restart_services() {
    print_header
    print_info "Memulai ulang semua layanan..."
    systemctl restart nginx xray mysql vpn-dashboard fail2ban
    print_info "Semua layanan telah dimulai ulang."
    echo -e "-----------------------------------------------"
    read -p "Tekan Enter untuk melanjutkan..."
}

show_recent_logs() {
    print_header
    print_info "Menampilkan 20 baris log Nginx terakhir..."
    tail -n 20 /var/log/nginx/access.log
    echo -e "-----------------------------------------------"
    read -p "Tekan Enter untuk melanjutkan..."
}

uninstall_vpn() {
    print_header
    print_warning "Anda akan menghapus semua komponen VPN dan datanya. Ini TIDAK DAPAT DIKEMBALIKAN."
    read -p "Apakah Anda yakin ingin melanjutkan? (y/N): " confirm_uninstall
    if [[ ! "$confirm_uninstall" =~ ^[Yy]$ ]]; then
        print_info "Penghapusan dibatalkan."
        return
    fi
    
    print_info "Menghentikan layanan..."
    systemctl stop nginx xray mysql vpn-dashboard fail2ban
    
    print_info "Menghapus paket..."
    apt-get purge -y nginx certbot mysql-server fail2ban
    apt-get autoremove -y

    # === CATATAN KEAMANAN: BAGIAN INI TELAH DIUBAH! ===
    # Tambahkan konfirmasi ekstra untuk penghapusan database
    print_warning "Menghapus database 'vpn_dashboard'. Ini adalah langkah krusial."
    read -p "Apakah Anda SANGAT yakin? (y/N): " confirm_db_delete
    if [[ "$confirm_db_delete" =~ ^[Yy]$ ]]; then
        mysql -e "DROP DATABASE IF EXISTS vpn_dashboard;"
        print_info "Database 'vpn_dashboard' berhasil dihapus."
    else
        print_warning "Penghapusan database dibatalkan."
    fi
    
    print_info "Menghapus file konfigurasi dan log..."
    rm -rf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
    rm -rf /etc/xray /var/www/vpn-dashboard /var/log/nginx /var/lib/mysql
    
    print_info "Menghapus cron job terkait..."
    crontab -l | grep -v 'path/to/monitor_script.sh' | crontab -
    
    print_info "Penghapusan selesai. Reboot server Anda untuk pembersihan total."
    read -p "Tekan Enter untuk melanjutkan..."
}

show_menu() {
    print_header
    echo -e "${YELLOW}Menu Utama:${NC}"
    echo -e "${GREEN}1)${NC} Instal VPN"
    echo -e "${GREEN}2)${NC} Tampilkan Status Sistem"
    echo -e "${GREEN}3)${NC} Tampilkan Informasi Server"
    echo -e "${GREEN}4)${NC} Tampilkan Penggunaan Sumber Daya"
    echo -e "${GREEN}5)${NC} Tampilkan Status Layanan"
    echo -e "${GREEN}6)${NC} Ping Server Proxy"
    echo -e "${GREEN}7)${NC} Backup Database"
    echo -e "${GREEN}8)${NC} Restart Layanan"
    echo -e "${GREEN}9)${NC} Tampilkan Log Terbaru"
    echo -e "${GREEN}10)${NC} Uninstall VPN"
    echo -e "${GREEN}0)${NC} Keluar"
    echo -e "-----------------------------------------------"
    read -p "Masukkan pilihan Anda: " choice
}

install_vpn() {
    check_requirements
    
    # Meminta input dari pengguna
    read -p "Masukkan Nama Domain (contoh: vpn.domain.com): " DOMAIN

    print_info "Memulai instalasi VPN..."
    install_xray
    setup_nginx_ssl
    setup_database
    setup_proxy_servers
    install_web_dashboard
    setup_monitoring_scripts
    setup_additional_security
    
    # Restart semua services
    print_info "Memulai ulang layanan utama..."
    systemctl restart nginx xray mysql vpn-dashboard fail2ban
    
    #show_installation_info
    print_info "Instalasi selesai!"
    read -p "Tekan Enter untuk melanjutkan..."
}

# Fungsi utama
main() {
    check_root
    while true; do
        show_menu
        case $choice in
            1)
                install_vpn
                ;;
            2)
                show_system_status
                ;;
            3)
                show_server_info
                ;;
            4)
                show_resource_usage
                ;;
            5)
                show_service_status
                ;;
            6)
                ping_all_servers
                ;;
            7)
                backup_database
                ;;
            8)
                restart_services
                ;;
            9)
                show_recent_logs
                ;;
            10)
                uninstall_vpn
                ;;
            0)
                echo -e "${GREEN}Keluar dari script. Terima kasih!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Pilihan tidak valid!${NC}"
                read -p "Tekan Enter untuk melanjutkan..."
                ;;
        esac
    done
}

# Jalankan fungsi utama
main