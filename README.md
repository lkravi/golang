# Simple Golang CloudNative App

This is a sample sample repo will explain how you build simple golang app locally , contanairze it and deploy into a Kubernetes cluster. You can check GitHub actions for sample PR builds and CI builds.

 In the second part I propose Ideal workflow for CI/CD piplene.

## Fixes

*Changing quote v3 import -> [make quote v3 as a named import · lkravi/golang@1bcbb58 · GitHub](https://github.com/lkravi/golang/commit/1bcbb58eb0785d30b5bde4602f4cddb433d41fbf)*

Changing localhost to multicast -> [making localhost to multicast, to serve all incoming requests instead… · lkravi/golang@e1c47c4 · GitHub](https://github.com/lkravi/golang/commit/e1c47c44b2389aa73c1ea8a5dce78181bf1ef105)

Changing Docker file to multi-stage build -> https://github.com/lkravi/golang/commit/8354e996bd2870ae2420e1219c64bd117bdb348a

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

------------------------

## 

# Ideal CI/CD Pipeline

![Alt text](/doc_img/ci-cd-ideal.png?raw=true "Ideal CI/CD Pipleline")

## 01 - PR build and CI build on merge

* Run Unit tests
* Static code analysis
  - SonarQube
    - Inspection of code quality to perform review to detect code smells, security vulnerabilities and bugs.
  - Fortify / CheckMarks
    - Static application security testing tool for scan security vulnerabilities.
  - Lint Tools
    - Lint tool used to check for programmatic and stylistic errors.
* Build failure notifications / JIRA ticket upgrade etc.
* Build artefacts on merge builds. tag them as snapshot/dev and upload to artefact repository.
* Deploy that artefact to development environment.

Pull requests merged after quality gate checks and code review approvals.

## 02 - Release branch builds

* Run Unit tests
* Static code analysis
  - Refer step #1 for more detail
* Dynamic code analysis
  - Fortify Webinspect / App Spider
    - Dynamic application security testing tool that identifies application vulnerabilities in deployed web application and services.
* Build artefacts on merge builds, tag them with correct version (git tags) and upload to artefact repository.
* Artefact analysis
  - Twistlock / Trivy / Clair
    - Vulnerability scanners for container images.
  - Nexus IQ
    - Policy violations, Security Issues, License analysis
* Deploy that artefacts to Test Environment.

When feature completed or when development branch needed to work on next release changes. we need to create a release branch.
Release branch builds will create versioned artefact which can promote across Test, UAT, Production based on verification success.

## 03 - Continuous deployment

* Deploy to Staging and Production on demand using push button deployments.
  - Promote artefacts to Staging/UAT and Production environments using continuous deployment mechanisms.
    - Can use specialised tools like GitOPS (Flux, ArgoCD), GoCD for continuous deployment.
    - Use Infrastructure as code scripts to maintain environment states/resources.

Deployment artefacts are configured to take environment variable based parameters/ k8s cluster based secrets and config maps to support different environment configurations.

![Alt text](/doc_img/k8-cluster.png?raw=true "Ideal CI/CD Pipleline")

* Application configurations are stored in config maps.
* Application sensitive information stored in cluster secrets.
* Each pods have health-check routes and deployments configured Kubernates pod health-checks.
* Ingress proxy(nginx, traefik) is configured to handle and route external requests to correct services.
  - In this setup TLS termination happen in Load Balancer level.
  - However based on the requirement if we need to manage our own cert-manager and TLS termination inside the cluster. It can be done using a tool like jetstack cert manager.
* RABC configured to control resources changes/ unauthorised access to cluster.
* Rolling released based deployment ensure zero outage deployments.



## Additional Notes

SonarCloud : https://sonarcloud.io/summary/overall?id=lkravi-golang

Docker Image : [Docker Hub](https://hub.docker.com/r/lkravi/golang-test/tags)
