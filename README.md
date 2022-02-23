# Install docker offline

## CentOS

### Prepare local repo

```bash
# export http_proxy="http://192.168.1.2:1001"
# export https_proxy="http://192.168.1.2:1001"

yum install -y yum-utils createrepo

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
mkdir -p $yumRepoDir/backup
mv $yumRepoDir/*.repo $yumRepoDir/backup/
echo "[docker-repo]" > $yumRepoDir/docker.repo
echo "name=docker-repo" >> $yumRepoDir/docker.repo
echo "baseurl=file://${rootDir}/docker-repo" >> $yumRepoDir/docker.repo
echo "gpgcheck=0" >> $yumRepoDir/docker.repo
echo "enabled=1" >> $yumRepoDir/docker.repo
yum clean all > /dev/null 2>&1
yum makecache > /dev/null 2>&1

yum install docker-ce docker-ce-cli containerd.io
systemctl start docker
systemctl enable docker

mv $yumRepoDir/backup/*.repo $yumRepoDir/
mv $yumRepoDir/docker.repo $yumRepoDir/backup/
```

## Ubuntu

### Prepare local apt repo
[https://askubuntu.com/questions/170348/how-to-create-a-local-apt-repository]

```bash
apt-get install dpkg-dev
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
cd /var/cache/apt/archives
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
cd ..
tar czvf docker-debs.tar.gz archives
```

### Install

```bash
rootDir=`pwd`
mkdir -p /etc/apt/bak
mv /etc/apt/sources.list /etc/apt/bak
tar xzvf docker-debs.tar.gz
mv archives docker-debs
echo "deb [trusted=yes] file:${rootDir}/docker-debs ./" > /etc/apt/sources.list
apt update
apt install -y docker-ce-cli docker-scan-plugin docker-ce docker-ce-rootless-extras
mv /etc/apt/bak/sources.list /etc/apt/
```

## Install Portainer

### Install portainer

```bash
docker load < portainer.tar
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
```

### Install portainer agent

```bash
docker load < portainer-agent.tar
docker run -d -p 9001:9001 --name portainer_agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes portainer/agent
```
