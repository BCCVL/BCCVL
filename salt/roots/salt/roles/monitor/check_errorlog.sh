#!/bin/sh

export PATH=/usr/local/bin:$PATH

from="monitor@bccvl.org.au"
support="g.weis@griffith.edu.au"

# loop through all log databases:
for dbname in dev-logs qa-logs prod-logs logs ; do
    # get the error log
    tmpfile=$(mktemp tmp_errorlog.XXXXXXX)
    get_errorlog.sh $dbname > "$tmpfile"

    # add email subject header
    sed -i '1iSubject: BCCVL System Alert\n' $tmpfile

    # email error log to user
    if ! grep "(0 rows)" $tmpfile; then
        cat $tmpfile | sendmail -f $from $support
    fi
    rm $tmpfile
done
