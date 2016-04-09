### Introduction: 

Simple bash shell script for monitoring ELK Linux operations. 

This script is used for monitoring TCP/IP, RESTful, and Init jobs within the Elasticsearch-Logstash-Kibana (ELK) suite.

Tested on GNU bash 4.3.11 on Ubuntu 14.x.x but will work on most versions.

### Installation:

//Copy the ELK-Service-Monitoring.sh file to your directory where you can either run on-demand or as a cron job (recommended) and install mailutils:

$cd /usr/local/bin
$sudo chmod 755 ELK-Services-Monitoring.sh

//Check for bash issues (no harm to do this)

$bash -n ELK-Services-Monitoring.sh

//Add as a cron job:

$sudo crontab –e

//Add in:

00 08 * * * /usr/local/bin/ELK-Services-Monitoring.sh

//*Note this will set the job to run daily at 08:00 UST. Also confirm SMTP is allowed out through your firewall and also don’t forget to edit lines 7-9 for your mailings.

//For Debian based systems:
$sudo apt-get install mail-utils

//For RHL based systems:
$sudo yum install mail-utils
