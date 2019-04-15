## Overview

Kubernetes is a sophisticated, rich application orchestration system which provides the mechanisms to execute and
coordinate containerized applications (think Docker) in a distributed fashion across a clustered environment. It
brings predictability, scalability, management, and high availability, all in a portable ecosystem. Its offerings
straddle both Platform as a Service (PaaS) and Infrastructure as a Service (IaaS) (without furnishing a complete
solution for either).

Kubernetes can be considered to be portable because it provides a logical application architecture which can run
on any Kubernetes implementation. All of the major logical constructs (Kubernetes *Objects*, or *Resources*) are defined at a
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
* Physical or virtual machine management.

But it does provide a platform for such services!

Kubernetes is an open-source system written in Go. It was developed originally by Google and is now managed
by the Cloud Native Computing Foundation and is available on all major cloud platforms. It is under very active
development, which is both good (momentum) and bad (fast-moving; documentation challenges). Kubernetes has
bested Docker Swarms as the dominant distributed container technology. It provides high-level infrastructure
and application abstractions which can make applications largely portable across providers, whether cloud-based
or in-house. It is particularly well-suited to support, and indeed engenders the use of, microservices.

<p align="center"><a href="./README.md">&larr;&nbsp;Previous</a>&nbsp;&vert;&nbsp;<a href="./Declarative.md">Next&nbsp;&rarr;</a></p>
