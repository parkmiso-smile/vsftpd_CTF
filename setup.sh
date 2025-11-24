#!/bin/bash

echo "[*] FTP Hidden File Forensics CTF 환경 구축을 시작합니다."

# 1. vsftpd 설치
echo "[*] vsftpd 설치 중..."
sudo apt update -y
sudo apt install -y vsftpd

# 2. FTP 전용 계정 생성
echo "[*] ftpuser 계정을 생성합니다."
sudo adduser --disabled-password --gecos "" ftpuser
echo "ftpuser:password123" | sudo chpasswd

# 3. 숨겨진 FLAG 파일 생성
echo "[*] 숨겨진 FLAG 파일 생성..."
echo "FLAG{find_hidden_file}" | sudo tee /home/ftpuser/.secret_flag > /dev/null
sudo chown ftpuser:ftpuser /home/ftpuser/.secret_flag

# 4. 정상 파일 저장소 생성
echo "[*] 정상 파일 디렉토리 생성..."
sudo mkdir -p /home/ftpuser/files
echo "일반 문서입니다" | sudo tee /home/ftpuser/files/readme.txt > /dev/null
sudo chown -R ftpuser:ftpuser /home/ftpuser/files

# 5. 공격자 로그 삽입
echo "[*] 공격자 로그 생성..."
echo 'Mon Nov 24 20:11:22 2025 [pid 2] [ftpuser] OK UPLOAD: "/home/ftpuser/.secret_flag"' \
| sudo tee -a /var/log/vsftpd.log > /dev/null

echo "[+] CTF 환경 구축 완료!"
echo "[+] FTP 계정: ftpuser"
echo "[+] FTP 비밀번호: password123"
echo "[+] 숨김 파일 경로: /home/ftpuser/.secret_flag"

