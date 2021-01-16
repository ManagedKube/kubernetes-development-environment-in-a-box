# kubernetes-development-environment-in-a-box
This project produces an AWS AMI image that can run an EC2 machine that has Docker and multiple isolated Kubernetes clusters running in it.  The main use case is to setup one node that can run multiple fully isolated Kubernetes cluster on it for development purposes.

## What this box has
This box has multiple items in it to help facilitate creating multiple Kubernetes cluster on a single machine.

```
+-----+  +-----+ +-----+  +-----+ +-----+ +-----+ +---------+ +-----------+
| Pod |  | Pod | | Pod |  |Pod  | |Pod  | |Pod  | |         | |           |
|     |  |     | |     |  |     | |     | |     | |         | |           |
+-----+  +-----+ +-----+  +-----+ +-----+ +-----+ |         | | Regular   |
+----------------------+  +---------------------+ |         | | Linux     |
|     Namepaces        |  |   Namepsaces        | |         | | process or|
+----------------------+  +---------------------+ |Regular  | |application|
+----------------------+  +---------------------+ |Container| |           |
|  KinD                |  |KinD                 | |         | |           |
|  +Kubernetes Cluster |  |  Kubernetes Cluster | |         | |           |
+----------------------+  +---------------------+ +---------+ |           |
+-----------------------------------------------------------+ |           |
|                                                           | |           |
|                       Docker                              | |           |
+-----------------------------------------------------------+ +-----------+
+-------------------------------------------------------------------------+
|                 Isolated Docker container                               |
|                 - Ubuntu 20.04                                          |
+-------------------------------------------------------------------------+
+-------------------------------------------------------------------------+
|                 Management Layer                                        |
+-------------------------------------------------------------------------+
+-------------------------------------------------------------------------+
|                 Nestybox/Sysbox Docker                                  |
+-------------------------------------------------------------------------+
+-------------------------------------------------------------------------+
|                 Ubuntu 20.04                                            |
+-------------------------------------------------------------------------+
+-------------------------------------------------------------------------+
|                 Instance / EC2                                          |
+-------------------------------------------------------------------------+
+-------------------------------------------------------------------------+
|                 Cloud                                                   |
+-------------------------------------------------------------------------+
```

Starting from the bottom up.

1) Cloud
This is the cloud that you are on where you are spinning up the instance.  The first supported cloud will be AWS.

2) Instance
This is the instance or virtual machine (VM) you are using.

3) Ubuntu 20.04
The base image of this machine is running Ubuntu 20.04.  It could really run any Linux distro though.

4) Nestybox/Sysbox
https://github.com/nestybox/sysbox

"Sysbox is an open-source container runtime (aka runc), originally developed by Nestybox, that enables Docker containers to act as virtual servers capable of running software such as Systemd, Docker, and Kubernetes in them, easily and with proper isolation. This allows you to use containers in new ways, and provides a faster, more efficient, and more portable alternative to virtual machines in many scenarios."

We are using this as the Docker isolation layer/tool which allows us to run fully isolated Docker container on this single machine.  This is really where the isolation magic is happening here.  Everything else is just managment glue to make everything work.  This allows us to spin up any number of Ubuntu Docker container on this machine which looks likes VMs.  The Ubuntu Docker image we spin up has Docker installed inside of it and KinD CLI which allows us to spin up Kubernetes clusters in this Docker container.

5) Management Layer
The management layer is a set of scripts and proccesses to facilitate spinning up and down Kubernetes clusters on this machine.  This is the glue that puts everything together.

6) Isolated Ubuntu Docker image with KinD installed
And finally we arrive at the end state of what we are after here.  A fully isolated KinD cluster running on a machine with other fully isolated KinD clusters.  This Docker container acts like a VM.  You can SSH into it, you can `apt-get install` stuff, and basically anything else you can do with a VM.  

This Docker container can then instantiate a KinD Kubernetes cluster, other docker containers, or just regular Linux proccesses or applications.  Use this like any other VM.  The diagram is showing a few possible options here but you can do whatever you like here.  You can hand these Ubuntu containers to a developer as a remote machine that they can use and this is cost effective as well since everyone shares one machine.

While this project is geared toward running multiple isolated KinD cluster on a single instance, fundamentally it is a generic machine that can run any Docker container that are fully isolated from each other.

## Use cases





