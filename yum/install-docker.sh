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