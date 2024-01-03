#!/bin/bash
echo "Starting to post JSON bundles - "
path="/usr/src/synthea/output/fhir/*.json"  # Reading Synthea FHIR bundles from /output/fhir directory
URL="http://host.docker.internal:8000/"  # Assuming FHIR server is running on localhost:8000
cred="YWRtaW46cGFzc3dvcmQ=" #base64 encoded creds
counter=0;
for f in $path; do 
    if [ -f "$f" ]; then  # Checking if it's a file
        resource_count=$(jq '.entry | length' $f)
        echo "Posting file: $f with $resource_count resources"
        { time curl -X POST -H "Content-Type: application/json" -H 'Authorization: Basic '$cred'' \
          $URL \
          -d @$f; } 2>&1 | sed -n 's/real/Time:/p'
          let counter++
          echo
    fi 
done
echo "Posted $counter Bundles in total."
