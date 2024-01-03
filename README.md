#TL;DR
Building the docker container
```
docker build -t synthea:latest .
docker-compose up -d
docker [container_name] exec ./run_synthea -p 100
docker [container_name] exec ./post_fhir.sh
```


# Synthea<sup>TM</sup> Patient Generator by Smile Digital Health ![Build Status](https://github.com/synthetichealth/synthea/workflows/.github/workflows/ci-build-test.yml/badge.svg?branch=master) [![codecov](https://codecov.io/gh/synthetichealth/synthea/branch/master/graph/badge.svg)](https://codecov.io/gh/synthetichealth/synthea)

Synthea<sup>TM</sup> is a Synthetic Patient Population Simulator. The goal is to output synthetic, realistic (but not real), patient data and associated health records in a variety of formats.

Read our [wiki](https://github.com/synthetichealth/synthea/wiki) and [Frequently Asked Questions](https://github.com/synthetichealth/synthea/wiki/Frequently-Asked-Questions) for more information.

Currently, Synthea<sup>TM</sup> features include:
- Birth to Death Lifecycle
- Configuration-based statistics and demographics (defaults with Massachusetts Census data)
- Modular Rule System
  - Drop in [Generic Modules](https://github.com/synthetichealth/synthea/wiki/Generic-Module-Framework)
  - Custom Java rules modules for additional capabilities
- Primary Care Encounters, Emergency Room Encounters, and Symptom-Driven Encounters
- Conditions, Allergies, Medications, Vaccinations, Observations/Vitals, Labs, Procedures, CarePlans
- Formats
  - HL7 FHIR (R4, STU3 v3.0.1, and DSTU2 v1.0.2)
  - Bulk FHIR in ndjson format (set `exporter.fhir.bulk_data = true` to activate)
  - C-CDA (set `exporter.ccda.export = true` to activate)
  - CSV (set `exporter.csv.export = true` to activate)
  - CPCDS (set `exporter.cpcds.export = true` to activate)
- Rendering Rules and Disease Modules with Graphviz


## Installation

**System Requirements:**
Synthea<sup>TM</sup> requires Java JDK 11 or newer. We strongly recommend using a Long-Term Support (LTS) release of Java, 11 or 17, as issues may occur with more recent non-LTS versions. The dockerfile included uses JDK17 as default.

<b>Docker</b> - You will need [Docker](https://docs.docker.com/engine/install/) and Docker-compose installed on your machine.

### Creating Docker container
Building the docker container
```
docker build -t synthea:latest .
```

Once the container is built you will be able to see the image in your local repository. You can run this to list all images - 
```
docker image list
```

### Initializing the container
Now that the image is built, we can use the docker-compose.yaml to create an instance of this image, i.e. run the container. We will use -d flag to run the container in detached mode.
```
docker-compose up -d
```
The docker-compose.yaml also allows you to map the output folder from the container to your local system.
You can change the path before the ':' as you would like.
/Users/murtuza/Documents/Home/synthea/fhir:/usr/src/synthea/output/fhir


### Changing the default properties
The default properties file values can be found at `src/main/resources/synthea.properties`.
By default, synthea does not generate CCDA, CPCDA, CSV, or Bulk FHIR (ndjson). You'll need to
adjust this file to activate these features.  See the [wiki](https://github.com/synthetichealth/synthea/wiki)
for more details, or use our [guided customizer tool](https://synthetichealth.github.io/spt/#/customizer).



## Generate Synthetic Patients
Generating 100 patients
```
docker [container_name] exec ./run_synthea -p 100
```

Command-line arguments may be provided to specify a state, city, population size, or seed for randomization.
```
docker [container_name] exec ./run_synthea [-s seed] [-p populationSize] [state [city]]
```

Full usage info can be printed by passing the `-h` option.
```
$ docker [container_name] exec ./run_synthea -h     

> Task :run
Usage: run_synthea [options] [state [city]]
Options: [-s seed]
         [-cs clinicianSeed]
         [-p populationSize]
         [-r referenceDate as YYYYMMDD]
         [-g gender]
         [-a minAge-maxAge]
         [-o overflowPopulation]
         [-c localConfigFilePath]
         [-d localModulesDirPath]
         [-i initialPopulationSnapshotPath]
         [-u updatedPopulationSnapshotPath]
         [-t updateTimePeriodInDays]
         [-f fixedRecordPath]
         [-k keepMatchingPatientsPath]
         [--config*=value]
          * any setting from src/main/resources/synthea.properties

Examples:
run_synthea Massachusetts
run_synthea Alaska Juneau
run_synthea -s 12345
run_synthea -p 1000
run_synthea -s 987 Washington Seattle
run_synthea -s 21 -p 100 Utah "Salt Lake City"
run_synthea -g M -a 60-65
run_synthea -p 10 --exporter.fhir.export=true
run_synthea --exporter.baseDirectory="./output_tx/" Texas
```

Some settings can be changed in `./synthea/src/main/resources/synthea.properties`.
Synthea<sup>TM</sup> will output patient records in C-CDA and FHIR formats in `./output`.

Output - 

![image](https://github.com/mmotorwala/synthea/assets/111542130/1c30a8bf-6dae-40cd-b7ab-3893aae823fd)


## POST/Upload Synthetic Patients to FHIR server
The root directory also contains a file called post_fhir.sh. This file gets pushed to the container during the build and can be invoked using the below command. 
```
docker [container_name] exec ./post_fhir.sh
```
The settings in the file assumes that you are running fhir server on localhost. You will need to change these 2 variables if you intend to POST FHIR bundles to a remote server. 
1. 'URL' is set to URL="http://host.docker.internal:8000/" -- which means the FHIR server is running on localhost. You may want to change it to something like - https://try.smilecdr.com/fhir-request based on your configuration.
2. Change the 'creds' variable to the login you have in your FHIR server. The default used is admin:password which is base64 encoded.

Output - 

![image](https://github.com/mmotorwala/synthea/assets/111542130/ba84c950-d217-470d-968c-13ff91545273)


# License

Copyright 2017-2023 The MITRE Corporation
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
