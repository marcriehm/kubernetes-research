# kubectl

kubectl is the main CLI (and indeed, the main UI) for Kubernetes. kubectl communicates with the kube-apiserver via
RESTful YAML. kubectl is "portable" - an instance of kubectl can be used to communicate with any instance of
Kubernetes (e.g. Linux/Windows).

## kubectl contexts

The kubectl config file is found in ~/.kube/config. It is primarily used to establish contexts for subsequent use
in kubectl commands. A context element in a kubeconfig file is a named element used to group access parameters under
a convenient name. Each context has three parameters: cluster, namespace, and user. By default, the kubectl
command-line tool uses parameters from the current context to communicate with the cluster.

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