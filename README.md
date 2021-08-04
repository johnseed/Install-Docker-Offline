# Install docker offline

## Centos7.6

### Prepare local repo

```bash
# export http_proxy="http://192.168.1.2:1001"
# export https_proxy="http://192.168.1.2:1001"

yum install -y yum-utils

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

mkdir /docker-repo/
yum install --downloadonly --downloaddir=/docker-repo docker-ce docker-ce-cli containerd.io

# yumdownloader --resolve docker-ce docker-ce-cli containerd.io
```

yum install docker-ce docker-ce-cli containerd.io