#!/bin/bash
echo "Starting to post JSON bundles - "
path="/usr/src/synthea/output/fhir/*.json"  # Adjusted the path to the container's directory
URL="http://host.docker.internal:8000/"  # Assuming this is your FHIR server URL

for f in $path; do 
    if [ -f "$f" ]; then  # Checking if it's a file
        resource_count=$(jq '.entry | length' $f)
        echo "Posting file: $f with $resource_count resources"
        { time curl -X POST -H "Content-Type: application/json" -H 'Authorization: Basic YWRtaW46cGFzc3dvcmQ=' \
          $URL \
          -d @$f; } 2>&1 | sed -n 's/real/Time:/p'
          echo
    fi 
done
