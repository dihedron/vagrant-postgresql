#!/bin/bash

QUIET="" # can be -q or -qq

#
# ADD POSTGRESQL OFFICIAL REPOSITORY
#
echo "adding postgresql repository..."
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
#wget  -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt/ $(sed -n 's/^UBUNTU_CODENAME=\(.*\)/\1/ p' /etc/os-release)-pgdg main"
echo "... DONE!"

#
# SYSTEM UPDATE
#
echo "bringing system up-to-date..."
sudo apt-get $QUIET update
sudo apt-get -y $QUIET dist-upgrade
echo "... DONE!"

#
# INSTALL POSTGRESQL
#
echo "installing PostgreSQL..."
sudo apt-get install -y $QUIET postgresql-10
echo "... DONE!"

#
# CONFIGURE POSTGRESQL TO ACCEPT REMOTE CONNECTIONS
#
echo "configuring remote access to PostgreSQL..."
cat <<EOF | sudo tee -a /etc/postgresql/10/main/postgresql.conf

#
# Custom settings
#
listen_addresses = '*'
EOF

cat <<EOF | sudo tee -a /etc/postgresql/10/main/pg_hba.conf

#
# Custom settings
#
host    all             all             0.0.0.0/0            md5
EOF
sudo service postgresql restart
echo "... DONE!"

#
# ADD DEVELOPER
#
echo "adding user \"developer\" (with password: \"password\")..."
sudo useradd --create-home --shell /bin/bash --comment "Developer" "developer"
sudo chpasswd <<EOF
developer:password
EOF
sudo -u postgres psql -c "CREATE ROLE developer WITH LOGIN PASSWORD 'password' SUPERUSER CREATEDB CREATEROLE INHERIT;"
sudo -u postgres psql -c "CREATE DATABASE developer;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE developer TO developer;"
echo "... DONE!"

