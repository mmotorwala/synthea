#!/bin/bash
#! created by Murtuza Motorwala
echo "Starting the utility"
echo "Enter your FHIR server's Base URL. If the server is running locally on docker then use - http://host.docker.internal:8000/"
read URL
echo "Enter the username"
read user
echo "Enter the password"
read password
echo "Starting to post JSON bundles - "
path="/usr/src/synthea/output/fhir/*.json"  #Reading Synthea FHIR bundles from /output/fhir directory
counter=0;
for f in $path; do 
    if [ -f "$f" ]; then  # Checking if it's a file
        resource_count=$(jq '.entry | length' $f)
        size=$(ls -lh $f | awk '{print "size:", $5}')
        echo "Posting file: $f with $resource_count resources and $size"
        { time curl -X POST -H "Content-Type: application/json" -u $user:$password \
          $URL \
          -d @$f; } 2>&1 | sed -n 's/real/Time:/p'
          let counter++
          echo
    fi 
done
echo "Posted $counter Bundles in total."
