# backups manual
sudo xtrabackup --backup --target-dir=/backups/full
sudo xtrabackup --backup --target-dir=/backups/inc1 --incremental-basedir=/backups/full
sudo xtrabackup --backup --target-dir=/backups/inc2 --incremental-basedir=/backups/inc1

# preparar backups manual i aplicar-los
sudo systemctl stop mysql
sudo xtrabackup --prepare --apply-log-only --target-dir=/backups/full
sudo xtrabackup --prepare --apply-log-only --target-dir=/backups/full --incremental-dir=/backups/inc1
sudo xtrabackup --prepare --target-dir=/backups/full --incremental-dir=/backups/inc2
sudo rm -r /var/lib/mysql
sudo mkdir /var/lib/mysql
sudo xtrabackup --copy-back --target-dir=/backups/full --datadir=/var/lib/mysql
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
