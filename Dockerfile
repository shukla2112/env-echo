FROM golang:alpine as builder

COPY . /env-server
WORKDIR /env-server

ENV HASURA_APP=hasura-env-echo
ENTRYPOINT ["/env-server-binary"]


