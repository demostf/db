FROM postgres:11-alpine

RUN mkdir -p /docker-entrypoint-initdb.d

ADD schema.sql /docker-entrypoint-initdb.d/
