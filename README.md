# Simple Golang CloudNative App

This is a sample sample repo will explain how you build simple golang app locally , contanairze it and deploy into a Kubernetes cluster.

## Fixes

*Changing quote v3 import ->[make quote v3 as a named import · lkravi/golang@1bcbb58 · GitHub](https://github.com/lkravi/golang/commit/1bcbb58eb0785d30b5bde4602f4cddb433d41fbf)*

Changing localhost to multicast -> [making localhost to multicast, to serve all incoming requests instead… · lkravi/golang@e1c47c4 · GitHub](https://github.com/lkravi/golang/commit/e1c47c44b2389aa73c1ea8a5dce78181bf1ef105)

Changing Docker file to multi-stage build -> [making localhost to multicast, to serve all incoming requests instead… · lkravi/golang@e1c47c4 · GitHub](https://github.com/lkravi/golang/commit/e1c47c44b2389aa73c1ea8a5dce78181bf1ef105)



## Test Golang app locally

```
go mod init github.com/lkravi/golang
go mod tidy
go build -o golang-test
./golang-test
```

This will bring up the web-server on port 8000. You can check your browser



## Build Docker Image

We are using multi-stage docker build as we don't need to include build dependencies in to running container.

```
docker build . -t golang-test

#Check docker container locally
docker run -p 8000:8000 golang-test
```



## Deploying to Kubernates Cluster

You can find sample yaml files for kubernates deployment inside the /k8s directory.

```
kubectl apply -f k8s/deployment.yaml

#Check your service locally using port-forwading
kubectl port-forward service/golang-test-service 8000:80
```
