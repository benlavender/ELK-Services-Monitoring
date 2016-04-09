#!/bin/sh

#Queries for ES, KB4, and LS instances, which will perform a number of checks and such if any failures occur then relative alerts will be submitted by email using the http://mailutils.org/ GNU tools.

#Settings for email submissions:
#You need to change these for your mails:
RECSMTP=<your_recipient@domain.com>
RELAYSVR=<smtp_relay_if_needed>
FROMSMTP=<sender@domain.com>

#ES HTTP, init.d and netstat checks

curl -s --head  --request GET http://localhost:9200 | grep -i "200"> /dev/null || {
mail -s "ES: HTTP Alert from LDS-Syslog" -r $FROMSMTP $RECSMTP<<EOF
No HTTP response from ES on http://localhost:9200

Come check

EOF
}

ESservice="service elasticsearch status"
if $ESservice | grep -i --quiet "elasticsearch is running"; then
echo "ES running"> /dev/null
else {
mail -s "ES: init.d alert from LDS-Syslog" -r $FROMSMTP $RECSMTP<<EOF
/etc/init.d/elasticsearch is not running

Come check

EOF
}

fi

ESportbind="netstat -ant"
if $ESportbind | grep -i --quiet "127.0.0.1:9200"; then
echo "9200 bound"> /dev/null
else {
mail -s "ES: IP alert from LDS-Syslog" -r $FROMSMTP $RECSMTP<<EOF
Nothing bound to TCP|:9200

Come check

EOF
}

fi

#LS init.d and netstat checks

LSservice="service logstash status"
if $LSservice | grep --quiet "logstash is running"; then
echo "LS running"> /dev/null
else {
mail -s "LS: init.d alert from LDS-Syslog" -r $FROMSMTP $RECSMTP<<EOF
/etc/init.d/logstash is not running

Come check

EOF
}

fi

LSportbind="netstat -anu"
if $LSportbind | grep --quiet ":5000"; then
echo "5000 bound"> /dev/null
else {
mail -s "LS: IP alert from LDS-Syslog" -r $FROMSMTP $RECSMTP<<EOF
Nothing bound to UDP|:5000

Come check

EOF
}

fi

#KB4 HTTP and init.d and netstat checks

KBservice="service kibana status"
if $KBservice | grep -i --quiet "kibana is running"; then
echo "KB running"> /dev/null
else {
mail -s "KB: init.d alert from LDS-Syslog" -r $FROMSMTP $RECSMTP<<EOF
/etc/init.d/kibana is not running

Come check

EOF
}

fi

curl -s --head  --request GET http://localhost:80 | grep -i "401"> /dev/null || { mail -s "KB4: HTTP Alert from LDS-Syslog" -r $FROMSMTP $RECSMTP<<EOF
No expected HTTP response from Kibana on http://localhost:80 or NGINX is not up

Come check

EOF

}

KBportbind="netstat -ant"
if $KBportbind | grep --quiet ":80"; then
echo "80 bound"> /dev/null
else {
mail -s "KB: IP alert from LDS-Syslog" -r $FROMSMTP $RECSMTP<<EOF

Nothing bound to TCP|:80

Come check

EOF
}

fi
