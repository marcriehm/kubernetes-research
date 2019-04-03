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

This section discusses the high-level software architecture of the Kubernetes implementation itself. It is good to
have this overview, but if you're working in the cloud (e.g. GKE) you don't initially need more than a passing
understanding of the concepts (which is all you’ll get from this document).

Kubernetes consists of *Master* or *Control* Nodes, plus regular *Nodes*. Master Services run on the Master nodes, which
comprise the *Control Plane*. Apps run on the (regular) Nodes, which comprise the *Data Plane* or *Application Plane*.
The Control Plane components perform overall coordination ("orchestration") while the Data Plane components are focused
on granular application execution

The high-level component architecture of Kubernetes is depicted below.
![High-level architecture](High-Level-Architecture.png "High-Level Architecture")

### Master Services

The principal master services are:
* kube-apiserver
* etcd
* kube-controller-manager
* kube scheduler
* cloud controller-manager

#### kube-apiserver

The API server is often likened to the (memory-less) brain of Kubernetes. It is the front end for the control
plane. Its interface is RESTful YAML. YAML configuration is declarative,
not imperative. The API server acts as the endpoint for both external user connectivity to the Kubernetes cluster as
well as for many of the internal, intra-component communication needs. The API server is the only component which
interfaces directly with etcd:

* the API server uses etcd’s watch service to detect divergences in the cluster state (e.g. Nodes going down);
* the API server updates etcd with declarative, desired state;
* the API server queries etcd for declarative state.

The API server manages user authentication and authorization.

The kube-apiserver can scale horizontally.

Some intra-control-plane communication, e.g. between the API server and etcd, seems to be done via gRPC calls (rather
than RESTful YAML), although this isn’t entirely clear.

#### etcd – the cluster store

Kubernetes configuration information is stored in the Cluster Store, which is based on the distributed, in-memory,
key-value data store etcd. The cluster store is the only stateful component in the control plane, and as such it
stores both the current and desired states of the system, as well as the current state of nodes. Like Kubernetes
itself, etcd is a project of the Cloud Native Computing Foundation (CNCF).

Acccording to https://en.wikipedia.org/wiki/Kubernetes#Kubernetes_control_plane_(primary), etcd favours Consistency
over Availability (think CAP theorem) in order to ensure correct operations. Another reference \[*The Kubernetes Book*;
Nigel Poulton\] says that etcd prefers Consistency over Availability and does not tolerate a “split-brain” situation.
If such a situation arises, Kubernetes will halt updates to the cluster; however, applications should continue to work.

Etcd achieves consistency through the use of the RAFT consensus algorithm and a highly-available replicated log. 
Etcd is written in Go and its interface is gRPC.

#### kube-controller-manager

The Kubernetes Controller Manager (KCM) implements multiple, orthogonal *Control Loops*, each of which monitors the
cluster in some way and responds to events which occur. Examples of events are: a new Deployment being created; a
Node going down; a Node reporting that a Container has exited. Control loops drive actual cluster state towards
the desired state.

Some of the control loops include:
* Node controller
* DaemonSet controller
* Jobs controller
* Endpoints controller
* ReplicaSet controller
* Namespace controller
* Service accounts controller

Control loops are also known as *Watch Loops* or *Reconciliation Loops*.

Control loops are orthogonal in that each is specialized to monitor one aspect of Kubernetes. Each controller
takes care of its own task and does not consider events outside of its domain. Each control loop watches the
state of the cluster and makes changes to move the current state of the sysgtem into the desired state. Control
loops manage state as follows:

1. Obtain desired state;
2. Observe current state;
3. Determine differences;
4. Reconcile differences.

This logic is at the heart of Kubernetes’s declarative design pattern.

#### kube-scheduler

The *Scheduler* is responsible for scheduling Pods on Nodes. It looks for new work tasks and assigns them to
appropriate, healthy nodes. The scheduling of pods is distinct from the running of them; running is not performed
by kubelets. The Scheduler determines which data plane nodes are capable of running a given pod, and then scores
them in order to determine which nodes are best to run the pod on. Scoring/ranking includes such things as: free
resources; does the node have the pod already; and number of running pods. Scheduling is an optimization problem.

Note that the Scheduler is a key component in supporting the declarative execution of Pods.

#### Cloud-controller-manager

The *Cloud Controller Manager* (CCM) is similar to the Controller Manager except it houses control loops which
are cloud-dependent. The CCM manages integrations with underlying cloud technologies and services such as
load-balancers and storage. At the time of writing, it seems that there is some flux between the KCM and the CCM.

### Other Services

#### kubelet

The *kubelet* is a container-focused service which runs on every data-plane node and is responsible for running
and monitoring Pods on that Node. The kubelet interfaces with Docker to run applications.

#### System Pods

Where possible, other core Kubernetes services run as Pods on Nodes. Some examples of such services
include:
* DNS
* log collection
* performance monitoring and metrics collection
* *kube-proxy* – maintains network routing rules (ipvs) and performs connection forwarding, routing network
traffic to the appropriate Pods based on their IP addresses and ports.


