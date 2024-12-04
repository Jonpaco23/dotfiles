curl -s "wttr.in/?format=%c%t\n" | sed 's/ //1'

# | sed 's/+//g; s/C/C /g; s/ //g'