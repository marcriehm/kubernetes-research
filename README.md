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

## Overview

Kubernetes is a sophisticated, rich application orchestration system which provides the mechanisms to execute and
coordinate containerized applications (think Docker) in a distributed fashion across a clustered environment. It
brings predictability, scalability, management, and high availability, all in a portable ecosystem. Its offerings
straddle both Platform as a Service (PaaS) and Infrastructure as a Service (IaaS) (without furnishing a complete
solution for either).

Kubernetes can be considered to be portable because it provides a logical application architecture which can run
on any Kubernetes implementation. All of the major logical constructs (Kubernetes Objects) are defined at a
high-enough level and are complete enough such that most applications (excepting the complex ones) can run on
it with little regard for the underlying operating environment or the Kubernetes implementation itself. Indeed,
that abstraction is one of the foundational motivations for the system.

That being said, it should be noted that Kubernetes is a complex system and is not easily mastered. It
was designed to run in managed environments and, for most purposes, it is strongly recommended that it be
provisioned in the cloud, rather than in a custom, in-house implementation. The task of bootstrapping Kubernetes
up, and providing implementations in support of all of the Objects, is a large one and is best left to specialists.

Kubernetes provides a framework, based on Google's best practices, for managing:

* containers, i.e. Docker;
* applications, including zero-downtime deployments and declarative specification;
* networking;
* storage;
* resource management;
* health montoring and healing;
* scalability;
* fault tolerance;
* logging, including application and audit;
* monitoring.

Kubernetes does not provide:
* Application build facilities and CI/CD;
* Application-level services, such as databases, middleware, or frameworks (such as Enterprise Java);

But it does provide a platform for such services!
* Physical or virtual machine management.

Kubernetes is an open-source system written in Go. It was developed originally by Google and is now managed
by the Cloud Native Computing Foundation and is available on all major cloud platforms. It is under very active
development, which is both good (momentum) and bad (fast-moving; documentation challenges). Kubernetes has
bested Docker Swarms as the dominant distributed container technology. It provides high-level infrastructure
and application abstractions which can make applications largely portable across providers, whether cloud-based
or in-house. It is particularly well-suited to support, and indeed engenders the use of, microservices.

## Declarative vs. Imperative Management

Declarative Object management is fundamental to Kubernetes. A declarative approach may be contrasted with an
imperative approach as follows:

Declarative: "I want a service with the given properties to be available in my system"
* "Be like this"

Imperative: "Create a service with the following properties"
* "Do this"

In an imperative approach, the author must always be explicitly aware of:
* The current state of the system;
* The desired state of the system;
* How to transform the system from the current to the desired state (complex).

In Kubernetes's declarative approach, the system handles steps 1 and 3, and all the user needs to do is express
the desired final state of the application.

The declarative approach is fundamental in Kubernetes. In some cases both declarative and imperative approaches
exist, but the declarative one should **always** be chosen over imperative. A declarative statement of configuration
is sometimes called a *Manifest*.

Note that declarative configurations are self-documenting and lend themselves well to version control, in contrast
with imperative statements. Note that a weakness is that you cannot declaratively delete an Object; nevertheless,
imperative approaches should be used for creation and updating.

## Overall Architecture




