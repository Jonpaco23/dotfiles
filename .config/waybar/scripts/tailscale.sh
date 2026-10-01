#!/usr/bin/env bash

STATUS_KEY="BackendState"
RUNNING="Running"

tailscale_status () {
    status="$(tailscale status --json | jq -r --arg key "$STATUS_KEY" '.[$key]')"
    if [ "$status" = "$RUNNING" ]; then
        return 0
    fi
    return 1
}

toggle_status () {
    if tailscale_status; then
        tailscale down
    else
        tailscale up --accept-dns --accept-routes
    fi
    sleep 3
}

case $1 in
    --status)
        if tailscale_status; then
            T=${2:-"green"}
            F=${3:-"red"}
            tailscale status --json | jq -c --arg T "$T" --arg F "$F" '
                (.Peer // {} | to_entries | map(.value)) as $peers |
                {
                    text: ([ $peers[] | select(.ExitNode == true) | .DNSName | split(".")[0] ] | first // ""),
                    class: "connected",
                    alt: "connected",
                    tooltip: ([ $peers[] | "<span color=\"\((if .Online then $T else $F end))\">\(.DNSName | split(".")[0])</span>" ] | join("\r"))
                }
            '
        else
            echo "{\"text\":\"\",\"class\":\"stopped\",\"alt\":\"stopped\", \"tooltip\": \"The VPN is not active.\"}"
        fi
    ;;
    --toggle)
        toggle_status
    ;;
esac

