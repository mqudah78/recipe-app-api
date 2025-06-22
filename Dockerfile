# Use Python 3.12 slim base image
FROM python:3.12-slim

LABEL maintainer="yourname@example.com"

ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Copy requirements files
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Define build-time argument
ARG dev=false

# Install dependencies in a virtual environment
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$dev" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp/requirements*

# Copy app source code
COPY ./app /app

EXPOSE 8000

# Create a non-root user
RUN adduser --disabled-password --no-create-home django-user

USER django-user

# Use the virtual environment by default
ENV PATH="/py/bin:$PATH"
