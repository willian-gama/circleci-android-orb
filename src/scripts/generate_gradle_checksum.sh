#!/bin/bash

RESULT_FILE="$FILENAME"

if [ -f "$RESULT_FILE" ]; then
  rm "$RESULT_FILE"
fi

touch "$RESULT_FILE"

FILES=()
while read -r -d ''; do
	FILES+=("$REPLY")
done < <(find . -type f \( -name "build.gradle*" -o -name "gradle-wrapper.properties" -o -name "settings.gradle*" \) -print0)

for FILE in "${FILES[@]}"; do
   CHECKSUM_FILE=$(openssl md5 "$FILE" | awk '{print $2}')
   echo "$FILE - $CHECKSUM_FILE"
   echo "$CHECKSUM_FILE" >> "$RESULT_FILE"
done

sort "$RESULT_FILE" -o "$RESULT_FILE"