#!/bin/bash

# Note: Make sure to install the following dependencies before running this script:
# - Amass
# - httprobe
# - waybackurls
# - kxss

# Function to print g0ts
print_g0ts() {
cat << "EOF"
      _,---.       _.---.,_      ,--.--------.     ,-,--.
  _.='.'-,  \    .'  - , `.-,   /==/,  -   , -\  ,-.'-  _\
 /==.'-     /   / -  ,  ,_\==\  \==\.-.  - ,-./ /==/_ ,_.'
/==/ -   .-'   |     .=.   |==|  `--`\==\- \    \==\  \
|==|_   /_,-.  | -  :=; : _|==|       \==\_ \    \==\ -\
|==|  , \_.' ) |     `=` , |==|       |==|- |    _\==\ ,\
\==\-  ,    (   \ _,    - /==/        |==|, |   /==/\/ _ |
 /==/ _  ,  /    `.   - .`=.`         /==/ -/   \==\ - , /
 `--`------'       ``--'--'           `--`--`    `--`---'
EOF
}

# Print g0ts
print_g0ts

echo "Script by g0ts"

# Define the domain and output prefix
domain="www.tesla.com"
output_prefix="domains_$domain"

# Execute the amass command and save the output to a file
amass enum --passive -d "$domain" -o "${output_prefix}"

# Filter the resolved domains and save them to a txt file
cat "${output_prefix}" | filter-resolved | tee "${output_prefix}.txt"

# Use httprobe to check the availability of HTTP/HTTPS on ports 81 and 8443
cat "${output_prefix}.txt" | ~/go/bin/httprobe -p http:81 -p https:8443 | tee httprobe_output.txt

# Use waybackurls to retrieve URLs from the Wayback Machine
cat httprobe_output.txt | waybackurls | tee wayback_urls.txt

# Check for XSS using kxss and save the results to xss.txt
cat wayback_urls.txt | kxss | tee xss.txt

# Display a completion message when the script finishes executing
echo "Script execution completed."
