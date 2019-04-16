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
* \[core\]: Pods, ConfigMaps, Services, EndPoints, ...
* apps: Deployments, DaemonSets, ...
* batch: Jobs, CronJobs, ...
* rbac.authorization.k8s.io: Roles, RoleBindings, ...
The 'core' group is never explicitly named in the API; it can be thought of as the empty string.

The URI syntax is:  
&nbsp;&nbsp;&nbsp;`/PREFIX[/API-GROUP]/API-VERSION/namespaces/NAMESPACE/OBJECT-KIND-PLURAL[/NAME]?QUERY_PARMS`  
where:
* PREFIX is "/api" for the 'core' group, or "/apis" for other groups.
* API-GROUP is not given for the 'core' group, or it is the named group, as above.
* API-VERSION is, by example, "v1", "v2beta1", "v2". The available versions depend on the group.
* NAMESPACE is the name of a namespace.
* OBJECT-KIND-PLURAL is, by example, "deployments", "pods", "services"
* NAME is an optional Object name, within the namespace and kind; it is not given when querying for a list of Objects.
* QUERY_PARMS are optional query parameters. Some query parameters include "labelSelector" and "fieldSelector"


<p align="center"><a href="./Objects.md">&larr;&nbsp;Previous</a>&nbsp;&vert;&nbsp;<a href="./Authentication.md">Next&nbsp;&rarr;</a></p>
