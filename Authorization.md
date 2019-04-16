## Authorization

Note that this discussion is simplified in some areas for introductory clarity.

Kubernetes uses a rich, granular, role-based access control (RBAC) mechanism to authorize requests made to the
API server (e.g. from kubectl).

Some discussion of the API is warranted. The Kubernetes API is REST-based. Each RESTful command has a method
(e.g. HTTP methods: GET, POST, PUT, DELETE) and a yaml payload. The method identifies the action to be taken
with the YAML and the payload contains the details of the Object against which the action is performed.

A sample yaml payload, for a ClusterRole (see more below) defintion, is:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-role-pod-reader-1
rules:
- apiGroups: [""]	# empty because pods are in the default group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```
An HTTP POST would be used to create this ClusterRole. The ClusterRole allows verbs "get", "watch", and "list" to
be performed against "pods", which form part of the core (empty string) apiGroup.

Every valid Kubernetes yaml payload contains the following top-level entry:  
&nbsp;&nbsp;&nbsp;`apiVersion: [API-GROUP/]version`  
Examples are:  
&nbsp;&nbsp;&nbsp;`apiVersion: apps/v1`  
&nbsp;&nbsp;&nbsp;`apiVersion: v1`  
&nbsp;&nbsp;&nbsp;`apiVersion: rbac.authorization.k8s.io/v1`

If API-GROUP is omitted the reference is to the core API group. The apiVersion identifies the version of the
"schema" (yaml expectations) for the given API group. Management of Kubernetes Objects is divided into API groups.
The yaml payload must be in conformance with the apiVersion.

Version 1.12 of the api may be found here: https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.12/ .

Authorization is based on: the user/groups; the namespace; the Object type (e.g. Pod, Deployment, Secret, ...) and
the verb. If a user has permission to perform the action on the Object in the namespace, the RESTful call will
proceed. Otherwise it will fail.

The RBAC mechanism Kubernetes uses employs four Object types: ClusterRoles, Roles, ClusterRoleBindings, and
RoleBindings. The Cluster* Objects are cluster-wide while the Role and RoleBinding objects are namespace-specific.
Some Objects (for example, Nodes) are inherently of cluster scope and so the Cluster* forms must be used for them.
Other Objects, like Deployments, are namespace-specific and so the non-Cluster forms are appropriate. The following
discussion is based on Roles and RoleBindings; the extension to Cluster* is straightforward.

A Role Object defines:
* A single namespace;
* One or more Object types ("resources");
* One or more RESTful verbs (actions).

Note that Roles have no association to users or groups.
A RoleBinding binds a single Role to one or more users and/or to one or more groups. An example ClusterRoleBinding
is given below:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: foo-cluster-role-pod-reader-1
subjects:
- kind: User
  name: foo@bar.com
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-role-pod-reader-1
  apiGroup: rbac.authorization.k8s.io
```

This ClusterRoleBinding grants to the user 'foo\@bar.com' the permissions specified in ClusterRole
'cluster-role-pod-reader-1'. Note that if roleRef.kind was given as Group the binding would be for a group
rather than a user. Note that multiple subjects (users and groups) may be given in a single RoleBinding.

Note that the Kubernetes RBAC system is pessimistic: an operation will fail unless the combination of a Role
and RoleBinding permits it. Deny style permissions are not needed.

Clearly the authorization system is very rich. In a thoughtful environment the use of Roles and groups (and
namespaces) must be carefully planned and managed.

<p align="center"><a href="./Authentication.md">&larr;&nbsp;Previous</a>&nbsp;&vert;&nbsp;<a href="./Logging.md">Next&nbsp;&rarr;</a></p>
