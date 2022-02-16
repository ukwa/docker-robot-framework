# docker-robot-framework
A Dockerised Robot Framework execution environment, including dependencies and tests for the UK Web Archive services.

## Overall strategy

The goal of this piece of work is to cover our main service offering from an end-user perspective:

- All authenticated/restricted services. e.g. checking that anything that should not be public is not public.
- All distinct dependencies. i.e. Every distinct container or back-end service should have at least one test that checks it is working. e.g. one Wayback query checks that the CDX and WARCs are available, as well as the service containers.
- Instances of all permanent URLs, as an attempt to ensure we don't break incoming links accidentally.

Note that deep or complete coverage of the functionalities of each tool are not in scope. The underlying tools that deliver our services are expected to change over time, so this set of tests is intended to ensure that we can make those changes without breaking our user interfaces and APIs.

Wherever possible, these tests should be written to run safely on the live, production services, so we can use them to spot realistic errors and outages.  These are to go in a `tests` folder.  Any tests that manipulate data and so should only be run on BETA or DEV should be put in a folder called `tests_destructive` and only included in the test run on DEV/BETA. 

It is also designed to be run against near-production versions by changing the `TEST_HOST` environment variable, so that it can be used to verify that a new version of a service passes the tests ahead of deployment to production. A summary of the results is send to the relevant Prometheus Push Gateway for monitoring (note that the `dev` monitoring services is not always running, so the script may log an error after the tests have run).

The build/test/deploy system uses Docker, to ensure the additional libraries to run web browsers and talks to Prometheus are in place.  Specifically, the container includes [RequestsLibrary](https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html) for testing APIs, and the [robotframework-browser](https://robotframework-browser.org/) library (based on [Playwright](https://playwright.dev/)) and  [SeleniumLibrary](http://robotframework.org/SeleniumLibrary/) for browser-driven tests. The Playwright-based library is a bit simpler to deploy than the Selenium-based on, so tests will be switched over to the former eventually.

## How to build and run these tests

To build the test system including all tests and the system dependencies, we use Docker Compose:

    docker-compose build

The `run-tests.sh` runs the tests, also using Docker Compose. For example, to run against `dev` (out of `dev/beta/prod`):

    ./run-tests.sh dev

That script sets up the necessary environment variables, and expects our internal variable files to be available at a fixed location, e.g. for `dev`:

    ~/gitlab/ukwa-services-env/dev.env

The tests will run, logging progress to the console and writing results to the `./results` folder.  The files in this folder summarise the results, and provide detailed information and screenshots if a test has failed.

Note that after changing the tests, you do not need to rebuild the container, as they are mounted as a Docker volume. However, if you change the helper scripts (e.g. `rf_prometheus_listener.py` or the dependencies etc.) a `docker-compose build` will be needed.

While we're still using Selenium, after running the tests, use:

    docker-compose stop

to shut down the Selenium service.

## Running tests without Docker

_n.b. the following does not take into account the Selenium-based tests!_

Using Docker avoids having to install dependencies. If using Docker is not an option, you could set up a Python virtual environment and install `robotframework-requests` and `robotframework-browser`. Then pull in the necessary environment variables (e.g. for `dev`):

    source ~/gitlab/ukwa-services-env/dev.env

Then run the tests like this:

    robot --outputdir ./results ./tests

Or, if running the full (destructive) test suite (against DEV/BETA only!):

    robot --outputdir ./results ./tests ./tests_destructive

Once the tests have run, the results of the tests will be in the `results` folder. This is very detailed, and the system will capture screenshots when things go wrong, so this can all be very useful for determining the cause of test failure.


## Pa11y Integration

This test suite includes support for evaluating accessibility via [pa11y](https://github.com/pa11y/pa11y), which cannot cover all aspects of accessibility but should help pick up any major problems.

It can be run manually, like this:

```bash
docker-compose run --entrypoint pa11y robot --reporter html --include-warnings https://www.webarchive.org.uk/ > results/pa11y.html
```

But to make this more useful we use a simple integration with the Robot Framework, so that the results for multiple pages can be gathered into a single report.