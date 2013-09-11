    
#!/bin/bash
    
#
    
# Script to notify admin user if Linux,FreeBSD load crossed certain limit
    
# It will send an email notification to admin.
    
#
     
    
# Set up limit below
    
NOTIFY="6.0"
     
    
# admin user email id
    
EMAIL="root"
     
    
# Subject for email
    
SUBJECT="Alert $(hostname) load average"
     
    
# -----------------------------------------------------------------
     
    
# Os Specifc tweaks do not change anything below ;)
    
OS="$(uname)"
    
TRUE="1"
    
if [ "$OS" == "FreeBSD" ]; then
    
TEMPFILE="$(mktemp /tmp/$(basename $0).tmp.XXX)"
    
FTEXT='load averages:'
    
elif [ "$OS" == "Linux" ]; then
    
TEMPFILE="$(mktemp)"
    
FTEXT='load averages:'
    
fi
     
     
    
# get first 5 min load
    
F5M="$(uptime | awk -F "$FTEXT" '{ print $2 }' | cut -d, -f1) | sed 's/ //g'"
    
# 10 min
    
F10M="$(uptime | awk -F "$FTEXT" '{ print $2 }' | cut -d, -f2) | sed 's/ //g'"
    
# 15 min
    
F15M="$(uptime | awk -F "$FTEXT" '{ print $2 }' | cut -d, -f3) | sed 's/ //g'"
     
    
# mail or sms message
    
echo "Load average Crossed allowed limit $NOTIFY." >> $TEMPFILE
    
echo "Hostname: $(hostname)" >> $TEMPFILE
    
echo "Local Date & Time : $(date)" >> $TEMPFILE
     
    
# Look if it crossed limit
    
# compare it with last 15 min load average
    
RESULT=$(echo "$F15M > $NOTIFY" | bc)
     
    
# if so send an email
    
if [ "$RESULT" == "$TRUE" ]; then
    
mail -s "$SUBJECT" "$EMAIL" < $TEMPFILE
    
fi
     
    
# remove file
    
rm -f $TEMPFILE
