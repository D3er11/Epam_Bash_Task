rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-agent-5.0.0-1.el7.x86_64.rpm
yum clean all

yum install zabbix-server-mysql zabbix-agent -y
yum install -y centos-release-scl
sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/zabbix.repo
yum install -y zabbix-web-mysql-scl zabbix-apache-conf-scl
yum install -y mariadb-server
yum install httpd -y

systemctl start mariadb
systemctl enable mariadb.service
mysql -uroot «EOF
create database zabbix character set utf8 collate utf8_bin;
create user 'zabbix'@'localhost' identified by 'zabbix';
grant all privileges on zabbix.* to 'zabbix'@'localhost';
EOF

zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql zabbix
echo DBPassword=zabbix » /etc/zabbix/zabbix_server.conf
sed -i 's/Riga/Minsk/' /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf;
sed -i 's/; //' /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf;

systemctl restart zabbix-server
systemctl enable zabbix-server
systemctl restart httpd
systemctl enable httpd
systemctl restart zabbix-agent
systemctl enable zabbix-agent
firewall-cmd —permanent —add-port=10050/tcp
firewall-cmd —permanent —add-port=10051/tcp
firewall-cmd —permanent —add-port=80/tcp
firewall-cmd —reload


setsebool -P httpd_can_network_connect on
setsebool -P httpd_can_connect_zabbix 1
setsebool -P zabbix_can_network 1
grep AVC /var/log/audit/audit.log* | audit2allow -M systemd-allow; semodule -i systemd-allow.pp
echo 'ServerName 127.0.0.1' » /etc/httpd/conf/httpd.conf
systemctl restart zabbix-server zabbix-agent httpd rh-php72-php-fpm
systemctl enable zabbix-server zabbix-agent httpd rh-php72-php-fpm
home/devops/Alex_Tselpukhousky_Bash_Final_Homework2/zabbix_agent.sh0000755000000000000000000000040614072031710024641 0ustar  rootroot#!/bin/bash
rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabb..
yum clean all

yum install zabbix-agent -y
yum install centos-release-scl -y

systemctl restart zabbix-agent httpd rh-php72-php-fpm
systemctl enable zabbix-agent httpd rh-php72-php-fpm
