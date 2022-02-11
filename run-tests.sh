#!/bin/sh

set -a # automatically export all variables e.g. when sourcing env files

# read script environ argument
ENVIRON=$1
if ! [[ ${ENVIRON} =~ dev|beta|prod ]]; then
        echo "ERROR: Script $0 requires environment argument (dev|beta|prod)"
        exit
fi

if [[ ${ENVIRON} == 'dev' ]]; then
	# Set up the dev.webarchive.org.uk vars
        source ~/gitlab/ukwa-services-env/dev.env
        # We can run the destructive tests here:
        export EXTRA_TESTS="/tests_destructive"
elif [[ ${ENVIRON} == 'beta' ]]; then
	# Set up the beta.webarchive.org.uk vars
        source ~/gitlab/ukwa-services-env/beta.env
elif [[ ${ENVIRON} == 'prod' ]]; then
	# Set up the www.webarchive.org.uk vars
        source ~/gitlab/ukwa-services-env/prod.env
else
        export PUSH_GATEWAY=monitor.wa.bl.uk:9091
	echo "ERROR"
	exit
fi

# Add environ tag to job name for Prometheus metrics:
export PROMETHEUS_JOB_NAME=service_tests_${ENVIRON}

# Set a username variable
export USER_ID="$(id -u)"


# -- Run the tests:
echo Running tests using USER_ID=$USER_ID, TEST_HOST=$TEST_HOST
echo WARNING! Tests will fail if the TEST_HOST variable has a trailing slash!

docker-compose run robot 

