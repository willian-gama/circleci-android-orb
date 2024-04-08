#!/bin/sh

if [ -f "$FILE_NAME" ]; then
  rm "$FILE_NAME"
fi

touch "$FILE_NAME"

FILES=()
while read -r -d ''; do
	FILES+=("$REPLY")
done < <(find . -type f \( -name "build.gradle*" -o -name "gradle-wrapper.properties" -o -name "settings.gradle*" \) -print0)

for FILE in "${FILES[@]}"; do
   CHECKSUM_FILE=$(openssl md5 "$FILE" | awk '{print $2}')
   echo "$FILE - $CHECKSUM_FILE"
   echo "$CHECKSUM_FILE" >> "$FILE_NAME"
done

sort "$FILE_NAME" -o "$FILE_NAME"