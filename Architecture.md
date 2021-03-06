## Overall Architecture

There are two primary views of the Kubernetes architecture: the physical architecture of the Kubernetes implementation
itself and the logical architecture of deployed applications.

### Physical Kubernetes Architecture

This section discusses the software architecture of the Kubernetes implementation itself. It is good to
have this overview, but if you're working in the cloud (e.g. GKE) you don't initially need more than a passing
understanding of the concepts (which is all you’ll get from this document).

Kubernetes consists of *Master* or *Control* Nodes, plus regular *Nodes*. Master Services run on the Master nodes, which
comprise the *Control Plane*. Apps run on the (regular) Nodes, which comprise the *Data Plane* or *Application Plane*.
The Control Plane components perform overall coordination ("orchestration") while the Data Plane components are focused
on granular application execution

The high-level component architecture of Kubernetes is depicted below.
![High-level architecture](High-Level-Architecture.png "High-Level Architecture")

#### Master Services

The principal master services are:
* kube-apiserver
* etcd
* kube-controller-manager
* kube scheduler
* cloud controller-manager

##### kube-apiserver

See:
* https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/

The [API server](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-apiserver/ "API Server")
is often likened to the (memory-less) brain of Kubernetes. It is the front end for the control
plane. The API is accessed by two different protocols: RESTful JSON (configured by the end user as YAML) and
[gRPC](https://grpc.io/ "gRPC"). gRPC is used internally within the control plane, while RESTful JSON is used
in communication with UIs (e.g. kubectl). YAML configuration is declarative, not imperative. The API server acts
as the endpoint for both external user connectivity to the Kubernetes cluster as well as for many of the internal,
intra-component communication needs. The API server is the only component which interfaces directly with etcd:

* the API server uses etcd’s watch service to detect divergences in the cluster state (e.g. Nodes going down);
* the API server updates etcd with declarative, desired state;
* the API server queries etcd for declarative state.

The API server manages user authentication and authorization.

The kube-apiserver can scale horizontally.

##### etcd – the cluster store

See:
* https://github.com/etcd-io/etcd/blob/master/Documentation/docs.md

Kubernetes configuration information is stored in the Cluster Store, which is based on the distributed, in-memory,
key-value data store etcd. The cluster store is the only stateful component in the control plane, and as such it
stores both the current and desired states of the system, as well as the current state of nodes. Like Kubernetes
itself, etcd is a project of the Cloud Native Computing Foundation (CNCF).

Acccording to https://en.wikipedia.org/wiki/Kubernetes#Kubernetes_control_plane_(primary), etcd favours Consistency
over Availability (think [CAP theorem](https://en.wikipedia.org/wiki/CAP_theorem "CAP Theorem")) in order to ensure correct
operations. Another reference \[*The Kubernetes Book*;
Nigel Poulton\] says that etcd prefers Consistency over Availability and does not tolerate a “split-brain” situation.
If such a situation arises, Kubernetes will halt updates to the cluster; however, applications should continue to work.

Etcd achieves consistency through the use of the
[RAFT consensus algorithm] (https://en.wikipedia.org/wiki/Raft_(computer_science) "RAFT consensus algorithm") and a
highly-available replicated log. Etcd is written in Go and its interface is gRPC.

##### kube-controller-manager

See:
* https://kubernetes.io/docs/reference/command-line-tools-reference/kube-controller-manager/

The Kubernetes Controller Manager (KCM) implements multiple, orthogonal *Control Loops*, each of which monitors the
cluster in some way and responds to events which occur. Examples of events are: a new Deployment being created; a
Node going down; a Node reporting that a Container has exited. Control loops drive actual cluster state towards
the declared, desired state.

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
state of the cluster and makes changes to move the current state of the system into the desired state. Control
loops manage state as follows:

1. Obtain desired state;
2. Observe current state;
3. Determine differences;
4. Reconcile differences.

This logic is at the heart of Kubernetes’s declarative design pattern.

##### kube-scheduler

See:
* https://kubernetes.io/docs/reference/command-line-tools-reference/kube-scheduler/

The *Scheduler* is responsible for scheduling Pods on Nodes. It looks for new work tasks and assigns them to
appropriate, healthy nodes. The scheduling of pods is distinct from the running of them; running is not performed
by kubelets. The Scheduler determines which data plane nodes are capable of running a given pod, and then scores
them in order to determine which nodes are best to run the pod on. Scoring/ranking includes such things as: free
resources; does the node have the pod already; and number of running pods. Scheduling is an optimization problem.

Note that the Scheduler is a key component in supporting the declarative execution of Pods.

##### Cloud-controller-manager

See:
* https://kubernetes.io/docs/concepts/architecture/cloud-controller/

The *Cloud Controller Manager* (CCM) is similar to the Controller Manager except it houses control loops which
are cloud-dependent. The CCM provides a plugin model and manages integrations with underlying cloud technologies
and services such as load-balancers and storage. At the time of writing, it seems that there is some flux between
the KCM and the CCM.

#### Other Services

##### kubelet

See:
* https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/

The *kubelet* is a container-focused service which runs on every data-plane node and is responsible for running
and monitoring Pods on that Node. The kubelet interfaces with Docker to run applications.

##### System Pods

Where possible, other core Kubernetes services run as Pods on Nodes. Some examples of such services
include:
* DNS
* log collection
* performance monitoring and metrics collection
* *kube-proxy* – maintains network routing rules (ipvs) and performs connection forwarding, routing network
traffic to the appropriate Pods based on their IP addresses and ports.

#### User Interfaces

The primary user interface for Kubernetes, on any implementation, is a command-line tool called kubectl. kubectl is
a command-line interface to the kube-apiserver. kubectl is provided as part of the Kubernetes distribution and
it may be used against any Kubernetes implementation (e.g. GKE, Amazon EKS, Minikube).

##### kubectl

The primary functions of kubectl are to:
* make declarations of new (desired) system state;
* query the system for desired state;
* query the system for current state;
* query the system for logs;
* authenticate users for the above operations.

kubectl can be used to manipulate application Objects in an imperative manner, but this should be strictly avoided.

If you’re working with Kubernetes, you **will** be working in the kubectl CLI – no web application exists to manage the
wide range of Kubernetes application Objects.

kubectl is discussed further in [kubect.md](./kubectl.md "kubectl.md").

See https://kubernetes.io/docs/reference/kubectl/cheatsheet/.

##### GCP/KE UI

As part of its [Google Cloud Platform (GCP) UI](https://console.cloud.google.com "GCP Home"), Google provides a
basic Kubernetes Engine UI, GCP/KE, for viewing and manipulating some basic Kubernetes functionality. Within GCP,
the GCP/KE UI is found at Main Menu &rarr; Kubernetes Engine. GCP/KE is by no means complete and so kubectl is the
primary user interface. Significantly, GCP/KE can be used to view performance metrics and logs.

To create your own Kubernetes cluster on Google Kubernetes Engine (GCP/KE), follow the instructions here:
[Create your Own Kubernetes Cluster on GCP/KE](./create_gke_cluster.md "Create your Own Kubernetes Cluster on
GCP/KE").

### Logical Application Architecture

The logical application architecture of an example Kubernetes application is depicted below.

![Logical application architecture](Kubernetes-Logical-Architecture.png "Logical Application Architecture").

In this example, an HTTP Ingress Object is used as the main application entry point. The other possibility is to use
a LoadBalancer Service.

The Ingress object reverse proxies HTTP to a Webapp Service. This might be either a ClusterIP or a NodePort Service.
The webapp Service load balances across the Pods of a Webapp Deployment, which manages the Pods.

The webapp Pods make use of a microservice. Like the webapp, the microservice is fronted by a load-balancing Service
and is managed by a Deployment. Communication between the webapp and the microservice is JSON over HTTP.

The microservice in turn uses a SQL database, which resides in a single Pod managed by a StatefulSet. The storage for
the database resides in a PersistentVolume.

<p align="center"><a href="./Declarative.md">&larr;&nbsp;Previous</a>&nbsp;&vert;&nbsp;<a href="./Objects.md">Next&nbsp;&rarr;</a></p>
