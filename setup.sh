#!/bin/bash

QUIET="" # can be -q or -qq

#
# ADD POSTGRESQL OFFICIAL REPOSITORY
#
echo "adding postgresql repository..."
sudo add-apt-repository "deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt/ $(sed -n 's/^UBUNTU_CODENAME=\(.*\)/\1/ p' /etc/os-release)-pgdg main"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
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
echo "installling PostgreSQL..."
sudo apt-get install -y $QUIET postgresql-10
echo "... DONE!"

#
# ADD DEVELOPER
#
echo "adding developer user (password: password)..."
sudo useradd --no-create-home --password password --shell /bin/bash developer
echo "... DONE!"




