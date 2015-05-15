#!/bin/bash

OUTDIR=vendor/xiaomi/cancro
MAKEFILE=vendor.mk

(cat << EOF) > $MAKEFILE
PRODUCT_COPY_FILES += \\
EOF
LINEEND=" \\"
COUNT=`wc -l vendor.txt | awk {'print $1'}`
DISM=`egrep -c '(^#|^$)' vendor.txt`
COUNT=`expr $COUNT - $DISM`
for FILE in `egrep -v '(^#|^$)' vendor.txt`; do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
  # Split the file from the destination (format is "file[:destination]")
  OLDIFS=$IFS IFS=":" PARSING_ARRAY=($FILE) IFS=$OLDIFS
  if [[ ! "$FILE" =~ ^-.* ]]; then
    FILE=`echo ${PARSING_ARRAY[0]} | sed -e "s/^-//g"`
    DEST=${PARSING_ARRAY[1]}
    if [ -n "$DEST" ]; then
        FILE=$DEST
    fi
    echo "    $OUTDIR/proprietary/$FILE:system/$FILE$LINEEND" >> $MAKEFILE
  fi
done


