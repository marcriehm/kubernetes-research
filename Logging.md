## Logging and Auditing

See
* https://kubernetes.io/docs/concepts/cluster-administration/logging/
* stackdriver logging: https://kubernetes.io/docs/tasks/debug-application-cluster/logging-stackdriver/
* `kubectl logs --help`

GKE uses the fluentd log-processing system to capture and store logs. Fluentd is marketed as part of the
Stackdriver suite.

### Application Logging

Application components, running in Pods, should log to stdout and/or stderr because the Kubernetes infrastructure
will capture these logs for later querying. Other log destinations (e.g.files; syslogd; systemd-journal) are possible
but they require more setup.

Application logs are available in the GCP/KE UI, for example at Kubernetes Engine &rarr; Workloads &rarr;
\[Deployment details\] &rarr; Container logs. This is a stackdriver query.

Example kubectl log queries are:  
&nbsp;&nbsp;&nbsp;`kubectl logs --help`  
&nbsp;&nbsp;&nbsp;`kubectl logs --lapp=ip-webapp` - label-based query  
&nbsp;&nbsp;&nbsp;`kubectl logs deployment/ip-webapp` - logs from first pod (only) of deployment ip-webapp  
&nbsp;&nbsp;&nbsp;`kubectl get pod -lapp=ip-webapp` - list pods of ip-webapp  
&nbsp;&nbsp;&nbsp;`kubectl logs POD-NAME` - show logs from particular pod

### Auditing



<p align="center"><a href="./Authorization.md">&larr;&nbsp;Previous</a>&nbsp;&vert;&nbsp;<a href="./Resources.md">Next&nbsp;&rarr;</a></p>
