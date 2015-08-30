me="dev-logs"
username="postgres"

# Look for any error log with priority less than 4 for the last 6 minutes,
# as this script is run every 5 minutes .

sudo -u $username psql $dbname << EOF

select devicereportedtime, facility, priority, fromhost, syslogtag, message from systemevents where  devicereportedtime > (now() - interval '6 minutes') and priority < 4 and (facility = 1 or (facility >= 16 and facility <= 23));

EOF
