# Use an official Java runtime as a parent image
FROM openjdk:17-slim-buster

# Set the working directory in the container to /usr/src
WORKDIR /usr/src

# Install git and jq
RUN apt-get update && apt-get install -y git jq curl htop vim

# Clone the Synthea repo
RUN git clone https://github.com/synthetichealth/synthea.git

# Change the working directory to the synthea directory
WORKDIR /usr/src/synthea

# Copy the post_json_copy.sh script into the container
COPY post_fhir.sh /usr/src/synthea/

# Give execution permissions to the script
RUN chmod +x /usr/src/synthea/post_fhir.sh

# Run Synthea when the container launches
CMD ["tail -f /dev/null"]
