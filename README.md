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

createrepo .
tar -czvf docker-repo.tar.gz /docker-repo
```

### Install docker on offline environment
```bash
yumRepoDir=/etc/yum.repos.d
rootDir=`pwd`
tar -xzvf docker-repo.tar.gz
echo "[docker-repo]" > $yumRepoDir/docker.repo
echo "name=docker-repo" >> $yumRepoDir/docker.repo
echo "baseurl=file://${rootDir}/docker-repo" >> $yumRepoDir/docker.repo
echo "gpgcheck=0" >> $yumRepoDir/docker.repo
echo "enabled=1" >> $yumRepoDir/docker.repo

yum install docker-ce docker-ce-cli containerd.io
systemctl start docker
systemctl enable docker
```

## Install portainer

```bash
docker load < portainer.tar
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
```

## Install portainer agent

```bash
docker load < portainer-agent.tar
docker run -d -p 9001:9001 --name portainer_agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes portainer/agent
```