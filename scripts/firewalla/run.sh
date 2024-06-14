#!/bin/bash

# This script sends POST requests to the my.firewalla.com Rules API to block regions.
# All regions are located in regions.json.

# SELECTED_BOX_ID and __TOKEN_KEEP_SECRET__ can be found under 'Storage' -> 'Local Storage' in browser's developer menu.
# BOX=<fa5e0cf5-ds2...>
# TOKEN=<eydsjfkjhasdfD82asdfhgg.eyaksF...>
source .env

echo X-Firewalla-ID: "$BOX"
echo Authorization: "$TOKEN"
echo -n "Press any key to continue."
read -r

# Create a rule to block a region.
# $1: region code i.e. RU, YU, GB...
create_rule() {
    echo "{\"cronTime\":\"\",\"duration\":\"\",\"expire\":\"\",\"action\":\"block\",\"notes\":\"\",\"type\":\"country\",\"remotePort\":\"\",\"targetList\":\"0\",\"target\":$1,\"autoDeleteWhenExpires\":0,\"tag\":[]}"
}

# Extract the keys from the dictionary.
keys=$(cat regions.json | jq 'keys[]')

# Progression counter.
counter=0

# Total amount of rules to be created.
total=$(echo "$keys" | wc -l | xargs)

# Get the value of a region key.
get_region() {
	cat regions.json | jq ".[$1]"
}

for key in $keys; do
	# Increment progression counter.
	counter=$((counter+1))

	# The API will stop working if the United States (where it is hosted) are blocked.
	if [[ $key == "US" ]]; then
		continue
	fi

	# Show which rule is being created.
	echo "Creating: $counter/$total $key:$(get_region $key)"

	# Create the rule string for the given region.
	rule=$(create_rule $key)

    # Send the rules to the Firewalla API.
    response=$(curl 'https://my.firewalla.com/v1/rule/batchCreate' \
    -X 'POST' \
    -H 'Content-Type: application/json; charset=utf-8' \
    -H 'Accept: application/json' \
    -H "Authorization: Bearer $TOKEN" \
    -H 'Sec-Fetch-Site: same-origin' \
    -H 'Accept-Language: en-GB,en;q=0.9' \
    -H 'Cache-Control: no-cache' \
    -H 'Sec-Fetch-Mode: cors' \
    -H 'Accept-Encoding: gzip, deflate, br' \
    -H 'Origin: https://my.firewalla.com' \
    -H 'Referer: https://my.firewalla.com/' \
    -H 'Content-Length: 228' \
    -H 'Connection: keep-alive' \
    -H 'Host: my.firewalla.com' \
    -H 'Sec-Fetch-Dest: empty' \
    -H "X-Firewalla-ID: $BOX" \
	--data-binary "{\"rules\":[$rule],\"gids\":[\"$BOX\"]}")

	# If there was an error, show and log it.
	if [[ $? != 0 ]]; then 
		echo "Error creating rule for $key:$(get_region $key)" | tee -a firewalla.log
	fi	
	
	# Show the response and log it.
	echo "$response" | tee -a firewalla.log
	
done
