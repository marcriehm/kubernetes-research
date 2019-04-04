## Kubernetes Objects

### Overview

Kubernetes *Objects* are the core application-level entities within the system; they define your application
components and structure to Kubernetes. They may be seen as persistent “records of intent” within the declarative
model - whenever differences exist between the current Object state (the *status*) and the declared,
desired state (the *spec*), the various Kubernetes control loops and the scheduler work to drive the system towards the
desired state. Ignoring system version differences, Objects are portable across Kubernetes implementations.

Kubernetes end users will work primarily with Objects, creating, updating, reading, and deleting them (in a declarative
fashion, of course). Objects are the building blocks for applications, and so it is critical to understand what kinds
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

Objects are also called *Resources*.

The *kinds* ("kind" being a Kubernetes concept) of Objects discussed in this document are:
* Nodes
* Namespaces
* Pods and Containers
* Deployments
* StatefulSets
* DaemonSets
* Jobs and CronJobs
* HorizontalPodAutoscalers
* Services
* Ingresses
* PersistentVolumes and PersistentVolumeClaims
* StorageClasses
* ConfigMaps
* Secrets
* Roles and RoleBindings

This is not an exhaustive set of Objects, but these are the principal ones for applications.

### Object Metadata

#### Labels and Label Selectors

*Labels* are metadata key/value pairs which are associated with Objects. They are used for identifying Objects,
particularly in groups. Key syntax is \[domain-name/\]label-name, where \[domain-name\] is optional. Some label
examples are:
&nbsp;&nbsp;&nbsp;`environment: "dev"`  
&nbsp;&nbsp;&nbsp;`release: "stable"`  
&nbsp;&nbsp;&nbsp;`microservice: "authentication"`

A recommended label strategy may be found at https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/ .

*Label Selectors* are used to select sets of objects based on their labels. Example selectors are:
&nbsp;&nbsp;&nbsp;`environment = prod`  
&nbsp;&nbsp;&nbsp;`tier != frontend`  
&nbsp;&nbsp;&nbsp;`microservice in (authentication, foobar)`  
&nbsp;&nbsp;&nbsp;`KEY`	# select items which have the given key defined

Other selectors include `notin`, Multiple selectors may be used in one selection. An example kubectl usage is:  
&nbsp;&nbsp;&nbsp;`kubectl get pods -l environment=production,tier=frontend`

Selectors are used in (YAML) service definitions as follows:
```yaml
selector: {
    component : redis
}
```

Label Selectors are used, for example, in Services to associate Pods with Services, defining the set of Pods which
fulfill a Service.

#### Field Selectors

Field Selectors are another way of selecting Objects. They are similar to Label Selectors but they can access any
field in the Object spec or status. An example is:  
&nbsp;&nbsp;&nbsp;`kubectl get pods --field-selector status.phase=Running`

#### Annotations

Annotations are another form of metadata which may be associated with objects. Annotations are descriptive and
are not used to identify and select objects. The metadata in an annotation can be small or large, structured or
unstructured, and can include characters not permitted by labels.

### Nodes

See:
* https://kubernetes.io/docs/concepts/architecture/nodes/

Nodes represent computing resources (virtual or physical machines) on which Pods may run. Typically a Node is
a VM in the cloud environment. Nodes cannot be created via Kubernetes – they must be created externally in
the cloud environment and then assigned to Kubernetes. See
[Create a Node Pool in GKE](./gke_create_node_pool.md "Create a Node Pool in GKE).

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

Namespaces seem like a good way to separate development users, however the Kubernetes documentation provides the
following advice: “Namespaces are intended for use in environments with many users spread across multiple teams,
or projects. For clusters with a few to tens of users, you should not need to create or think about namespaces at
all. Start using namespaces when you need the features they provide.” Personally Namespaces sound like a good idea
to keep developers from disrupting one another.

Namespaces should not be used to delineate between dev/qa/prod regions: different clusters should be established
for each region.

If you use Namespaces, there is an implication on DNS domain names. The fully-qualified domain name of a Service
is of the form: `service-name.namespace-name.svc.cluster.local`. If you refer to a Service with just service-name,
it resolves to a service in the current namespace.

Resource limits may be applied to Namespaces, via Resource Quotas. Resource quotas are not discussed in this document.

The Namespace is a part of the current kubectl context.

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

*Pods* are the smallest application deployment objects in Kubernetes. Pods run on Nodes. Pods run in Docker and
contain one (usually) or more *Containers*. Each Container runs a single Docker image. Each Pod runs one instance
of an application, for example a web application. Multiple Pods are used to scale horizontally.

Generally Pods only have one Container in them. Occasionally two (or, rarely, more than two) Containers might
be deployed in a Pod if the Containers are tightly coupled. Note that there is a special kind of container called
an initContainer which can perform initialization for a regular container.

Pods have unique storage resources and network addresses. Each Pod gets its own IP address. Containers within a Pod
share the same: IP address; network namespace; and set of ports. Containers within a Pod may communicate with each
other through localhost.

Two Containers within a Pod do not share storage space; if you want to do that, you must explicitly arrange for
it via PersistentVolumeClaims.

Pods may appear and disappear (e.g. due to failure or resource constraints) and should be treated as ephemeral
entities. Pods are generally not created directly by the user, but rather they are created as sub-Objects from
a Controller. Creating a Pod directly results in a single point of failure (although Kubernetes will attempt
to repair the broken Pod); Pods are typically only used directly for situations which require persistent storage,
like a mysql server. A higher-level Controller should be used whenever possible: a Deployment, StatefulSet,
DaemonSet, Job, or CronJob; see Controllers, below.

### Controllers

Deployments, StatefulSets, DaemonSets, Jobs, and CronJobs are all types of Pod *Controllers*. This overloads the
term “Controller”, but the meaning should be clear from the context. All Controller definitions contain template
Pod definitions. Those templates are used to create Pods within the Controller.

Note that Deployments are one of the most important Object types in Kubernetes.

#### Deployments

See:
* https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
* https://cloud.google.com/kubernetes-engine/docs/concepts/deployment

Deployments are perhaps the most common kind of Controller. A Deployment declares that a number of identical
Pods be scheduled for creation and execution. Deployments do not say where the Pods are to be run; that is
determined by the Scheduler. A common example of a Deployment is a web application or a microservice. Deployments
typically run stateless services; for a stateful component, consider using a StatefulSet instead.

Deployments are one of the most important use cases for declarative configuration. Deployments allow you to:
* Grow or shrink the number of Pods to adjust for load;
* Rollout new versions of the Pod/Container images;
* Rollback an image update.

Deployments are self-healing: if any of the Pods fail, they will be restarted by the Deployment (actually, ReplicaSet)
control loop.

A Deployment specifies a template for its Pods. The Pod template determines what each Pod should look like:
what applications should run inside its containers, which volumes the Pods should mount, its labels, and more.

kubectl get --watch deployment

#### StatefulSets

...

####DaemonSets

...

#### Jobs and CronJobs

See:
https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/
https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/
HorizontalPodAutoscaler

...

### Services

...

See https://medium.com/google-cloud/understanding-kubernetes-networking-services-f0cb48e4cc82 and https://kubernetes.io/docs/concepts/services-networking/service/ for interesting explanations of how Services are actually implemented using IPVS routing rules.

### Ingresses

...

### PersistentVolumes and PersistentVolumeClaims

See:
* https://kubernetes.io/docs/concepts/storage/persistent-volumes/
* https://cloud.google.com/kubernetes-engine/docs/concepts/persistent-volumes

Kubernetes’s *PersistentVolume* and *PersistentVolumeClaim* Objects are the mechanisms to give applications
persistent storage. A PersistentVolume represents actual storage. A PersistentVolumeClaim is a ticket for a Pod to
use a PVC.

To use a PersistentVolume, a disk resource must first be created in the cloud provider. The PersistentVolume makes
the disk known to Kubernetes, and the PersistentVolumeClaim allows an association between Pods and the PersistentVolume.

**Note that what follows in this section is a nuisance. There is a better way to do this which will be explained in
StorageClasses, below.**

#### Gke disk creation

To create a Google Compute Engine disk, follow the instructions [here](./PersistentVolumes/gke_disk_creation.md "GCE
Disk Creation").

#### Kubernetes Volume Creation

Now that we have the disk created and formatted (phew!)...

Create a PersistentVolume with
[./PersistentVolumes/pv-disk-persistentvolume.yaml](./PersistentVolumes/pv-disk-persistentvolume.yaml "Create a PersistentVolume").
Create a PersistentVolumeClaim with
[./PersistentVolumes/pv-disk-persistentvolumeclaim.yaml](./PersistentVolumes/pv-disk-persistentvolumeclaim.yaml "Create a PersistentVolumeClaim").
Then view the PVC in GCP at Main Menu &rarr; Kubernetes Engine &rarr; Storage &rarr; PersistentVolumeClaims.
Create a Deployment which uses that PVC with
[./PersistentVolumes/pv-disk-deployment.yaml](./PersistentVolumes/pv-disk-deployment.yaml "Create a Deployment for the PVC").
Wait for that Deployment to finish.

To see the mounted disk within a Pod of the Deployment, perform the following steps:
```
kubectl get pods -l app=pv-disk	    # list pods
# Copy one of the pods’ names.
Kubectl exec -it POD-NAME sh		# open shell in that pod
ls -aCFl /pv-disk-volume            # here your command executes within the Container of the Pod (docker magic)
mount | grep pv-disk-volume		    # look at the mounts
```

Note that this example creates a multiply-mounted (multiple pods), read-only disk volume. You can also create
a singly-mounted read-write volume, e.g. for a database server. To create a multiply-mounted, read-write volume,
you must use something like NFS. I did not explore NFS.

### StorageClasses
See:
* https://kubernetes.io/docs/concepts/storage/storage-classes/
* https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/ssd-pd
* https://cloud.google.com/kubernetes-engine/docs/concepts/persistent-volumes
* https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/regional-pd

The problem with the PersistentVolume approach is that it doesn’t scale well – for each PVC which is created,
a disk must be provisioned, formatted, and managed in the back end (e.g. in the cloud provider). *StorageClasses*
provide a way of bypassing the cloud-specific disk creation step so that volumes may be created completely
declaratively.

Note that there is a default storage class on GKE named “standard”. You can see this in GCP &rarr; GKE &rarr;
Storage &rarr; Storage Classes, or in `kubectl get sc`. In GKE the standard storage class uses standard
(non-SSD) disks.

To create an SSD storage class, look at [StorageClasses/storageclass.yaml](./StorageClasses/storageclass.yaml "Create a Storage Class").
To create a singly-mounted, read-write PersistentVolumeClaim in that class, see
[StorageClasses/storageclass-pvc.yaml](./StorageClasses/storageclass-pvc.yaml "Create a PVC for a StorageClass").
To create a single Pod which mounts that claim, see
[StorageClasses/storageclass-pod.yaml](./StorageClasses/storageclass-pod.yaml "Create a Pod for a Storage Class").

### ConfigMaps

...

### Secrets

...

<p align="center"><a href="./Architecture.md">&larr;&nbsp;Previous</a>&nbsp;&vert;&nbsp;<a href="./API.md">Next&nbsp;&rarr;</a></p>
