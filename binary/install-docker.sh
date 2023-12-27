tar xzvf docker-20.10.9.tgz
cp docker/* /usr/bin/
# dockerd & # manual start
cp docker.service /etc/systemd/system
cp docker.socket /etc/systemd/system
systemctl enable docker.service
systemctl enable containerd.service
