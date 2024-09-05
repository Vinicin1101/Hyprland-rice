#!/bin/bash
echo "{\"text\": \"$(sensors | awk '{ print $2 }' | grep "°C" | sed -n 's/+//g;p'| sed -n 's/\.[0-9]*//g;p'| tail -n 1)\"}"
