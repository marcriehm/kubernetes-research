## Authentication

### Introduction

Kubernetes does not store users or groups as Objects (entities) in the system. Instead, it supports various
authentication protocols and extracts user and
group (aka subject) information from the protocol and then associates the resulting opaque string
subject ID with roles in a rich REST-based RBAC scheme.

Possible authentication mechanisms include HTTP(S) Basic Authentication, Bearer tokens, OpenID Connect, and x509
client-side certificates. Note that OIDC can facilitate integration of Active Directory with Kubernetes. This document
discusses OIDC/OAuth2 and client-side certs.

Client-side certificates are not recommended for use in a real project, because there is no way in Kubernetes to
revoke a certificate. Once access is granted via a particular certificate, it will always be available. OIDC is
the recommended authentication mechanism.

Kubernetes is - when used properly - a secure system, with authentication and authorization utilized
intra-system-components, as well as between admin users (presumably using kubectl) and the system. For example, all
kubelets authenticate with the API server and with other control-plane components as needed. All communication,
intra and inter, should be TLS.

Note that service accounts, which *are* managed as Objects/entities
in Kubernetes, should not be used for end-user/CLI interactions. Following good practices, service accounts are strictly for
use in intra-component communications.

A real-world authentication and authorization implementation will use groups heavily; these should be well planned
in advance.

### x509 Certificates

PKI infrastructure is built into Kubernetes from the ground up. The generation and use of client-side
certificates is therefore straightforward.

An x509 certificate carries a common name (/CN=) and zero or more organizations (/O=). The common name is the
Kubernetes user ID and the organizations are the groups. The certificates must be signed by the Kubernetes PKI
infrastructure itself; a facilitating API exists and is accessible from kubectl.

Upon authentication of a user, the API server (which kubectl talks to) validates the certificate and extracts the
user and group IDs. It then authorizes the request (see below) and either rejects or processes it. Again, note that
users and groups are not "objects" or entities in Kubernetes; they are simply strings.

Creation of a user involves the following steps:
1. Create a private key;
2. Generate a Certificate Signing Request (CSR);
3. Accept/sign the CSR;
4. Extract and save the resulting, signed certificate;
5. (Presumably) configure the certificate into kubectl.

A script [create-cert.sh](./Authentication/create-cert.sh "create-cert.sh") has been created to perform the first
four steps. A script [kubectl-config.sh](./Authentication/kubectl-config.sh "kubectl-config.sh") has been
created to perform the last step. The first script in particular is not for use outside of development.

### OpenID Connect
OpenID Connect, or OIDC, is the preferred authentication mechanism. OIDC supports both users and groups.
Apparently Kubernetes OIDC can interface with Active Directory, but that has not been explored.

#### GCP/KE Considerations
While Kubernetes has no notion of user or group entities (again, it only knows them as opaque strings), the GCP/KE
web-based UI does have user and group entities, and they must be used in the setup of OIDC. Users and groups serve two
purposes in GCP/KE:
1. Authentication and authorization for the GCP/KE web-based UI;
2. Authentication and authorization for kubectl/gcloud communications with the GCP/KE backend.

I will refer to these users and groups as GCP users and GCP groups.

GCP users are Google Account users. GCP groups are Google Groups. Both have e-mail addresses associated with
them, e.g. someone\@gmail.com or somegroup\@googlegroups.com. Note that Google Accounts may be associated with
any e-mail address and so strictly they do not have to be in the domain gmail.com.

So, outside of Active Directory / LDAP, to manage groups you need to manage Google Groups.

To associate a Google Account or Group with GCP the admin user navigates to GCP Main Menu &rarr; IAM and admin
&rarr; IAM. Click the Add button near the top and enter in the e-mail address of the user or the group. The suggested
initial roles to add are `Project.Viewer` and `Kubernetes Engine.Kubernetes Engine Developer`, but more research needs to
be done here. Again, these credentials and permissions control communication between gcloud/kubectl and the backend,
and I believe they also control permissions on the GCP/KE UI.

After the Google Accounts and Groups have been associated with GCP, each user needs to configure `gcloud` and `kubectl`
with their OIDC/OAuth2 credentials. To do this, first type:  
&nbsp;&nbsp;&nbsp;`gcloud init`  
This takes the user through a browser OIDC/OAuth2 login process.

Next type:  
&nbsp;&nbsp;&nbsp;`gcloud container clusters get-credentials CLUSTER-ID --zone COMPUTE-ZONE --project PROJECT-ID`  
where CLUSTER-ID is the GKE cluster ID (e.g. 'standard-cluster-1') and COMPUTE-ZONE and PROJECT-ID are the
GCP compute zone (e.g. 'us-central1-a') and GCP project ID (e.g. 'fast-alligator-123456') respectively. **This
step exports the OIDC/OAuth2 credentials from gcloud into ~/.kube/config for kubectl and sets up a kubectl context
for subsequent use there.** After this, kubectl should work.

#### kubectl config

[kubectl](./kubectl.md "Kubectl") is the primary Kubernetes administration tool; it is a CLI. To handle real-world use cases, it is possible
to associate multiple clusters, namespaces, and users together into *contexts*. Users can easily switch contexts,
changing the environment they're operating against.

kubectl config information is stored in `~/.kube/config`, in yaml format. The kubectl CLI has a set of commands
which simplify the management of the config file and the use of clusters, namespaces, and users. See
`kubectl config --help`.

You can edit the `~/.kube/config` files yourself, for example to clean up and make more meaningful the names
of instances, users, and contexts (the auto-generated ones being full of hashes).

<p align="center"><a href="./API.md">&larr;&nbsp;Previous</a>&nbsp;&vert;&nbsp;<a href="./Authorization.md">Next&nbsp;&rarr;</a></p>
