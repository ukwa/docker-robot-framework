# docker-robot-framework
A Dockerised Robot Framework execution environment, including dependencies and tests for the UK Web Archive services.

## Overall strategy

The goal of this piece of work is to cover our main service offering from an end-user perspective:

- All authenticated/restricted services. i.e. checking that anything that should not be public is not public.
- All distinct dependencies. i.e. Every distinct container or back-end service should have at least one test that checks it is working. e.g. one Wayback query checks that the CDX and WARCs are available, as well as the service containers.

Note that deep or complete coverage of the functionalities of each tool are not in scope. The underlying tools that deliver our services are expected to change over time, so this set of tests is intended to ensure that we can make those changes without breaking our user interfaces and APIs.

Wherever possible, these tests should be written to run safely on the live, production services, so we can use them to spot realistic errors and outages.  These are to go in a `tests` folder.  Any tests that manipulate data and so should only be run on BETA or DEV should be put in a folder called `tests_destructive` and only included in the test run on DEV/BETA.

Currently, some work has been done to establish automated testing our our core products, including [main website tests](https://github.com/ukwa/ukwa-services/tree/master/access/website_tests) an [ingest service tests](https://github.com/ukwa/ukwa-services/tree/master/ingest/ingest_tests).  The latter are the most recent and are somewhat better documented. These tests will be moved into this repository, see https://github.com/ukwa/docker-robot-framework/issues/1.


## How to build and run these tests

_TBA_
