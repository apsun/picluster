# https://hub.docker.com/_/golang/#start-a-go-instance-in-your-app
# https://www.docker.com/blog/faster-multi-platform-builds-dockerfile-cross-compilation-guide/

FROM --platform=$BUILDPLATFORM golang:1.26.2 AS build
WORKDIR /src
COPY go.mod go.sum .
RUN go mod download
COPY . .
ARG TARGETOS TARGETARCH
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH CGO_ENABLED=0 go build -v -o /testapp .
FROM alpine
COPY --from=build /testapp /testapp
EXPOSE 8000
CMD ["/testapp"]
