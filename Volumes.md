## Volumes

See:
* https://kubernetes.io/docs/concepts/storage/persistent-volumes/
* https://kubernetes.io/docs/concepts/storage/volumes/
* https://cloud.google.com/kubernetes-engine/docs/concepts/persistent-volumes

*Volumes* represent external, non-volatile storage for Pods. The lifetime of a volume may be that of a Pod or it
may persist beyond the life of any one pod. Some types of volumes may be shared between Containers. Volumes
may be read-only or read-write. Volumes of Pods are analogous to Volumes of Docker containers.

There is a wide range of volume types; see https://cloud.google.com/kubernetes-engine/docs/concepts/persistent-volumes.
Some of these volume types are specific to particular environments (i.e. cloud-providers). The types discussed here are:
* hostPath
* emptyDir
* persistentVolumeClaim
* nfs

Volumes are defined at the level of Pods and they are *mounted* into Containers. For some volume types there may
be a need to provision external storage separately in the cloud environment.

### hostPath Volumes

The following two YAML files
define hostPath volumes for Containers; hostPath volumes are exactly analogous to docker volumes mounted with
`docker -v HOST-PATH:CONTAINER-PATH` - they mount storage from the external OS into the Container.
* [hostPath Pod example](./PersistentVolumes/HostPathPod.yaml "hostPath Pod Example")
* [hostPath Job example](./PersistentVolumes/HostPathJob.yaml "hostPath Job Example")

### emptyDir Volumes

emptyDir volumes are, as the name implies, initially empty. They cannot be shared between Pods but they may be
shared read-write between Containers of a single Pod. An emptyDir volume might be useful to exchange data between two
tightly-coupled Containers or as a scratch area, e.g. for disk sorts.
* [emptyDir Pod example](./PersistentVolumes/EmptyDirPod.yaml "emptyDir Pod Example")

### PersistentVolumes and PersistentVolumeClaims

The Kubernetes way of sharing persistent data between Pods is is through the use of PersistentVolumes and
PersistentVolumeClaims. A PersistentVolume (PV) represents storage which is independent of any particular Pod.
A PersistentVolumeClaim (PVC) is a ticket for a Pod to use a PV.

To use a PersistentVolume, a disk resource must first be created in the cloud provider. The PersistentVolume makes
the disk known to Kubernetes, and the PersistentVolumeClaim allows an association between Pods and the PersistentVolume.

**Note that what follows in this section is a nuisance. There is a better way to do this which will be explained in
StorageClasses, below.**

#### GCP disk creation

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
you must use something like NFS.

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

### NFS

See https://github.com/kubernetes/examples/tree/master/staging/volumes/nfs.
