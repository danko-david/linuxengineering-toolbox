#!/bin/bash

RES=$("$@" 2>&1)
EXIT_STATUS=$?

if [[ -z $SUBJECT ]]; then
	SUBJECT="Mailme Task $@ failed"
fi;

if [[ -n $RES ]] || [ $EXIT_STATUS -ne 0 ]; then

	{
		echo "=== Mailme task report ==="
		echo -n "At host: "
		hostname

		echo -ne "At time: "
		date -u "+%Y-%m-%d %H:%M:%SU"

		echo -ne "Program and arguments: $@"

		echo -ne "\nProgram exit status: $EXIT_STATUS"

		echo -ne "\nProgram output (both stdout and stderr):\n"
		echo "$RES"
	}| mail -s "$SUBJECT" "$EMAIL_ADDRESS"
# | cat
fi
