####################################################################################################################
#                                           DockerTrap
####################################################################################################################
echo "Port 2222" >> /etc/ssh/sshd_config
systemctl restart sshd
sudo apt -y install socat xinetd auditd netcat-openbsd
wget https://raw.githubusercontent.com/paccc93/Docker_Trap/main/DockerTrap/honeypot
wget https://raw.githubusercontent.com/paccc93/Docker_Trap/main/DockerTrap/honeypot.clean
sudo cp honeypot /usr/bin/honeypot
sudo cp honeypot /usr/bin/honeypot.clean
sudo chmod 755 /usr/bin/honeypot
sudo chmod 755 /usr/bin/honeypot.clean
cat <<EOF >>/etc/xinetd.d/honeypot
# Container launcher for an SSH honeypot 
service honeypot
{
        disable         = no
        instances       = UNLIMITED
        server          = /usr/bin/honeypot
        socket_type     = stream
        protocol        = tcp
        port            = 22
        user            = root
        wait            = no
        log_type        = SYSLOG authpriv info
        log_on_success  = HOST PID
        log_on_failure  = HOST
}
EOF
sudo su <<HERE
#sed -i '24d' /etc/services
sudo echo -e "ssh          2222/tcp \nhoneypot     22/tcp" >> /etc/services
echo "*/5 * * * * /usr/bin/honeypot.clean" >> /etc/crontab
HERE
auditctl -a exit,always -F arch=b64 -S execve
auditctl -a exit,always -F arch=b32 -S execve
mkdir honeypot-test
wget https://raw.githubusercontent.com/paccc93/Docker_Trap/main/DockerTrap/apitrap.sh
wget https://raw.githubusercontent.com/paccc93/Docker_Trap/main/DockerTrap/Dockerfile
cp Dockerfile honeypot-test/
cd honeypot-test/
docker build . -t honeypot-test:latest