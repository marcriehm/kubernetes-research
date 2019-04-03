# Create your Own Kubernetes Cluster on GCP/KE

* Ensure you have a Google Account; this could be a gmail account or it could be a Google Account that is associated with
another e-mail.
* Direct your browser to https://console.cloud.google.com.
* Activate your account (top right-hand corner); use an individual account, not business. You must enter a credit-card
number, but you will get $300 USD in free credits. You should be in a project called My First Project.
Make note of the Project ID which consists of `random_adjective - random_noun 6_digit_hash`.
  * Do keep track of your billing at GCP &rarr; Billing.
  * Control your costs by using resources (CPU, memory, disk) moderately.
  * Make sure to close your account (see below) to avoid unnecessary charges.
* Download and install the Google Cloud SDK from https://cloud.google.com/sdk/docs/quickstart-linux (versions are
available for Windows and Mac but I haven’t tried those). Follow the instructions on that page, i.e. the steps are:
  * `curl`
  * `tar`
  * `install.sh`
  * `gcloud init`
    * Make a note of your default compute zone.
* Now follow along the instructions from https://cloud.google.com/kubernetes-engine/docs/quickstart (“Local
Shell” version):
  * From your linux terminal, run `gcloud components install kubectl`.
  * `gcloud config set project PROJECT_ID` to the funny project ID created early on.
  * `gcloud config set compute/zone COMPUTE_ZONE` where COMPUTE_ZONE was entered in gcloud init.
* Return to the GCP console in your browser. From the main menu, click on Kubernetes Engine.
* Click on Enable Billing. Wait.
* At this point tou should still be on Kubernetes Engine &rarr; Clusters.
* Click Create Cluster. The defaults are fine, so just click Create. Wait.
* Click on the cluster name, and then click on the Nodes tab just to see the Nodes.
* Navigate back to the Cluster Details tab.
* In the upper right-hand corner of the page, click on the Connect button. Copy the Command-Line Access string to the clipboard.
* Return to your Linux terminal and paste that command (`gcloud container cluster get-credentials ...`) in and run it. This initializes your `~/.kube/config` file to point to your GKE cluster; after this, kubectl should work.
* Now type `gcloud container clusters list` to see your cluster details.
* Type `kubectl get nodes` – you should see a list of nodes.
Et voil&agrave; – you’re connected with kubectl to your Kubernetes cluster.

# Tearing Down your GCP/GKE Account

When you're finished with it, tear down your GCP/GKE account to clean it up and prevent billing. 
* From the main GCP menu, choose Kubernetes Engine &rarr; Clusters.
* Select the cluster checkbox and click the Delete button. Wait.
* From the main GCP menu, choose Billing. Click Close Billing Account in the upper right-hand corner.
* From the main GCP menu, choose Home. In the Project Info pane, click Go to project settings. Click the
Shut Down button.
