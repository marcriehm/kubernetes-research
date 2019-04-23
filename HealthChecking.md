## Health Checking

See:
* https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/
* https://cloud.google.com/blog/products/gcp/kubernetes-best-practices-setting-up-health-checks-with-readiness-and-liveness-probes

Pods need to have their health checked regularly, so that Kubernetes knows:
1. Which Pods are healthy and can be included in Services;
2. Which Pods are not healthy and must be restarted.

There are two kinds of health checks:
1. Liveness probes;
2. Readiness probes.

A *Liveness* probe is used periodically throughout a Container's lifetime to make sure that the Container is functioning correctly
and making progress servicing requests. A *Readiness* probe is used throughout the Container's lifecycle to determine whether
or not the Container is currently available to accept traffic. Note that it is possible for a
Container to be Alive but not Ready. Liveness probes are used to determine whether or not a Pod should be killed (and presumably
restarted). Readiness probes are used to determine whether or not a Pod should have Service traffic sent to it.

Note that if any Container in a Pod is found to be not alive or not ready, the entire Pod is found to have that status.

**All Pods should have Liveness checks configured.** This is accomplished via the
[PodSpec.containers\[n\].liveNessProbe](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.12/#probe-v1-core "Liveness Probe")
sub-object.

There are three kinds of Liveness probes, or actions:
1. exec;
2. HTTP Get;
3. TCP Socket Connect.

An exec command is a command which is `exec`ed (think Unix exec or Docker exec) in the Container on a periodic basis. If the
exit status of the command is zero (successful), the Container is deemed to be healthy; else it is considered to be unhealthy
and the Pod will be killed and restarted.

An HTTP Get probe sends an HTTP Get to the Container on a specified port and with a specified URI path. If the HTTP status code
returned satisfies 200 <= status-code < 400, then the Container is deemed to be healthy.

A TCP liveness probe attempts to make a TCP connection on a specified port; if the connection can be made, the Container is
healthy.

Readiness probes follow the same semantics as Liveness probes.

<p align="center"><a href="./Objects.md">&larr;&nbsp;Previous</a>&nbsp;&vert;&nbsp;<a href="./API.md">Next&nbsp;&rarr;</a></p>
