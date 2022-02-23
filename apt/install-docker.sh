rootDir=`pwd`
mkdir -p /etc/apt/bak
mv /etc/apt/sources.list /etc/apt/bak
tar xzvf docker-debs.tar.gz
mv archives docker-debs
echo "deb [trusted=yes] file:${rootDir}/docker-debs ./" > /etc/apt/sources.list
apt update
apt install -y docker-ce-cli docker-scan-plugin docker-ce docker-ce-rootless-extras
mv /etc/apt/bak/sources.list /etc/apt/