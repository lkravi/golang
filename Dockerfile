FROM golang:alpine as builder
ENV GO111MODULE=on
WORKDIR /builder
ADD ./ /build
RUN apk update --no-cache
RUN apk add git
RUN go build -o golang-test  .


FROM alpine:3.14
WORKDIR /app
COPY --from=builder /build/golang-test .
EXPOSE 8000
ENTRYPOINT ["/app/golang-test"]
