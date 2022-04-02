FROM golang:alpine as builder

COPY . /env-server
WORKDIR /env-server
RUN go build -o env-server-binary main.go



FROM alpine:latest
COPY --from=builder /env-server/env-server-binary /
ENV HASURA_APP=hasura-env-echo
ENTRYPOINT ["/env-server-binary"]
