firstsource=/home/
secondsource=/root/
BACKUPTIME=`date +"%d-%m-%y-%H;%M;%S"`

DESTINATION=/mnt/backups/$BACKUPTIME.tar.gz


tar -cpzf $DESTINATION $firstsource $secondsource

###Adding cron rule
echo "29 0 * * * /bin/bash /home/devops/backupfolder/999.sh" > /var/spool/cron/root
home/devops/Alex_Tselpukhousky_Bash_Final_Homework4/provision.sh

yum install nfs-utils
yum install expect -y
mkdir /var/nfsshare
chmod -R 777 /var/nfsshare
chown nfsnobody:nfsnobody /var/nfsshare

systemctl enable rpcbind
systemctl enable nfs-server
systemctl enable nfs-lock
systemctl enable nfs-idmap
systemctl start rpcbind
systemctl start nfs-server
systemctl start nfs-lock
systemctl start nfs-idmap

mkdir -p /mnt/nfs_shares/{Human_Resource,Finance,Marketing}
mkdir -p /mnt/backups
chmod -R 777 /mnt/backups

echo "/mnt/nfs_shares/Human_Resource 192.168.0.130/24(rw,sync)" » /etc/exports
echo "/mnt/nfs_shares/Finance 192.168.0.130/24(rw,sync)" » /etc/exports
echo "/mnt/nfs_shares/Marketing 192.168.0.130/24(rw,sync)" » /etc/exports
echo "/mnt/backups 192.168.0.130/24(rw,sync,no_all_squash,root_squash)" » /etc/exports
exportfs -arv
exportfs -s


systemctl restart nfs-server

firewall-cmd —permanent —zone=public —add-service=nfs
firewall-cmd —permanent —zone=public —add-service=mountd
firewall-cmd —permanent —zone=public —add-service=rpc-bind
firewall-cmd —reload

#######Creating file that send commands to nfs_clien

rm -rf utg.sh

touch utg.sh

echo "#!/usr/bin/expect -f" » utg.sh

echo spawn ssh 192.168.0.130 "yum install nfs-utils; mkdir -p /mnt/backups" » utg.sh
 
echo $"expect (yes/no)" » utg.sh

echo $"send yes\r " » utg.sh
echo expect password: » utg.sh
echo send "1234\r " » utg.sh
echo interact » utg.sh
chmod +x utg.sh

####### Edit misstakes in commands
sed -i 's/send /send "/' utg.sh
sed -i 's/r /r"/' utg.sh
sed -i 's/mkdir"/mkdir /' utg.sh
sed -i 's/yum/"yum/' utg.sh
#sed -i 's/backups/backups"/' utg.sh
sed -i 's! /mnt/backups! /mnt/backups"!' utg.sh
./utg.sh

#############Creating file 2 for commands to nfs_client
rm -rf mount.sh

touch mount.sh

echo "#!/usr/bin/expect -f" » mount.sh
echo spawn ssh 192.168.0.130 "mount -t nfs 192.168.0.129:/mnt/backups /mnt/backups" » mount.sh
echo expect password: » mount.sh
echo send "1234\r " » mount.sh
echo interact » mount.sh
chmod +x mount.sh

####### Edit missatakes in commands
sed -i 's/send /send "/' mount.sh
sed -i 's/r /r"/' mount.sh
sed -i 's! /mnt/backups! /mnt/backups"!' utg.sh

./mount.sh
 
