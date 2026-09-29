#!/usr/bin/env bash

state_file="${TMPDIR:-/tmp}/tmux-telemetry.${UID}.state"

read_cpu() {
    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
    printf '%d %d\n' \
        $((user + nice + system + idle + iowait + irq + softirq + steal)) \
        $((idle + iowait))
}

read -r total1 idle1 < <(read_cpu)

if [[ -s $state_file ]] && read -r total0 idle0 < "$state_file" 2>/dev/null; then
    printf '%d %d\n' "$total1" "$idle1" > "$state_file"
    delta_total=$((total1 - total0))
    delta_idle=$((idle1 - idle0))
else
    printf '%d %d\n' "$total1" "$idle1" > "$state_file"
    sleep 5
    read -r total2 idle2 < <(read_cpu)
    delta_total=$((total2 - total1))
    delta_idle=$((idle2 - idle1))
fi

if (( delta_total > 0 )); then
    cpu=$((100 * (delta_total - delta_idle) / delta_total))
else
    cpu=0
fi

read -r mem_total mem_available < <(
    awk '
        /MemTotal:/     { total=$2 }
        /MemAvailable:/ { available=$2 }
        END { print total, available }
    ' /proc/meminfo
)

mem_used=$((mem_total - mem_available))
mem_pct=$((100 * mem_used / mem_total))

printf 'cpu %d%% ram %d%%' "$cpu" "$mem_pct"
