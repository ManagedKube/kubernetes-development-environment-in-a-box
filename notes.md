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
DEV_INSTANCE_PUBLIC_IP=18.232.178.23
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


## User

Add private key to your ssh agent:
```
ssh-add <path to your private ssh key>
```

SSH into their instance:

```
ssh root@${DEV_INSTANCE_PUBLIC_IP} -p ${DEV_INSTANCE_SSH_PORT}
```



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

