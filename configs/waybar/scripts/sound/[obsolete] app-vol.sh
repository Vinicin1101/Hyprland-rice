#!/bin/bash

chrome_is_running=$(wpctl status | grep 'Google')

if [[ ${#chrome_is_running} -gt 1 ]]; then
	chromeID=$(wpctl status | grep 'Google' | awk '{print $1}' | tail -n 1 | sed 's/.$//')
	$(wpctl set-volume $chromeID $1)
	exit 0
elif [[ -z "$chrome_line" ]]; then
   exit 1
fi
