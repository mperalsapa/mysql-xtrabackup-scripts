# mysql-xtrabackup-scripts
Recopilacio d'scripts amb BASH per fer copies de seguretat.<br>
**AVIS: Aquestos scripts no respecten els backups, per tant, s'ha de guardar una copia d'aquestos en altre lloc.**
## Copia Lógica
Executar script logica amb ```./logica /directori/on/guardar/backup```

## Copia Completa i Incremental
Executar scripts amb ```./incremental_b.sh /directori/on/guardar/backup```
Afegir el script en el crontab, per que s'executi cada dia a les 22:00 excepte el dilluns, que s'executara a les 23:50
```
mperal@mpserver:~/scripts$ sudo crontab -l | tail -2
00 22 * * 2-7 /home/mperal/scripts/incremental_b.sh
50 23 * * 1 /home/mperal/scripts/incremental_b.sh
```

## Restaurar copia del dimecres
Executar el script amb la seguent comanda ```./restauracio_dimecres.sh /directori/dels/backups 16 ```
Aquest script agafa el dimecres de la setmana indicada en la comanda i el restaura en la base de dades. En l'script fem servir la setmana 16, la qual en l'any 2021 restauraria la copia del Dimecres 21 d'Abril.

## Provar script incremental
Per fer proves d'aquest script o d'altres funcions en un sistema linux, es pot fer servir un petit script com es [test_un_mes.sh](./test_un_mes.sh) que fa servir la funcio date i aplica una data al sistema. Aquest script aprofita aixo i el itera en un bucle per que augmenti 1 setmana, en aquest cas. D'aquesta manera podem provar que crea les carpetes necessaries i que despres podem restaurar-les amb el script del dimecres.

# Funcionament xtrabackup
Exemple de funcionament de la eina xtrabackup amb un esquema senzill d'un backup sencer, amb dos backups incrementals.

## Generar backups
### Full backup
```sudo xtrabackup --backup --target-dir=/backups/sencer```
### Incremental 1
```sudo xtrabackup --backup --target-dir=/backups/inc1 --incremental-basedir=/backups/sencer```

### Incremental 2
```sudo xtrabackup --backup --target-dir=/backups/inc2 --incremental-basedir=/backups/inc1```


## Restauracio
```sudo systemctl stop mysql```

### Prepare
#### Full
```sudo xtrabackup --prepare --apply-log-only --target-dir=/backups/sencer```

#### Incremental 1
```sudo xtrabackup --prepare --apply-log-only --target-dir=/backups/sencer --incremental-dir=/backups/inc1```

#### Incremental 2
En l'ultim incremental esborrem la opcio '--apply-log-only'<br>
```sudo xtrabackup --prepare --target-dir=/backups/sencer --incremental-dir=/backups/inc2```


### Copiar fitxers
Esborrem les dades del mysql, creem el directori de nou, amb xtrabackup copiem el backup, i finalment donem permisos i iniciem el servei MySQL.
```
sudo rm -r /var/lib/mysql
sudo mkdir /var/lib/mysql
sudo xtrabackup --copy-back --target-dir=/backups/sencer/ --datadir=/var/lib/mysql
sudo chown -R mysql:mysql /var/lib/mysql
sudo systemctl start mysql
```
