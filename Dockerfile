FROM  python:3-alpine

COPY requirements.txt /tmp/requirements.txt
RUN  pip install -r /tmp/requirements.txt

COPY tests /tests
COPY rf_prometheus_listener.py .

ENTRYPOINT [ "robot" ]
CMD [ "robot",  "--listener", "rf_prometheus_listener.py", "--outputdir", "/results", "/tests" ]

