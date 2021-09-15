FROM  python:3

# Install Node as robotframework-browser needs it:
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

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

