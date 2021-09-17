# Useful base image with Node, Python 3, etc.
FROM mcr.microsoft.com/playwright:focal

# Install Python dependencies:
COPY requirements.txt /tmp/requirements.txt
RUN  pip install -r /tmp/requirements.txt

# Install additional requirements for robotframework-browser:
RUN rfbrowser init

# Copy in the tests and helpers:
COPY tests /tests
COPY rf_prometheus_listener.py /
COPY make_profile.py /

# Use an environment variable to ensure some RF options are always set:
ENV ROBOT_OPTIONS="--listener /rf_prometheus_listener.py --outputdir /results"
ENV EXTRA_TESTS=""

# Always run robot:
ENTRYPOINT [ "robot" ]

# CMD used to set test location, can be overridden easily:
CMD [ "/tests", "${EXTRA_TESTS}" ]

