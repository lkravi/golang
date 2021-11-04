FROM golang:alpine as builder
ENV GO111MODULE=on
WORKDIR /build
ADD ./ /build
RUN apk update --no-cache
RUN apk add git
RUN go build -o golang-test  .
# Can run smoke unit test for build verification

FROM alpine:3.14
WORKDIR /app
COPY --from=builder /build/golang-test .
EXPOSE 8000
ENTRYPOINT ["/app/golang-test"]
