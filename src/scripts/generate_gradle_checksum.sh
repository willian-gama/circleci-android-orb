#!/bin/sh

FILE_RESULT=$FILE_NAME

if [ -f "$FILE_RESULT" ]; then
  rm "$FILE_RESULT"
fi

touch "$FILE_RESULT"

FILES=()
while read -r -d ''; do
	FILES+=("$REPLY")
done < <(find . -type f \( -name "build.gradle*" -o -name "gradle-wrapper.properties" -o -name "settings.gradle*" \) -print0)

for FILE in "${FILES[@]}"; do
   CHECKSUM_FILE=$(openssl md5 "$FILE" | awk '{print $2}')
   echo "$FILE - $CHECKSUM_FILE"
   echo "$CHECKSUM_FILE" >> "$FILE_RESULT"
done

sort "$FILE_RESULT" -o "$FILE_RESULT"