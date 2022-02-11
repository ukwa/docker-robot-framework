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
        source ~/gitlab/ukwa-services-env/access/website/dev.env
        export HOST=https://dev:${DEV_WEBSITE_PW}@dev.webarchive.org.uk
        export HOST_NO_AUTH=https://dev.webarchive.org.uk
        export PUSH_GATEWAY=monitor-pushgateway.dapi.wa.bl.uk:80
        # We can run the destructive tests here:
        export EXTRA_TESTS="/tests_destructive"
elif [[ ${ENVIRON} == 'beta' ]]; then
	# Set up the beta.webarchive.org.uk vars
        source ~/gitlab/ukwa-services-env/access/website/beta.env
        export HOST=https://beta.webarchive.org.uk
        export HOST_NO_AUTH=$HOST
        export PUSH_GATEWAY=monitor-pushgateway.bapi.wa.bl.uk:80
elif [[ ${ENVIRON} == 'prod' ]]; then
	# Set up the www.webarchive.org.uk vars
        source ~/gitlab/ukwa-services-env/access/website/prod.env
        export HOST=https://www.webarchive.org.uk
        #export HOST=http://website.api.wa.bl.uk
        #export HOST=http://prod1.n45.wa.bl.uk
        export HOST_NO_AUTH=$HOST
        export PUSH_GATEWAY=monitor-pushgateway.api.wa.bl.uk:80
else
        export PUSH_GATEWAY=monitor.wa.bl.uk:9091
	echo "ERROR"
	exit
fi

# Add environ tag to job name for Prometheus metrics:
export PROMETHEUS_JOB_NAME=access_website_rf_tests_${ENVIRON}

# Run as current user to avoid reports having inappropriate permissions:
export UID=`$(id -u)`

# -- Run the tests:
echo Running tests using UID = $UID, HOST = $HOST
echo WARNING! Tests will fail if the HOST variable has a trailing slash!

docker-compose run robot 

