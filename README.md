# kubernetes-research

## Purpose
The purpose of this repo is to capture Kubernetes research performed in March and April of 2019.
The goal of the research is to provide a knowledge foundation for Kubernetes and Google Kubernetes
Engine (GKE).

## Principal Online Documentation
The main Kubernetes docs are at http://kubernetes.io/docs. GKE docs are found at https://cloud.google.com/kubernetes-engine/docs.

## Scope

The scope of this document is to:
* introduce Kubernetes;
* discuss its architecture;
* present a solid introduction to Kubernetes and enough examples of usage such that a reader could get started
on the platform with little other knowledge;
* provide a basic reference to Kubernetes, including links to other information;
* discuss some of the specifics of Kubernetes on the Google cloud (GKE).

While all of the major cloud platforms support Kubernetes, Google Kubernetes Engine (GKE), which runs on top of
Google Cloud Platform (GCP), was chosen as the target platform for this study because of Google's close experience
with Kubernetes. Application portability is a Kubernetes goal and so an effort has been made in this document to
separate out the GKE specifics from the Kubernetes generalities.

Readers are expected to have basic knowledge of:
* Linux, including the command line;
* Docker;
* YAML.

## Table of Contents
&nbsp;&nbsp;&nbsp;[Overview](./Overview.md "Overview")  
&nbsp;&nbsp;&nbsp;[Declarative vs. Imperative Management](./Declarative.md "Declarative vs. Imperative Management")  
&nbsp;&nbsp;&nbsp;[Architecture](./Architecture.md "Architecture")  
&nbsp;&nbsp;&nbsp;[Objects](./Objects.md "Objects")  
&nbsp;&nbsp;&nbsp;[API](./API.md "API")  
&nbsp;&nbsp;&nbsp;[Authentication](./Authentication.md "Authentication")  
&nbsp;&nbsp;&nbsp;[Authorization](./Authorization.md "Authorization")  
&nbsp;&nbsp;&nbsp;[Auditing and Logging](./Logging.md "Auditing and Logging")  
&nbsp;&nbsp;&nbsp;[Resource Allocation and Monitoring](./Resources.md "Resource Allocation and Monitoring")  

