## Build with default values
```
docker build Dockerfile
```

## Build with args

```
docker build --build-arg terraform_version="0.13.3" --build-arg terragrunt_version="0.26.7" -t managekube/dev-box-ubuntu:0.0.1 Dockerfile
```
