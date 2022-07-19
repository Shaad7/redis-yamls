#!/bin/sh

script_name=${0##*/}
timestamp() {
    date +"%Y/%m/%d %T"
}
log() (
    type="$1" ;  msg="$2"
    echo "$(timestamp) [$script_name] [$type] $msg" | tee -a /tmp/log.txt
)

nodes_conf="aceb59975ca2f7538414c8dc0cb8e608f8823d99 10.244.0.121:6379@16379 myself,master - 0 1647406628282 1 connected 0-5460
a9cd2231dddbad3c761b2259a2c2d2acd53e24f3 10.244.0.114:6379@16379 master,fail? - 1647406630792 1647406628282 3 connected 10923-16383
f8b35d43d76e4a99833e1b3facb753cecdf52e6a 10.244.0.113:6379@16379 master,fail? - 1647406630792 1647406628282 2 connected 5461-10922
be579d5632168316c8654f3f0394101733ad4bde 10.244.0.119:6379@16379 myself,slave f8b35d43d76e4a99833e1b3facb753cecdf52e6a 1647406630190 1647406628282 2 connected
90dda56b9175b6be47fcacdd5c63c2703e9e724a 10.244.0.118:6379@16379 slave,fail? aceb59975ca2f7538414c8dc0cb8e608f8823d99 1647406630792 1647406628282 1 connected
beed088a12ad3ee604abc826b9ae14b8aef7f799 10.244.0.120:6379@16379 slave,fail? a9cd2231dddbad3c761b2259a2c2d2acd53e24f3 1647406629186 1647406628282 3 connected
"
# contains(string, substring)
#
# Returns 0 if the specified string contains the specified substring,
# otherwise returns 1.
contains() {
    string="$1"
    substring="$2"
    if test "${string#*$substring}" != "$string"
    then
        return 0    # $substring is in $string
    else
        return 1    # $substring is not in $string
    fi
}
getMasterID() {

    temp_file=$(mktemp)
    printf '%s\n' "$nodes_conf" >"$temp_file"

    while IFS= read -r line ; do
        if contains "$line" "myself" && contains "$line" "slave"; then
                echo "$line"
                echo "OK"

                current_slaves_master_id="$(echo "$line" | cut -d' ' -f4)"
                echo "--- $current_slaves_master_id"
               

                if [ "$(echo -n "$current_slaves_master_id" | wc -m)" -eq 40 ] ; then
                    log "RECOVER" "My Master ID is : $current_slaves_master_id"
                else
                    log "PANIC" "MASTER ID : $current_slaves_master_id. Wrong Info"
                fi
        fi
    done <"$temp_file"

    rm "$temp_file"

}

getMasterID