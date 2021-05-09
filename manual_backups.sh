# backups manual
sudo xtrabackup --backup --target-dir=/backups/full
sudo xtrabackup --backup --target-dir=/backups/inc1 --incremental-basedir=/backups/full
sudo xtrabackup --backup --target-dir=/backups/inc2 --incremental-basedir=/backups/inc1

# preparar backups manual i aplicar-los
sudo systemctl stop mysql
sudo xtrabackup --prepare --apply-log-only --target-dir=/backups/2021/16/com_Mon
sudo xtrabackup --prepare --apply-log-only --target-dir=/backups/2021/16/com_Mon --incremental-dir=/backups/2021/16/inc_Tue
sudo xtrabackup --prepare --target-dir=/backups/2021/16/com_Mon --incremental-dir=/backups/2021/16/inc_Wed
sudo rm -r /var/lib/mysql
sudo mkdir /var/lib/mysql
sudo xtrabackup --copy-back --target-dir=/backups/2021/16/com_Mon --datadir=/var/lib/mysql
sudo chown -R mysql:mysql /var/lib/mysql
sudo systemctl start mysql

# restaurar copia manual en directori /root/scripts?
sudo systemctl stop mysql
sudo rm -r /backups/*
sudo rm -r /var/lib/mysql
sudo mkdir /var/lib/mysql
sudo xtrabackup --copy-back --target-dir=backups/full --datadir=/var/lib/mysql
sudo chown -R mysql:mysql /var/lib/mysql
sudo systemctl start mysql
sudo ./test_mes.sh
