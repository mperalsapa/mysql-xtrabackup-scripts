#!/bin/bash
for i in {19..25}
do
	date +%Y%m%d -s "202104$i" && $1
	./incremental_b.sh /backups/
done
