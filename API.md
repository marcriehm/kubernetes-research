## The Kubernetes API

See:
* https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md
* https://kubernetes.io/docs/concepts/overview/kubernetes-api/
* https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.12/ \[Kubernetes version 1.12 API Reference\]

The Kubernetes API Server speaks two languages: [gRPC](https://grpc.io "gRPC") and RESTful JSON (I believe it is the case
that when YAML is used, for example in declarative files, it is converted
to JSON before being sent to the API server). Either form of communication can be used between components; they follow the same
schema definition and
there is a one-to-one mapping between the gRPC syntax and the RESTful one. I believe that intra-component communication between
Kubernetes components themselves is gRPC. This page discusses the REST API because it is more likely to be encountered by end users.

The API is divided into named groups, for example:
* \[core\]: Pods, ConfigMaps, Services, EndPoints, ...
* apps: Deployments, DaemonSets, ...
* batch: Jobs, CronJobs, ...
* rbac.authorization.k8s.io: Roles, RoleBindings, ...

Every Kubernetes message contains a field, named apiVersion, which identifies both the API group and the version of the API
within that group. The format of the apiVersion is: `API-GROUP/API-VERSION`, e.g. `apps/v1`. (Note that the 'core' group is never
explicitly named in the API; it is just referenced as API-VERSION, e.g. `v1`.) The apiVersion determines the schema of messages,
i.e. the schema of Kubernetes Objects.

As Kubernetes evolves, it is common for multiple versions of the same API-GROUP to co-exist; this implies that multiple versions
of the Object schema co-exist. For example, in Kubernetes 1.12, there are three versions of HorizontalPodAutoscalers -
v1, v2beta1, and v2beta2. You have to be careful to align your Object definitions with the desired schema version.

The apiVersion affects the RESTful API URIs. The URI syntax is:  
&nbsp;&nbsp;&nbsp;`/PREFIX[/API-GROUP]/API-VERSION/namespaces/NAMESPACE/OBJECT-KIND-PLURAL[/NAME]?QUERY_PARMS`  
where:
* PREFIX is "/api" for the 'core' group, or "/apis" for other groups.
* API-GROUP is not given for the 'core' group, or it is the named group, as above.
* API-VERSION is, by example, "v1", "v2beta1", "v2". The available versions depend on the group.
* NAMESPACE is the name of a namespace.
* OBJECT-KIND-PLURAL is, by example, "deployments", "pods", "services"
* NAME is an optional Object name, within the namespace and kind; it is not given when querying for a list of Objects.
* QUERY_PARMS are optional query parameters. Some query parameters include "labelSelector" and "fieldSelector"

Some examples are:
* `GET /api/v1/namespaces/my-namespace/pods`: list all Pods in namespace 'my-namespace'
* `PUT /api/v1/namespaces/my-namespace/pods/my-pod`: update Pod 'my-pod' in namespace 'my-namespace'
* `GET /apis/apps/v1/namespaces/my-namespace/deployments/my-deployment`: get deployment 'my-deployment' in namespace 'my-namespace'

For POST (create), PUT (update), or DELETE (delete) operations, the payload defining the Object is given in JSON in the body of the
HTTP message. The API docs at https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.12 do a good job of defining
the Object JSON for all of the kinds of Objects. It is a good idea to familiarize yourself with the API docs as a reference
for creating declarative files. Note again that the Object schema can change between API versions.

<p align="center"><a href="./Objects.md">&larr;&nbsp;Previous</a>&nbsp;&vert;&nbsp;<a href="./Authentication.md">Next&nbsp;&rarr;</a></p>
