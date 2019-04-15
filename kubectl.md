# kubectl

See:
* https://kubernetes.io/docs/reference/kubectl/overview/

kubectl is the main CLI (and indeed, the main UI) for Kubernetes. kubectl communicates with the kube-apiserver via
RESTful JSON. kubectl is "portable" - an instance of kubectl can be used to communicate with any instance of
Kubernetes (e.g. Linux/Windows).

Some significant kubectl commands are:
* `kubectl create -f FILENAME` or `kubectl apply -f FILENAME` - create or update  the Objects specified in the given YAML file
* `kubectl get` or `kubectl explain` - get info about the specified Object
* `kubectl attach` - perform a "Docker attach" to the given Pod/Container
* `kubectl logs` - view logs from a set of one or more Pods
* `kubectl top` - get CPU and memory usage information from the given Pod or Node
* `kubectl proxy` - to create an HTTP proxy to the API server
* `kubectl port forward` - create a port-forwarded proxy to the given Pod at the given port

## kubectl contexts

The kubectl config file is found in ~/.kube/config. It is primarily used to establish *contexts* for subsequent use
in kubectl commands. A context element in a kubeconfig file is an element used to group access parameters, including
authentication information, under a convenient name. Each context has three parameters: cluster, namespace, and user.
By default, the kubectl command-line tool uses parameters from the current context to communicate with the cluster.

You can edit the config file manually, e.g. to clone and modify contexts or to change the names of things to be more
meaningful . It is a good idea to browse the file to see how it’s stored.

In general there may be multiple contexts defined in a kubectl config file, e.g. for dev, qa, and prod.

To modify values in a context:

```
kubectl config set-context CONTEXT-NAME 	[--cluster=CLUSTER-NICKNAME] [--user=USER-NICKNAME] 	[--namespace=NAMESPACE]
```
To set the current context for use in subsequent kubectl commands:
```
kubectl config use-context CONTEXT-NAME
```
