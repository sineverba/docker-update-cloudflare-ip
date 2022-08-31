#!/usr/bin/env sh
set -e
# Download file
wget https://www.cloudflare.com/ips-v4
# Remove all previos IP
sed -i '/#STARTCLOUDFLARE/,/#ENDCLOUDFLARE/{/#STARTCLOUDFLARE/!{/#ENDCLOUDFLARE/!d}}' config/configuration.yaml
# Read file and add new IPs
while read -r line
do
    sed -i "s|#STARTCLOUDFLARE|&\n    - $line|" config/configuration.yaml
done < ips-v4
# Remove Cloudflare file
rm ips-v4
