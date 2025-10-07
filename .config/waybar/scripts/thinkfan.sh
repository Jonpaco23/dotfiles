#!/usr/bin/env bash

set -o errexit -o pipefail -o nounset

nargs=$#

fan="/proc/acpi/ibm/fan"

if [ -f "$fan" ]
   then
    status="$(grep status: "$fan" | sed -E 's/status:\s+//')"
    speed="$(grep speed: "$fan" | sed -E 's/speed:\s+//')"
    level="$(grep level: "$fan" | sed -E 's/level:\s+//')"
fi

# echo "$status"
# echo "$speed"
# echo "$level"

statussym=$(echo $status | sed -e 's/enabled/🟢/' -e 's/disabled/🔴/')
levelsym="<b>"$(echo $level | sed -e 's/auto/A/' -e 's/disengaged/D/' -e 's/full-speed/F/')"</b>"

function build_text {
text=""
tooltip=""
first="yes"

    for a in "$@"
    do
        if [[ "$first" == "no" ]]
        then
            text="$text | "
            tooltip="$tooltip\n"
        fi
        if [[ "$a" == "status" ]]
        then
            text="$text$statussym"
            tooltip="$tooltip$a: $status"
        elif [[ "$a" == "speed" ]]
        then
            text="$text$speed RPM"
            tooltip="$tooltip$a: $speed RPM"
        elif [[ "$a" == "level" ]]
        then
            text="$text$levelsym"
            tooltip="$tooltip$a: $level"
        fi
        first="no"
    done
}

build_text "$@"
tmp="$text"
build_text "status" "speed" "level"

echo "{\"text\": \"$tmp\", \"tooltip\": \"$tooltip\"}"
