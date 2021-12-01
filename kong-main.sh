#!/bin/sh
# dependencies update & install
apt-get update
apt-get install -y apt-transport-https curl lsb-core

# postgresql database install
# kong db user & kong database configure
apt-get install -y postgresql postgresql-contrib
su - postgres -c "createuser -s kong"
sudo -u postgres psql -c "ALTER USER kong WITH PASSWORD 'kong';"
su - postgres -c "createdb kong"

# Kong gateway installation
echo "deb https://kong.bintray.com/kong-deb `lsb_release -sc` main" | sudo tee -a /etc/apt/sources.list
curl -o bintray.key https://bintray.com/user/downloadSubjectPublicKey?username=bintray
apt-key add bintray.key
apt-get update
apt-get install -y kong

# bootstrap & start Kong
cd /etc/kong &&
cp /tmp/kong.conf /etc/kong/kong.conf
kong migrations bootstrap [-c kong.conf]
kong start [-c kong.conf]
