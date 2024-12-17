FROM python:3.12-alpine
LABEL MAINTAINER="Stefhani Backend Developer"
LABEL version="1.0"
LABEL description="Dockerfile para un proyecto Django con Python 3.13.1"

ENV PYTHONUNBUFFERED 1

COPY ./requirements/requirements.txt /tmp/requirements.txt
COPY ./requirements/requirements.dev.txt /tmp/requirements.dev.txt
COPY ./src /src
WORKDIR /src
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        usr_api

ENV PATH="/py/bin:$PATH"
USER usr_api
