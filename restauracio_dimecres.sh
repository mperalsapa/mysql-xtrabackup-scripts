#!/bin/bash
#----------------------
# Modificar dades aqui
#----------------------
usuari=root
passwd=P@t@t@m10
db=bd_hotels
#----------------------

# Variables
## Missatges
mErrSet="No has introduit una setmana, exemple d'execucio: $0 15 /backups"
mErrDir="No has introduit un directori de backups valid, exemple d'execucio: $0 15 /backups"
## Dates actuals
data=$(date '+%Y-%m-%d_%H-%M-%S')
dia=$(date '+%d')
mes=$(date '+%m')
any=$(date '+%Y')
NDSetmana=$(date '+%u')
dSetmana=$(date '+%a')
setm=$(date '+%U')
## Dates d'anterior dia
aData=$(date -d "-1 day")
aDia=$(date -d "$aData" '+%d')
aMes=$(date -d "$aData" '+%m')
aAny=$(date -d "$aData" '+%Y')
aNDSetmana=$(date -d "$aData" '+%u')
aDSetmana=$(date -d "$aData" '+%a')
aSetm=$(date -d "$aData" '+%U')
## Directoris
backupDir=$1
setBackupDir=$1\/$any\/$2
backupSencer="$setBackupDir/com_Mon"
backupDm="$setBackupDir/inc_Tue"
backupDx="$setBackupDir/inc_Wed"

# Mostrar informacio a l'usuari
echo "Dades d'access"
echo "Usuari: $usuari"
echo "Contrasenya: $passwd"
echo "Base de dades: $db"
echo "Directori de backups: $backupDir"

if [ $(id -u) = 0 ]
then
	if [ -d $1 ]
	then
		if [ -d $setBackupDir ]
		then
			echo "Directori: "$1" Setmana: "$2
			# Parem el servei mysql
			sudo systemctl stop mysql
			# Preparem la copia sencera
			sudo xtrabackup --prepare --apply-log-only --target-dir=$backupSencer
			# Preparem la copia incremental del dimarts
			sudo xtrabackup --prepare --apply-log-only --target-dir=$backupSencer --incremental-dir=$backupDm
			# Preparem la copia incremental del dimecres
			sudo xtrabackup --prepare --apply-log-only --target-dir=$backupSencer --incremental-dir=$backupDx
			# Preparem la copia sencera pels logs
			sudo xtrabackup --prepare --target-dir=$backupSencer
			# Esborrem la carpeta de dades de mysql i restaurem les copies desitjades
			sudo rm -r /var/lib/mysql
			sudo mkdir /var/lib/mysql
			sudo xtrabackup --copy-back --target-dir=$backupSencer --datadir=/var/lib/mysql
			sudo chown -R mysql:mysql /var/lib/mysql
			# Iniciem el servei mysql
			sudo systemctl start mysql
		else
			echo $mErrSet
		fi
	else
		echo $mErrDir
	fi
else
	echo "No has executat com a root."
fi