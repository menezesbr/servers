FROM python:3.7-alpine
LABEL version="1.0" maintainer="<André Menezes>menezesbr@gmail.com"

WORKDIR /usr/src/app
VOLUME ["/usr/src/app"]

# install psycopg2
RUN apk update
RUN apk add py3-cffi zlib-dev gcc jpeg-dev \
    linux-headers libressl-dev \
    libxml2-dev libxslt-dev musl-dev postgresql-dev 

RUN apk update
RUN apk add libffi-dev
RUN apk add openssl-dev
RUN apk add python3-dev 
RUN apk add libpq
RUN apk update
RUN apk upgrade
RUN apk add libpq
RUN apk add postgresql-dev

RUN pip install --upgrade pip
RUN pip install gunicorn
RUN pip install pipenv 
RUN pip install django
RUN pip install python-decouple
RUN pip install pyxb
RUN pip install dj-database-url
RUN pip install pytz
RUN pip install six 
RUN pip install requests
RUN pip install suds-jurko
RUN pip install ibptws
RUN pip install pillow
RUN pip install reportlab
RUN pip install lxml


RUN pip install cryptography
RUN pip install pyopenssl
RUN pip install signxml
RUN pip install https://github.com/thiagopena/geraldo/archive/master.zip

RUN apk add --virtual .build-deps gcc python-dev musl-dev postgresql-dev
RUN pip install psycopg2 
RUN apk del .build-deps

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# COPY ./Pipfile /usr/src/app/Pipfile
# RUN pipenv install --skip-lock --system --dev

# RUN pip install -r requirements.txt
