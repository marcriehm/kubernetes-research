## Kubernetes Objects

### Overview

Kubernetes *Objects*, or *Resources* are the core application-level entities within the system; they define your application
components and structure to Kubernetes. They may be seen as persistent “records of intent” within the
[declarative model](./Declarative.md "The Declarative Approach") - whenever differences exist between the current Object
state (the *status*) and the declared,
desired state (the *spec*), the various Kubernetes control loops and the scheduler work together to drive the system towards the
desired state. Ignoring system version differences, Objects are portable across Kubernetes implementations.

Kubernetes end users will work primarily with Objects, creating, updating, reading, and deleting them. Objects are the building blocks for applications, and so it is critical to understand what kinds
of Objects are available and what their capabilities are.

This site has been designed so that you can easily try out the accompanying YAML examples in your own Kubernetes
cluster. To create a cluster on Google Cloud Platform, see
[Create your Own Kubernetes Cluster on GCP/KE](./create_gke_cluster.md "Create your Own Kubernetes Cluster on
GCP/KE").

YAML definition files are applied as per the following examples:  
&nbsp;&nbsp;&nbsp;`kubectl apply -f YAMLFILE`	# create Objects from YAMLFILE  
&nbsp;&nbsp;&nbsp;`kubectl delete YAMLFILE`		# delete Objects from YAMLFILE  
&nbsp;&nbsp;&nbsp;`kubectl apply -f - < YAMLFILE`

Active Objects may be viewed per the following examples:  
&nbsp;&nbsp;&nbsp;`kubectl get KIND`                # list Objects of kind KIND  
&nbsp;&nbsp;&nbsp;`kubectl get KIND NAME`           # show high-level info about the named Object  
&nbsp;&nbsp;&nbsp;`kubectl describe KIND NAME`      # show more detailed info about the named Object  
&nbsp;&nbsp;&nbsp;`kubectl get -o yaml KIND NAME`   # get yaml spec and status for the named Object

The *kinds* ("kind" being a Kubernetes concept) of Objects discussed in this document are:
* Nodes
* Namespaces
* Pods and Containers
* Deployments
* StatefulSets
* DaemonSets
* Jobs and CronJobs
* Volumes, PersistentVolumes and PersistentVolumeClaims
* HorizontalPodAutoscalers
* Services
* Ingresses
* StorageClasses
* ConfigMaps
* Secrets
* Roles and RoleBindings

This is not an exhaustive set of Objects, but these are the principal ones for applications.

### Object Metadata

#### Labels and Label Selectors

See:
* https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/

*Labels* are metadata key/value pairs which are associated with Objects. They are used for identifying Objects,
particularly in groups; this may be for end-user queries or it might be to compose a higher-level object, like a
Service, from a set of lower-level Objects that are identified by their labels. Key syntax is \[domain-name/\]label-name,
where \[domain-name\] is optional. Some label examples are:  
&nbsp;&nbsp;&nbsp;`environment: "dev"`  
&nbsp;&nbsp;&nbsp;`release: "stable"`  
&nbsp;&nbsp;&nbsp;`microservice: "authentication"`

A recommended label strategy may be found at https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/.
It is important to derive a consistent approach to labeling.

*Label Selectors* are used to select sets of objects based on their labels. Example selectors are:  
&nbsp;&nbsp;&nbsp;`environment = prod`  
&nbsp;&nbsp;&nbsp;`tier != frontend`  
&nbsp;&nbsp;&nbsp;`microservice in (authentication, foobar)`  
&nbsp;&nbsp;&nbsp;`KEY`	# select items which have the given key defined

Other selectors include `notin`, Multiple selectors may be used in one selection. An example kubectl usage is:  
&nbsp;&nbsp;&nbsp;`kubectl get pods -l environment=production,tier=frontend`

Selectors are used in the creation of Services; you use a Label Selector to identify a group of Pods which are load-balanced
into a particular Service. In YAML Service definitions, they appear as follows:
```yaml
selector: {
    component : redis
}
```

#### Field Selectors

Field Selectors are another way of selecting Objects. They are similar to Label Selectors but they can access any
field in the Object spec or status. An example is:  
&nbsp;&nbsp;&nbsp;`kubectl get pods --field-selector status.phase=Running`

Note that Field Selectors are likely to be less efficient in queries than Label Selectors.

#### Annotations

Annotations are another form of metadata which may be associated with objects. Annotations are descriptive and
are not used to identify and select objects. The metadata in an annotation can be small or large, structured or
unstructured, and can include characters not permitted by labels.

### Nodes

See:
* https://kubernetes.io/docs/concepts/architecture/nodes/

Nodes represent computing resources (virtual or physical machines) on which Pods may run. Typically a Node is
a VM in the cloud environment. Nodes cannot be created within Kubernetes itself – they must be created externally in
the cloud environment and then assigned to Kubernetes. See
[Create a Node Pool in GKE](./gke_create_node_pool.md "Create a Node Pool in GKE").

Nodes may be queried in Kubernetes; the following are typical kubectl commands:  
&nbsp;&nbsp;&nbsp;`kubectl get nodes`  
&nbsp;&nbsp;&nbsp;`kubectl get -o yaml node NAME`  
&nbsp;&nbsp;&nbsp;`kubectl describe node NAME`

### Namespaces

See:
* https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
* https://cloud.google.com/blog/products/gcp/kubernetes-best-practices-organizing-with-namespaces

*Namespaces* provide a mechanism to define scopes which logically separate Objects by scope name within Kubernetes.
At a simplistic level, a namespace can be viewed as an isolated, virtual cluster.

Namespaces seem like a good way to separate development users from each other, however the Kubernetes documentation provides the
following advice: “Namespaces are intended for use in environments with many users spread across multiple teams,
or projects. For clusters with a few to tens of users, you should not need to create or think about namespaces at
all. Start using namespaces when you need the features they provide.” Nevertheless, Namespaces sound like a good idea
to me to keep developers from disrupting one another.

Namespaces are an inherent part of the [authorization scheme](./Authorization.md "Authorization"); permissions may be
assigned to individuals or groups based on the Namespace. It is also possible to
[set resource (CPU and memory) limits](https://kubernetes.io/docs/concepts/policy/resource-quotas "Resource quotas")
by Namespace.

While it is possible to use Namespaces to delineate between dev/qa/prod regions, best practices suggest that a separate
cluster be established for each region.

If you use Namespaces, there is an implication on DNS domain names (for example, the domain names of services). The
fully-qualified domain name of a Service
is of the form: `service-name.namespace-name.svc.cluster.local`. If you refer to a Service with just service-name,
it resolves to a service in the current namespace.

The Namespace is a part of the current [kubectl](./kubectl.md "Kubectl") context.

This [sample Namespace YAML](./Namespaces/namespace.yaml "Sample Namespace YAML") creates a Namespace which is
named ‘namespace1’ and which has a Label name=”namespace1”.

   
Common kubectl namespace commands include:  
&nbsp;&nbsp;&nbsp;`kubectl get namespaces [--show-labels]`  
&nbsp;&nbsp;&nbsp;`kubectl config set-context CONTEXT-NAME --namespace=NAMESPACE`  
&nbsp;&nbsp;&nbsp;`kubectl get pods –namespace=NAMESPACE`

The default namespace (if none is given) is named ‘default’.

### Pods and Containers

See:
* https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/

*Pods* are the smallest application deployment objects in Kubernetes. Pods run on Nodes. Pods execute in Docker and
contain one (usually) or more *Containers*, with each Container running a single Docker image. Each Pod runs one instance
of an application, for example a web application. Multiple Pods (grouped under a Service) are used to scale the
application horizontally.

Generally Pods only have one Container in them. Occasionally two (or, rarely, more than two) Containers might
be deployed in a Pod if the Containers are tightly coupled. Note that there is a special kind of container called
an initContainer which can perform initialization for a regular container.

Pods have their own, sepearate storage resources and network addresses. Each Pod gets its own IP address. Containers within a Pod
share the same: IP address; network namespace; and set of ports. Containers within a Pod may communicate with each
other through localhost.

Two Containers within a Pod do not share storage space; if you want to do that, you must explicitly arrange for
it via [Volume](./Volumes.md "Volumes") constructs (see below).

Pods may appear and disappear (e.g. due to failure or resource constraints) and **should be treated as ephemeral
entities**. They are generally not created directly by the user, but rather they are created as sub-Objects from
a Controller, for example a Deployment. Creating a Pod directly results in a single point of failure (although Kubernetes
will attempt to repair a broken Pod). A higher-level Controller should be used whenever possible: a Deployment, StatefulSet,
DaemonSet, Job, or CronJob; see Controllers, below.

### Controllers

Deployments, StatefulSets, DaemonSets, Jobs, and CronJobs are all types of Pod *Controllers*. This overloads the
term “Controller”, but the meaning should be clear from the context. Controllers are higher-level execution
entities which define and allow the management of groups of Pods. All Controller definitions contain *template* Pod
definitions, or *pod-specs*. Those templates are used to define Pods within the Controller.

#### Pod-specs

When a Controller is instantiated it creates one or more Pods. The Controller's Pod template specifies how to create
the Pods of the Controller. Pod templates may contain all of the attributes of Pods.

An example Pod definition is [here](./PersistentVolumes/HostPathPod.yaml "Example Pod Definition"). This Pod definition
is for example only and again, in general, Pods should not be created directly. An example Job definition, which creates
one Pod identical to that one, is
[here](./PersistentVolumes/HostPathJob.yaml "Example Controller (Job) Defintion"). This Job runs the shell command
`echo Hello from a Job && ls -l /var/log && sleep 60` within the
[Busybox](https://busybox.net/about.html "About Busybox") Docker image. It also mounts the host's (i.e. Node's)
directory `/var/log`.

#### Deployments

See:
* https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
* https://cloud.google.com/kubernetes-engine/docs/concepts/deployment

Deployments are the most common and important kind of Controller. A Deployment declares that a number of identical
Pods be scheduled for creation and execution across the Nodes of a cluster. Deployments do not say where the Pods are to be
run; that is determined by the Scheduler. A common example of a Deployment is a web application or a microservice. Deployments
typically run stateless services; for a stateful component, consider using a StatefulSet instead.

Deployments are one of the most important use cases for declarative configuration. Deployments allow you to:
* Grow or shrink the number of a particular kind of Pod to adjust for load;
* Rollout new versions of the Pod/Container images;
* Rollback an image update.

Deployments are self-healing: if any of the Pods fail, they will be restarted by the ReplicaSet control loop.
*ReplicaSets* underlie Deployments (as well as other Controllers) and are responsible for keeping the Pods
running. You typically should not create ReplicaSets directly (use one of the Controller types).

A Deployment specifies a template for its Pods. The Pod template determines what each Pod should look like:
what applications should run inside its containers, which volumes the Pods should mount, its labels, and more.

You can view Deployments in GCP/KE at Kubernetes Engine &rarr; Workloads.

Typical kubectl commands include:  
&nbsp;&nbsp;&nbsp;`kubectl apply -f DEPLOYMENT-FILE.yaml`  
&nbsp;&nbsp;&nbsp;`kubectl get --watch deployment`

Sample Deployment code can be found in [./Deployments](./Deployments "Sample Deployment Code"). The
[./Deployments/ip-webapp](./Deployments/ip-webapp "Sample Deployment webapp") directory contains a sample JSP
web application. You can build the project with Maven and create and upload (to docker.io) the relevant Docker images.
See the file [build-and-push.sh](./Deployments/ip-webapp/build-and-push.sh "Build script").

There are two versions of the webapp: v1 and v2, which can be used to demonstrate rolling updates. First use kubectl
to apply [./Deployments/ip-webapp-deploy-1.yaml](./Deployments/ip-webapp-deploy-1.yaml "Deploy webapp 1"),
i.e. `kubectl apply -f ip-webapp-deploy-1.yaml`. In GCP/KE,
navigate to Kubernetes Engine &rarr; Workload and you should see your Deployment.

Once the Deployment has finished, expose the webapp on a public IP (!) using a LoadBalancer Service: in GCP/KE,
click on the ip-webapp Deployment. Select Actions &rarr; Expose. Set the port to 8080 and the Service type
to Load balancer. Click the Expose button. Navigate to Kubernetes Engine &rarr; Services; you should see your
LoadBalancer with the status "Creating Service Endpoints". Refresh the page until the status is "Ok". Now you
should see an EndPoint with a hyperlinked URL. Click on the link. You should see a Tomcat page. Append "/ip-webapp"
to the URL and hit enter. You should see the webapp.

Architecturally you now have a publicly-exposed endpoint which load balances to three Tomcat instances behind
it. The ip-webapp prints out the IP address at which Tomcat was hit - this is the (private) IP address of the
particular Tomcat instance, not the public IP of the balancer itself. The IP address will likely be in the
CIDR range 10.8.0.0/16. To see the load balancing in effect, press and hold down the refresh/F5 button -
this refreshes the web page and you should see the private IP address cycle between the three values for
the three Tomcat instances.

Next we'll upgrade our webapp to v2 using a rolling update. In GCP/KE, navigate to Kubernetes Engine &rarr;
Workloads. On the command line, type `kubectl apply -f ip-webapp-deploy-2.yaml`. Then type
`kubectl get --watch deployment` - you can watch as Kubernetes cycles down Pods of the v1 app and cycles up
Pods of the v2 app. You can also watch deployment progress in GCP/KE. In the Tomcat window, hit the F5 button
to see that you now have v2 of the app. Congratulations - you've done a rolling update of a webapp with zero
downtime!

#### StatefulSets

See:
* https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/
* https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/
* https://cloud.google.com/kubernetes-engine/docs/concepts/statefulset
* https://kubernetes.io/docs/tasks/run-application/run-replicated-stateful-application/ \[replicated mysqld example\]

While Deployments are meant to be for stateless components, *StatefulSets* are controllers which are, as the name
suggests, meant for stateful ones. Like Deployments, StatefulSets manage (via ReplicaSets) sets of templated Pods.

Unlike Deployments, each Pod in a Statefulset is given a sticky identify, which is an ordinal number. The hostname
of a Pod in a stateful set is, for example, 'statefulsetname-0'. Pod behaviour can be changed based on the identity.

The statefulness of a StatefulSet must be managed via
[PersistentVolumes](./Volumes.md "Volumes"). I.e. a stateful app needs to have
somewhere to write state out, and that is done via a PersistentVolume associated with the Pods of the
StatefulSet.

A common use case for a multi-Pod StatefulSet is a read-write database master with a series of read-only slaves.
See the mysqld example mentioned above.

The advantage to using a StatefulSet with one Pod over an explicitly-defined Pod is that StatefulSets will arrange
for Pod restart if the Node on which the Pod is running fails (while a "bare" Pod would just disappear).

#### DaemonSets

See:
* https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/
* https://cloud.google.com/kubernetes-engine/docs/concepts/daemonset

A *DaemonSet* is a Controller which arranges for a single Pod to be run on each of a set of matching Nodes (or
perhaps all Nodes). If a Node is added to or deleted from the cluster, the DaemonSet will spin up or tear down
a Pod on it. DaemonSets are used within Kubernetes itself to collect Pod logs and Node and Pod performance metrics.

#### Jobs and CronJobs

See:
* https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/
* https://cloud.google.com/kubernetes-engine/docs/how-to/jobs
* https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/

A *Job* is a Controller which runs a set of one or more Pods which are **expected** to terminate (hopefully successfully).
This is in contrast to a Deployment which runs a set of Pods which are not expected to terminate. Jobs are for batch
processing.

A Job can run a single Pod or it can run multiple Pods in parallel. If multiple Pods are run, it is up to application
logic to make sure that the workload is divided properly between them.

The Job itself as well as its Pods are not cleaned up automatically upon Job creation. This is so that logs may be
checked. Jobs should be cleaned up either manually (via interactive kubectl) or automatically (via a script).

In case of Job failure partway through, Job logic should be written to be idempotent - in other words, so that the
same logic can be run correctly multiple times.

A *CronJob* is a Job which runs on a regular schedule with cron-like configuration.

### HorizontalPodAutoscaler

See:
* https://cloud.google.com/kubernetes-engine/docs/how-to/scaling-apps

This discussion is about the autoscaling/v1 version of autoscaling. New features are under development as autoscaling/v2beta2
(https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.14/#horizontalpodautoscaler-v2beta2-autoscaling). The new
features include scaling by memory and by custom resource types.

A *HorizontalPodAutoscaler* (HPA) is an Object which configures horizontal scaling, based on CPU load, of the Pods in a Deployment.
Scaling is performed by comparing actual CPU resource usage against a target which is set in the HPA spec. The YAML field
for the target is `spec.targetCPUUtilizationPercentage`. The "utilization" is the ratio between the current average CPU
usage  and the requested amount from the Deployment (`deployment.spec.template.spec.containers[].resources.requests.cpu`);
when the utilization deviates substantially from the target, the number of Pods is scaled accordingly.

Additional fields include `spec.minReplicas` and `spec.maxReplicas`, which set the obvious limits.

An example HPA is given [here](./HorizontalPodAutoscalers/hpa.yaml "HPA Example").

### Services

See:
* https://kubernetes.io/docs/concepts/services-networking/service/
* https://cloud.google.com/kubernetes-engine/docs/concepts/service

A *Service* groups together the network endpoints of a set of Pods into a single resource, load balancing across
the Pods. Services may have a public IP address, or they may be private. Examples of Services are a public,
load-balanced webserver front end and a (private) load-balanced back-end microservice.

A Service identifies its underlying Pods via a label selector in YAML path .spec.selector. For example, the
following Service definition selects Pods which possess the label `app: service_test_pod`:

```yaml
kind: Service
type: ClusterIP
apiVersion: v1
metadata:
  name: service-test
spec:
  selector:
    app: service_test_pod
  ports:
  - port: 80
    targetPort: http
```
A Service load balances traffic across its matching Pods.

Services come in three main *types*:
1. ClusterIP
2. NodePort - a superset of ClusterIP
3. LoadBalancer - a superset of NodePort

A *ClusterIP* service possesses a virtual IP address within the Service network CIDR block (the other networks
are the Node network and the Pod network). Packets sent to cluster-ip:port will be load balanced to all matching
pods at pod-ip:targetPort. So you can open up a connection to cluster-ip:port and you will connect, via round-
robin selection, to one Pod on port targetPort.

While you might imagine something like a proxy server sitting on cluster-ip:port and routing to its Pods, that
is a misleading picture. In reality there is no entity sitting on the network at cluster-ip:port. The Service is
implemented as a set of IPVS routing rules on each Node. See
https://medium.com/google-cloud/understanding-kubernetes-networking-services-f0cb48e4cc82.

A ClusterIP Service has a domain name equal to service-name.NAMESPACE.svc.cluster.local. The domain name should
be used to connect to the Service.

A *NodePort* Service builds on top of a ClusterIP Service by opening a network port on each Node. Traffic routed
to node-ip:nodePort will be routed (via IPVS round-robin again) to one of the underlying Pods.

A *LoadBalancer* Service builds on top of a NodePort Service by adding an externally-routable public IP address.
LoadBalancers can therefore be used for network ingress; see, however, the Ingress Object which provides another
option.

Note that all Services are at Layer 4 in the network stack and so they know nothing of the specific L7
protocol in use (e.g. HTTP).

The name LoadBalancer might cause some confusion: it is important to recognize that both ClusterIP and NodePort
Services are load-balanced in their own rights.

See [here](./Services/ip-webapp-loadbalancer.yaml "LoadBalancer example") for an example of LoadBalancer YAML.

See https://cloud.google.com/kubernetes-engine/docs/concepts/network-overview and
https://kubernetes.io/docs/concepts/services-networking/service/ for interesting explanations of how Services
are actually implemented using IPVS routing rules.

### Ingresses

See:
* https://kubernetes.io/docs/concepts/services-networking/ingress/
* https://kubernetes.io/docs/concepts/services-networking/ingress/

An *Ingress* is a publicly-available Layer 7 HTTP(S) proxy. An Ingress can be used to provide external connectivity as
an alternative to a LoadBalancer Service. An Ingress can be used to: give services externally-reachable URLs; perform
fanout based on URL; load balance traffic; terminate SSL; and provide name-based virtual hosting.

The Service underlying an Ingress **must** be of type NodePort - a ClusterIP Service will not work. Ingresses might
be implemented by Node.js or a similar system.

Create a NodePort Service by applying [this file](./Ingresses/ip-webapp-nodeip.yaml "NodePort Example"). Create
an Ingress on this Service with [this file](./Ingresses/ip-webapp-ingress.yaml "Ingress Example"). WAIT for the
Ingress to be created. Test via the URL http://EXTERNAL-IP/ip-webapp where EXTERNAL-IP is the external IP
allocated for the Ingress.

### Volumes, PersistentVolumes and PersistentVolumeClaims

Volumes are used by Pods to refer to storage that is external to those pods. That storage might be defined at the
Node level or higher, and may or may not be shareable between Containers or Pods. See [Volumes](./Volumes.md "Volumes").

### ConfigMaps

See:
* https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/
* https://medium.com/google-cloud/kubernetes-configmaps-and-secrets-part-2-3dc37111f0dc

A *ConfigMap* is an Object which stores configuration information for use by Pods. Pods can be configured to
read ConfigMaps either as environment variables or as files. The file approach is superior because the resulting files
are dynamic: when a ConfigMap is updated, the corresponding file in a Container is updated (while environment variables
are set and read once at Pod start time and never change). Note that there are several ways of creating ConfigMaps but
we'll stick to a declarative mechanism.

Note that ConfigMaps are *not* intended to be used for sensitive information, like passwords. Use Secrets instead.

Create a two-file ConfigMap named 'my-config-map' with
[this ConfigMap YAML](./ConfigMaps/my-config-map.yaml "Example ConfigMap").
Create a Pod which mounts that ConfigMap, as a directory, with
[this Pod YAML](./ConfigMaps/my-config-map-pod.yaml "Example Pod for ConfigMap").
Within two minutes (the lifetime of the Pod), open up a terminal to the Pod with:  
&nbsp;&nbsp;&nbsp;`kubectl exec -it my-config-map-pod -- sh`  
and type:  
&nbsp;&nbsp;&nbsp;`cd /etc/my-config-map`  
&nbsp;&nbsp;&nbsp;`cat my-config-file-1`

### Secrets

See:
* https://kubernetes.io/docs/concepts/configuration/secret/

A *Secret* is an Object which is intended to store sensitive configuration information. They are very similar to ConfigMaps,
except for:
* The data of a Secret is base64 encoded
* The value of a Secret is never exposed when using kubectl
* When mounted into a file for reading by a pod, a `tmpfs` file system is used

**Please note the "Best practices" section in the above URL.**

Secrets are an exception to the "declarative rule". Because Secrets contain sensitive information, they should never be
checked into version control, and they should be stored on disk only temporarily, if at all. The creation of Secrets
in a prod environment should be done manually.

The file [./Secrets/my-secret](./Secrets/my-secret "A secret file") contains a Secret value. The file
[./Secrets/my-secret.yaml](./Secrets/my-secret.yaml "A Secret YAML definition") contains a template for a Secret
definition. The file [./Secrets/create-my-secret.sh](./Secrets/create-my-secret.sh "Secret-processing shell script")
is an example shell script which creates the Secret.

<p align="center"><a href="./Architecture.md">&larr;&nbsp;Previous</a>&nbsp;&vert;&nbsp;<a href="./HealthChecking.md">Next&nbsp;&rarr;</a></p>
