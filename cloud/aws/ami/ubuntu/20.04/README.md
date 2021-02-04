Packer Build
===========

## Building the image locally:

Set your AWS keys:
```bash
export AWS_ACCESS_KEY_ID="xxxx"
export AWS_SECRET_ACCESS_KEY="xxx"
```

Set environment variables used by Packer
```bash
export BUILD_VPC_ID="vpc-06fd30fb9a086b95d"
export BUILD_SUBNET_ID="subnet-0c7b0058c2220a2b0"
export AWS_REGION="us-east-1"
```

Execut Packer:
```bash
packer validate

packer build
```

This will launch a machine in AWS and run the packer build.
