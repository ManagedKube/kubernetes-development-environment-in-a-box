# kubernetes-development-environment-in-a-box
This project produces an AMI image that can run an instance that has Docker and multiple isolated Kubernetes clusters running in it using [KinD](https://github.com/kubernetes-sigs/kind).  The main use case is to setup one node that can run multiple fully isolated Kubernetes cluster on it for development purposes.

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
(Created with http://asciiflow.com/)

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

We are using this as the Docker isolation layer/tool which allows us to run fully isolated Docker container on this single machine.  This is really where the isolation magic is happening here.  Everything else is just managment glue to make everything work.  This allows us to spin up any number of Ubuntu Docker container on this machine which looks likes VMs.  The Ubuntu Docker image we spin up has Docker installed inside of it and [KinD](https://github.com/kubernetes-sigs/kind) CLI which allows us to spin up Kubernetes clusters in this Docker container.

5) Management Layer
The management layer is a set of scripts and proccesses to facilitate spinning up and down Kubernetes clusters on this machine.  This is the glue that puts everything together.

6) Isolated Ubuntu Docker image with KinD installed
And finally we arrive at the end state of what we are after here.  A fully isolated KinD cluster running on a machine with other fully isolated KinD clusters.  This Docker container acts like a VM.  You can SSH into it, you can `apt-get install` stuff, and basically anything else you can do with a VM.  

This Docker container can then instantiate a KinD Kubernetes cluster, other docker containers, or just regular Linux proccesses or applications.  Use this like any other VM.  The diagram is showing a few possible options here but you can do whatever you like here.  You can hand these Ubuntu containers to a developer as a remote machine that they can use and this is cost effective as well since everyone shares one machine.

While this project is geared toward running multiple isolated KinD cluster on a single instance, fundamentally it is a generic machine that can run any Docker container that are fully isolated from each other.

## Use cases

### Why would you want to use a development box like this?
Setting up a development environment is hard.  Everyone's machine is a little different and everyone likes to configure it a little differently.  Using a central development box like this, allows your developers to connect to this central machine where you have more control of how it is setup.  This helps you to get your developers productive faster.

You can setup a container that has everything installed in it from developer's tools to specific libraries that you are using.  Each container can even have it's own Kubernetes cluster which means each developer has their own cluster and won't interfere with each other's work.

### Use case - New developers

I have:
* 2 new developers
* Both are going to start on some type of development that involves Kubernetes
* They are both running Windows machine
* Work in a location that makes downloading Golang libraries hard (restricted)
* Not that familiar with Kubernetes and you don't want them to have to set it up locally
* You don't want to play support and would rather have the developer connect to something that is all setup for them

Kubernetes-development-environment-in-a-box is perfect for this use case.  You can setup a machine on AWS, GCP, or Azure and turn on an Ubuntu container for each of them.  These containers act more like a VM (see above for an explantion) which means it has a local isolated Docker daemon, you can start a KinD cluster, and install whatever you want into it without affecting the host machine or any other containers on this machine.

The container you start for this developer is built from a Dockerfile and it has all of the tools and thing you want in it from the get go.  So if you wanted Golang 1.14.x it has it or if you want to use Golang 1.15.x, that is cool as well.

With this setup, you can build a topology like this:
```
                                                             +---------------------------------------------------+
                                                             |                                                   |
                                                             |                                                   |
 DeVeloper 1 local laptop                                    |                                                   |
+------------------------+                                   |                 Container 1                       |
|* VSCode IDE            |                                   |            +----------------------------+         |
|* Remote SSH extension  |           SSH Connection          |            |     * Ubuntu               |         |
|                        +----------------------------------------------> |     * Docker               |         |
|                        |                                   |            |     * Kubernetes           +------------>Internet
|                        |                                   |            |     * Golang/Python/etc    |         |
+------------------------+                                   |            |     * SSH                  |         |
                                                             |            |                            |         |
                                                             |            +----------------------------+         |
                                                             |                                                   |
                                                             |                  Container 2                      |
 DeVeloper 2 local laptop                                    |            +----------------------------+         |
+------------------------+                                   |            |     * Ubuntu               |         |
| * VSCode IDE           |           SSH Connection          |            |     * Docker               +------------>Internet
| * Remote SSH extension +----------------------------------------------> |     * Kubernetes KinD      |         |
|                        |                                   |            |     * Golang/Python/etc    |         |
+------------------------+                                   |            |     * SSH                  |         |
                                                             |            +----------------------------+         |
                                                             |                                                   |
                                                             |                                                   |
                                                             |                                                   |
                                                             |                                                   |
                                                             |          Host Ubuntu system                       |
                                                             |           (AWS/EC2, GCP, Azure)                   |
                                                             +---------------------------------------------------+

```
* The developers runs VSCode locally on their laptops
* They use their internet connection to SSH to a remote server
* The remote server has a fully built and working environment with everything they need

