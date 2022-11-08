FROM golang:latest

COPY . /env-server
WORKDIR /env-server

ENV HASURA_APP=hasura-env-echo
ENTRYPOINT ["/env-server-binary"]


