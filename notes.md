Notes
=========


* Install Docker on the host system
* Install sysbox
  * https://github.com/nestybox/sysbox#installing-sysbox

## Start an Ubuntu container

```
DEV_INSTANCE_IMAGE=managekube/dev-box-ubuntu:0.0.5
DEV_INSTANCE_NAME=dev-1
DEV_INSTANCE_SSH_PORT=20021
USERS_PUBLIC_SSH_KEY="ssh-rsa AAAAB3NzaC1yc2E....."
DEV_INSTANCE_PUBLIC_IP=dev-box-1.managedkube.com
```

Start a dev-box container:
```
docker run --runtime=sysbox-runc --name ${DEV_INSTANCE_NAME} --hostname ${DEV_INSTANCE_NAME} -p ${DEV_INSTANCE_SSH_PORT}:22 -d ${DEV_INSTANCE_IMAGE}
```

Add ssh pub key:
```
docker exec ${DEV_INSTANCE_NAME} mkdir /root/.ssh
docker exec ${DEV_INSTANCE_NAME} /bin/bash -c "echo ${USERS_PUBLIC_SSH_KEY} >> /root/.ssh/authorized_keys"
```


## User Process
As a user, this gives you a Linux server where you can SSH into and develop on.

### Test out your connection to your dev instnace:

Add private key to your ssh agent:
```
ssh-add <path to your private ssh key>
```
* This should be the private key you are going to use to log into the dev box
* This should be the private key you are authenticating to Github with, You can also add more keys to your ssh agent if you are using different keys.

SSH into their instance:
```
ssh root@${DEV_INSTANCE_PUBLIC_IP} -p ${DEV_INSTANCE_SSH_PORT}
```

### Connect to your dev instance from VSCode:
VSCode has an extension allows you to use SSH from the IDE into a remote server.  It will then give you a terminal on that remote server and it can sync files that are on that remote server into your IDE like you were working on the remote server locally.

Here is the process on how to set that up:

#### Install the VSCode Remote SSH extention:

Doc: https://code.visualstudio.com/docs/remote/ssh

Install the "Remote - SSH" extension
* On the left hand side of the IDE click on "Extensions"
* Search for "Remote - SSH" and install this extension

#### Configure VSCode to connect to a remote machine
Add host into VScode:
* On the lower left of the VScode window click on "Open Remote Window"
* Click on: Remote-SSH: Connect to Host...
* + Add New SSH Host...
* Add: ssh root@<IP Address> -A -p 20021
* On the lower left of the VScode window click on "Open Remote Window"
* Click on: Remote-SSH: Open Configuration File...
* Select the `/home/<home folder>/.ssh/config` file
* Find this host:
```
Host x.x.x.x
	HostName x.x.x.x
	User root
	Port 20022
	ForwardAgent yes
```

* Click on: Remote-SSH: Connect to Host...
* Click on the host you just added and/or renamed.  A new VScode window will open up and it will connect to this host.
* In the new window, click on Terminal->New Terminal
* In the terminal
* `cd /home`
* git clone <Git repo URI>
* In VScode, on the top left click on the "Explorer" icon
* Click on "Open Folder"
* A box will appear asking for the path, put in: `/home/<Git repo>`. 
* VScode will reload and the Explorer will show the files of the Git repo you have just cloned.  These files are on the remote server but it appears in your VScode like they are local files.



## Thoughts

### Tunnelling to a remote docker server in vscode

https://code.visualstudio.com/docs/containers/ssh

* The remote user would connect to this and use this container instead of a local container
* They would still need docker client installed locally
* Working in China wouldnt be a problem for downloading golang packages since this server would be in the US

This is sounding complicated


### Using the ubuntu sysbox container

VScode
* You will need to install the Go extention into your dev box environment for code completion to work

Kubeconfig
* You will need a kubeconfig at: `/root/.kube/config`







* kubectl bash completion
* helm
  * and helm bash completion
* Bash prompt with git branch

