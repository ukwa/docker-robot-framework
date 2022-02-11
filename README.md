# docker-robot-framework
A Dockerised Robot Framework execution environment, including dependencies and tests for the UK Web Archive services.

## Overall strategy

The goal of this piece of work is to cover our main service offering from an end-user perspective:

- All authenticated/restricted services. i.e. checking that anything that should not be public is not public.
- All distinct dependencies. i.e. Every distinct container or back-end service should have at least one test that checks it is working. e.g. one Wayback query checks that the CDX and WARCs are available, as well as the service containers.

Note that deep or complete coverage of the functionalities of each tool are not in scope. The underlying tools that deliver our services are expected to change over time, so this set of tests is intended to ensure that we can make those changes without breaking our user interfaces and APIs.

Wherever possible, these tests should be written to run safely on the live, production services, so we can use them to spot realistic errors and outages.  These are to go in a `tests` folder.  Any tests that manipulate data and so should only be run on BETA or DEV should be put in a folder called `tests_destructive` and only included in the test run on DEV/BETA.

Currently, some work has been done to establish automated testing our our core products, including [main website tests](https://github.com/ukwa/ukwa-services/tree/master/access/website_tests) an [ingest service tests](https://github.com/ukwa/ukwa-services/tree/master/ingest/ingest_tests).  The latter are the most recent and are somewhat better documented. These tests will be moved into this repository, see https://github.com/ukwa/docker-robot-framework/issues/1.

This is a system that is intended to be used to run tests on both developmetn and production systems, and post the results to Prometheus. It is also designed to be run against near-production versions by changing the `TEST_HOST` environment variable, so that it can be used to verify that a new version of a service passes the tests ahead of deployment to production.

Tests that can be safely run on production systems without modifying any important data are in the `tests` folder.

Any tests that may modify data are kept separate, placed in the `tests_destructive` folder. These should only run on BETA or DEV deployments.

Most of the depenendencies are handled by `ukwa/robot-framework` docker image on which this relies. This ensure the additional libraries to run web browsers and talks to Prometheus are in place.  Specifically, the container includes [RequestsLibrary](https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html) for testing APIs, and the [robotframework-browser](https://robotframework-browser.org/) library (based on [Playwright](https://playwright.dev/)) and  [SeleniumLibrary](http://robotframework.org/SeleniumLibrary/) for browser-driven tests. The Playwright-based library is a bit simpler to deploy than the Selenium-based on, so tests should be switched over to the former where possible.


## How to build and run these tests

The `deploy-ingest-tests.sh` shows how the script can be run as a Docker Service.  However, when developing tests, it can be easier to set up the necessary environment variables and run the tests using Docker Compose. e.g.

Set up the environment variables for running tests against the DEV service:

    source /mnt/nfs/config/gitlab/ukwa-services-env/dev.env

And now run the tests:

    docker-compose run robot

Which runs the tests and reports to the console, rather than running them as a background service (as `deploy-ingest-tests.sh` would).

Using Docker avoids having to install dependencies. If using Docker is not an option, you could set up a Python virtual environent and install `robotframework-requests` and `robotframework-browser`, the run the tests like this:

    robot --outputdir ./results ./tests

Or, if running the full (destructive) test suite against DEV/BETA:

    robot --outputdir ./results ./tests ./tests_destructive

Once the tests have run, the results of the tests will be in the `results` folder. This is very detailed, and the system will capture screenshots when things go wrong, so this can all be very useful for determining the cause of test failure.

