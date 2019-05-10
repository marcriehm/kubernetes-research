## Metrics and Alerting

See:
* https://kubernetes.io/docs/tasks/debug-application-cluster/resource-usage-monitoring/

It is crucial to monitor any production system for performance and correctness metrics, and to send alerts when those metrics warrant
it. The Kubernetes core does not provide any native metrics monitoring or alerting, but adjunct systems are avaliable and are
always configured into prod systems.

In Google Cloud Platform the principal performance metrics, correctness metrics, and alert functionality is all available from
[Stackdriver](https://app.google.stackdriver.com/ "Stackdriver"): GCP Main Menu &rarr; Stackdriver &rarr; Monitoring. Metrics are
available at all levels: application, Kubernetes, and GCP Compute Engine.

Other options include Prometheus and Sysdig; these are discussed in the link above.

It is not clear what the level of support is for metrics and alerting in a vanilla kops-deployed cluster.

<p align="center"><a href="./Logging.md">&larr;&nbsp;Previous</a>&nbsp;&vert;&nbsp;<a href="./Resources.md">Next&nbsp;&rarr;</a></p>
