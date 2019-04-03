# Create a Node Pool in GKE

In GKE, Nodes are added to existing GKE clusters in groups called *NodePools*.

Create a Node Pool as follows:
* In GCP, navigate to Main Menu &rarr; Kubernetes Engine &rarr; Clusters;
* Click on the cluster you want to work with
* Click the Edit button near the top;
* Scroll to near the bottom and click Add Node Pool;
* Set a name;
* Choose the Machine Type (different CPU/RAM profiles);
* Set the size to, for example, 3;
* Save your changes.

Remember to be careful with your computing resources in GCP so that you don't incur unnecessary charges. You can
remove the Node Pool to reduce expenditure.

