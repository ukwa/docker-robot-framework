#!/bin/bash

set -a # automatically export all variables e.g. when sourcing env files

ENVIRON=$1 # dev/beta/prod specified in run
ENV_DIR="${ENV_DIR:-${HOME}/gitlab/ukwa-services-env}" # where the files containing env vars are stored

if ! [[ ${ENVIRON} =~ dev|beta|prod ]]; then
        echo "ERROR: Script $0 requires environment argument (dev|beta|prod)"
        exit
fi

if [[ ${ENVIRON} == 'dev' ]]; then
	# Set up the dev.webarchive.org.uk vars
        source ${ENV_DIR}/dev.env
        # We can run the destructive tests here:
        export EXTRA_TESTS="/tests_destructive"
elif [[ ${ENVIRON} == 'beta' ]]; then
	# Set up the beta.webarchive.org.uk vars
        source ${ENV_DIR}/beta.env
elif [[ ${ENVIRON} == 'prod' ]]; then
	# Set up the www.webarchive.org.uk vars
        source ${ENV_DIR}/prod.env
else
        export PUSH_GATEWAY=monitor.wa.bl.uk:9091
	echo "ERROR"
	exit
fi

# Add environ tag to job name for Prometheus metrics:
export PROMETHEUS_JOB_NAME=service_tests_${ENVIRON}

# Set a username variable
export USER_ID="$(id -u)"

# -- Build the image:
echo Building test image to ensure everything is up to date...

docker-compose build robot

# -- Run the tests:
echo Running tests using USER_ID=$USER_ID, TEST_HOST=$TEST_HOST
echo WARNING! Tests will fail if the TEST_HOST variable has a trailing slash!

# -- Allow you to specify which tests are run (if no second arg, runs all tests):
docker-compose run robot $2 $3 $4 $5 $6 $7

