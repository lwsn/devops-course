FROM python:3.13.3-alpine3.21

ADD server.py server.py

RUN pip install --no-cache-dir FanFicFare==4.44.0

ENV PORT=8000

ENTRYPOINT ["python3", "server.py"]
