# GKE Disk Creation

To create a disk in GCP:
* navigate to Google Cloud Platform &rarr; Compute Engine &rarr; Disks and hit the Create Disk button.
* Set the Name to “pv-disk”. Set the Region to be your compute region (e.g. us-central1) and the zone to be your compute
  zone (e.g. us-central1-a). Leave the Size at 500GB (important for later). Leave all else the same and hit Create.
  
Now you need to format the disk to ext4. To do this, we’ll create a temporary Google Compute Engine (GCE) VM Instance.

* From GCP &rarr; Google Compute Engine &rarr; VM Instances, click Create Instance.
* Set the region and zone appropriately, as above. You can leave all else unchanged.
* Wait for the instance to be created.
* Click on the instance link.
* Click the Edit button at the top.
* Scroll down to Additional Disks and click Attach existing disk.
* Select your “pv-disk” and click the Done button.
* Scroll down and click Save to attach pv-disk to your instance.
* Note: you should still be in the VM Instance Details.
* Near the top, click the Remote Access “SSH” button.
* Type `lsblk` and you should see an unmounted block device named sdb.
* Type `sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb`. Wait.
* Type `sudo mkdir -p /mnt/disks/pv-disk`.
* Type `sudo mount -o discard,defaults /dev/sdb /mnt/disks/pv-disk`.
* Type `sudo chmod a+w /mnt/disks/pv-disk`.
* You’re done. Exit the ssh shell.
* You don’t need your temporary GCE instance any more so delete it.

You're done!
