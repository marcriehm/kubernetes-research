## Logging and Auditing

See
* https://kubernetes.io/docs/concepts/cluster-administration/logging/
* stackdriver logging: https://kubernetes.io/docs/tasks/debug-application-cluster/logging-stackdriver/
* `kubectl logs --help`

Behind the scenes, GKE uses the [fluentd](https://www.fluentd.org/ "fluentd") log-processing system to capture and store logs. Fluentd
is marketed as part of the [Stackdriver](https://cloud.google.com/stackdriver/ "Stackdriver") suite. fluentd captures logs, persists
and centralizes them.

### Application Logging

Application components, running in Pods, should log to stdout and/or stderr because the Kubernetes infrastructure (fluentd, in the
case of GCP/KE) will capture these logs for later querying. Other initial log destinations (e.g.files; syslogd; systemd-journal)
are possible but they require more setup.

Application logs are available for query via two mechanisms:
1. kubectl;
2. GCP/KE UI: for example at Kubernetes Engine &rarr; Workloads &rarr; \[Deployment details\] &rarr; Container logs. This is a
stackdriver query.

Example kubectl log queries are:  
&nbsp;&nbsp;&nbsp;`kubectl logs --help`  
&nbsp;&nbsp;&nbsp;`kubectl logs --lapp=ip-webapp` - label-based query  
&nbsp;&nbsp;&nbsp;`kubectl logs deployment/ip-webapp` - logs from first pod (only) of deployment ip-webapp  
&nbsp;&nbsp;&nbsp;`kubectl get pod -lapp=ip-webapp` - list pods of ip-webapp  
&nbsp;&nbsp;&nbsp;`kubectl logs POD-NAME` - show logs from particular pod

### Auditing

See:
* https://kubernetes.io/docs/tasks/debug-application-cluster/audit/
* https://medium.com/@noqcks/kubernetes-audit-logging-introduction-464a34a53f6c

The Kubernetes API server maintains an audit log of all requests - both write and read - made to a cluster. Event logging is
customizable and is configured via *Policy* objects; see the links above. The log entries take the form of *Event*
Objects. These can be accessed via `kubectl get events`. 

<p align="center"><a href="./Authorization.md">&larr;&nbsp;Previous</a>&nbsp;&vert;&nbsp;<a href="./Resources.md">Next&nbsp;&rarr;</a></p>
