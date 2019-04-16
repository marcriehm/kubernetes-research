## The Kubernetes API

See:
* https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md
* https://kubernetes.io/docs/concepts/overview/kubernetes-api/
* https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.12/ \[Kubernetes version 1.12 API Reference\]

The Kubernetes API Server speaks two languages: [gRPC](https://grpc.io "gRPC") and RESTful JSON (if YAML is used, it is converted
to JSON before hitting the API server). Either form of communication can be used; they follow the same schema definition and
there is a one-to-one mapping between the gRPC syntax and the RESTful one. I believe that intra-component communication between
Kubernetes components themselves is gRPC. This page discusses the REST API because it is more likely to be encountered by end users.

The API is divided into named groups, for example:
* \[core\]: Pods
* apps: 

The URI syntax is:  
&nbsp;&nbsp;&nbsp;`/PREFIX[/API-GROUP]/API-VERSION/namespaces/NAMESPACE/OBJECT-KIND-PLURAL[/NAME]?QUERY_PARMS`  
where:
* PREFIX is "/api" for the 'core' group, or "/apis" for other groups

The API is divided into groups



<p align="center"><a href="./Objects.md">&larr;&nbsp;Previous</a>&nbsp;&vert;&nbsp;<a href="./Authentication.md">Next&nbsp;&rarr;</a></p>
