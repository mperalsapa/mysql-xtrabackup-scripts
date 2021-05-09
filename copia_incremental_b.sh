#!/bin/bash
#----------------------
# Modificar dades aqui
#----------------------
usuari=root
passwd=P@t@t@m10
db=bd_hotels
#----------------------

# altres variables
backupDir=$1
missatgeExisteix="Sembla que ja existeix el directori per la copia que tocava, compte amb el que fas."
# dates actuals
data=$(date '+%Y-%m-%d_%H-%M-%S')
dia=$(date '+%d')
mes=$(date '+%m')
any=$(date '+%Y')
NDSetmana=$(date '+%u')
dSetmana=$(date '+%a')
setm=$(date '+%V')

# dates d'anterior dia
aData=$(date -d "-1 day")
aDia=$(date -d "$aData" '+%d')
aMes=$(date -d "$aData" '+%m')
aAny=$(date -d "$aData" '+%Y')
aNDSetmana=$(date -d "$aData" '+%u')
aDSetmana=$(date -d "$aData" '+%a')
aSetm=$(date -d "$aData" '+%V')

# directoris
backupsDir=$backupDir\/$any\/$setm

# Mostrar informacio a l'usuari
echo "Dades d'access"
echo "Usuari: $usuari"
echo "Contrasenya: $passwd"
echo "Base de dades: $db"
echo "Directori de backups: $backupDir"

if [ $(id -u) = 0 ]
then
	if [ -d "$backupDir" ] # Comprovacio de que el directori introduit existeix
	then
		if [ ! -d "$backupsDir" ] # Comprovacio de que el directori on toquen les copies d'aquesta setmana existeix
		then
			mkdir -p $backupsDir # Creem el directori si no existeix
		fi
		if [ $NDSetmana = 1 ] # Comprovacio del dia que estem de la setmana
		then
			dirSencera=$backupsDir\/"com_Mon"
			echo "Copia d'avui: com_$dSetmana"
			echo "Directori sencer: $dirSencera"
			if [ -d $dirSencera ] # Comprovem si el directori de la copia d'avui existeix
			then
				echo $missatgeExisteix
			else
				mkdir $dirSencera
				xtrabackup --backup --target-dir=$dirSencera
				echo "xtrabackup --backup --target-dir=$dirSencera" >> log_incremental.txt
			fi
		else
			dirIncremental=$backupsDir\/"inc_"$dSetmana
			echo "Copia d'avui: inc_$dSetmana"
			echo "Directori sencer: $dirIncremental"
			if [ -d $dirIncremental ]
			then
				echo $missatgeExisteix
			else
				if [ $NDSetmana = 2 ]
				then
					aDirIncremental=$backupsDir\/"com_Mon"
				else
					aDirIncremental=$backupsDir\/"inc_"$aDSetmana
				fi
				mkdir $dirIncremental

				xtrabackup --backup --user=$usuari --password=$passwd --target-dir=$dirIncremental --incremental-basedir=$aDirIncremental
				echo "xtrabackup --backup --user=$usuari --password=$passwd --target-dir=$dirIncremental --incremental-basedir=$aDirIncremental" >> log_incremental.txt
			fi
		fi
	else
		echo "No has introduit un directori destí valid. Per exemple: $0 /backups"
	fi
fi
