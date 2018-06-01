#!/bin/bash

QUIET="" # can be -q or -qq

#
# ADD POSTGRESQL OFFICIAL REPOSITORY
#
echo "adding postgresql repository..."
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
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

sudo -u postgres psql <<EOF
CREATE ROLE developer WITH LOGIN PASSWORD 'password' SUPERUSER CREATEDB CREATEROLE INHERIT;
CREATE DATABASE developer;
GRANT ALL PRIVILEGES ON DATABASE developer TO developer;
EOF

echo "... DONE!"

#
# GREETINGS
#
cat <<EOF
  +----------------------------------------------------------------------------+
  |                                                                            |
  |            W E L C O M E   T O   P O S T G R E S Q L   v 10                |
  |                                                                            |
  +----------------------------------------------------------------------------+

  You can log on to the PostgreSQL RDBMS:

  1. locally on the vagrant VM:
    a. log on to the vagrant VM 
          host#> vagrant ssh 
    b. log on to the DB using either "postgres" or "developer" (password "password")
          guest#> sudo -u postgres psql
       or
          guest#> sudo -u developer psql

  2. remotely, e.g. from the host:
          host#> psql -U developer -h 192.168.56.3
          Password for user developer: ************ (enter) 

EOF