#!/bin/sh

support="g.weis@griffith.edu.au"

# get the error log
tmpfile=$(mktemp tmp_errorlog.XXXXXXX)
./get_errorlog.sh > "$tmpfile"

# add email subject header
sed -i '1iSubject: BCCVL System Alert\n' $tmpfile

# email error log to user
if ! grep "(0 rows)" $tmpfile; then
    cat $tmpfile | sendmail $support
fi
rm $tmpfile
