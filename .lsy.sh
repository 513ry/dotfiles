#!/usr/bin/bash

declare -ir EXIT_SUCCESS=0

declare -r DAY_DATE_FORMAT=${DATE_FORMAT:0:6}

# Get date in format [M]:[D]:[H]:[M] or word today/yesterday/week/month
if [ -z $1 ]; then
	ls $YUNK | grep -v .meta
	exit $EXIT_SUCCESS
fi

date=$1

if [ $date == 'today' ]; then
	date="$(date +$DAY_DATE_FORMAT)"
elif [ $date == 'yesterday' ]; then
	date="$(date -d yesterday +$DAY_DATE_FORMAT)"
fi

# Prettify date string
declare pretty_date
for ((i = 0; i < ${#date}; i++)); do
	pretty_date="$pretty_date${date:$i:1}"
	if [ $((i % 2)) -eq 1 ] && [ $i -ne $((${#date} - 1)) ]; then
		pretty_date="$pretty_date."
	fi
done

echo "Files junked at $pretty_date"

ls $YUNK | grep $date | grep -v .meta
