## Health Checking

See:
* https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/

Pods need to have their health checked regularly, so that Kubernetes knows:
1. Which Pods are healthy and can be included in Services;
2. Which Pods are not healthy and must be restarted.

There are two kinds of health checks:
1. Liveness probes;
2. Readiness probes.

<p align="center"><a href="./Objects.md">&larr;&nbsp;Previous</a>&nbsp;&vert;&nbsp;<a href="./API.md">Next&nbsp;&rarr;</a></p>
