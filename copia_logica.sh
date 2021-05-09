#!/bin/bash
#----------------------
# Modificar dades aqui
#----------------------
usuari=root
passwd=P@t@t@m10
db=bd_hotels
#----------------------

# altres variables
backupdir=$1
data=$(date '+%Y-%m-%d_%H-%M-%S')


echo "Dades d'access"
echo "Usuari: $usuari"
echo "Contrasenya: $passwd"
echo "Base de dades: $db"
echo "Directori de backup: $backupdir"

if [ $(id -u) = 0 ]
then
	if [ -d "$backupdir" ]
	then
		sudo mysqldump -u root db_hotels > $backupdir/$data\_$db
	else
		echo "No has introduit un directori destí valid. Per exemple: $0 /backups"
	fi
fi