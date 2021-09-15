# Useful base image with Node, Python 3, etc.
FROM mcr.microsoft.com/playwright:focal

# Install Python dependencies:
COPY requirements.txt /tmp/requirements.txt
RUN  pip install -r /tmp/requirements.txt

# Install additional requirements for robotframework-browser:
RUN rfbrowser init

# Copy in the tests:
COPY tests /tests
COPY rf_prometheus_listener.py /
COPY make_profile.py /

ENTRYPOINT [ "robot" ]
CMD [ "--listener", "/rf_prometheus_listener.py", "--outputdir", "/results", "/tests" ]

