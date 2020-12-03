FROM  python:3-alpine

COPY requirements.txt /tmp/requirements.txt
RUN  pip install -r /tmp/requirements.txt

COPY tests /tests
COPY rf_prometheus_listener.py /
COPY make_profile.py /

ENTRYPOINT [ "robot" ]
CMD [ "--listener", "/rf_prometheus_listener.py", "--outputdir", "/results", "/tests" ]

