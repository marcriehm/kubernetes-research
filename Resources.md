## Resource Allocation and Monitoring

It is important to manage the resources - CPU and memory - of Pods when they're created. This serves two purposes:

1. To determine the Nodes upon which Pods will be scheduled to run;
2. To limit the resource usage of Pods.

Resources are managed at the Container level. There are two kinds of resources: CPU and memory. There are two expressions of
resource management: the *request* and the *limit*.

The request specifies the Container's requested resources; this is used by the Scheduler when Pods are being scheduled to run.
The Scheduler ensures that the sum of all of the resource requests made by Containers on a Node can be fulfilled by that Node.
For instance, if a Node has a capacity of 2000m (2 CPUs) and there are two Containers running on the Node, each having
requested 800m CPU, then another Container of capacity 600m cannot be run on the Node, because the total requested CPU would
be 2200m and the Node can only provide 2000m.

The limit specifies the maximum amount of CPU or memory which the process in a Container is allowed to have. If a process
starts to consume more CPU and bumps up against the CPU limit, the kubelet will use CGROUPS to throttle the CPU usage back
to the given limit.

Memory limits are not so easily managed, however. If a Container process requests more memory than it is allowed, the Pod is
simply killed (and presumably the Controller will start a replacement Pod). Termination occurs because it is impossible to 
limit a process's memory usage without causing it to fail anyway.

Limits are specified in YAML as:
* `spec.containers[].resources.requests.cpu`
* `spec.containers[].resources.requests.memory`
* `spec.containers[].resources.limits.cpu`
* `spec.containers[].resources.limits.memory`

For an example, see [./Deployments/ip-webapp-deploy-1.yaml](./Deployments/ip-webapp-deploy-1.yaml "Sample Deployment Code").

<p align="center"><a href="./Logging.md">&larr;&nbsp;Previous</a></p>
