#!/bin/bash
while :
do	
#	cd /srv/shiny-server
	Rscript /srv/shiny-server/pmem_backend.R
	sleep 120
done	

