# Creating a VM with the Oracle JDK 8 and/or 10

This projects contains the __Vagrant__ recipe to create a VM with PostgreSQL.

## Creating the VM

In order to create the VM you must have installed ```vagrant```, which is made freely available from Hashicorp on [their website](https://www.vagrantup.com/).

Next, clone this repository or download it to a directory of your choice and from it run the following at a command propt:
```bash
$> vagrant up
```
Vagrant will create a new virtual machine based on Ubuntu Xenial 16.04.4 LTS or Ubuntu Bionic 18.04 and then it will run the ```setup.sh``` script which:
1. adds the PostgreSQL 10 repository and its private key
2. updates the system
3. installs the ```postgresql-10``` package
4. creates a linux user called ```developer``` (password: ```password```) without a home directory, so it can only be used to logon remotely to PostgreSQL

## Operating from behind a proxy

In order to support a scenario where Vagrant is running behind a proxy, e.g. when running in an enterprise environment, the ```Vagrantfile``` includes a reference to the ```vagrant-proxyconf``` [plugin](https://github.com/tmatilai/vagrant-proxyconf); in order to enable it and have Vagrant automatically install it if lacking, replace this line in the ```Vagrantfile```:
```bash  
    required_plugins = %w( vagrant-vbguest vagrant-disksize )
```  
with this:
```bash
   required_plugins = %w( vagrant-vbguest vagrant-disksize vagrant-proxyconf )
```
then tweak the proxy section:
```bash
    if Vagrant.has_plugin?("vagrant-proxyconf")
        # let CNTLM listen on the vboxnet interface, set your localhost
        # as the proxy for VirtualBox machines, so APT can get through
        # note that _gateway if the name of the host machine as ssen from the 
        # guest (tweak as needed!)
        config.proxy.http     = "http://_gateway:3128/"
        config.proxy.https    = "http://_gateway:3128/"
        config.proxy.no_proxy = "localhost,127.0.0.1,10.*,.example.com"
    end
```
as needed; in the example above, a local [CNTLM proxy](http://cntlm.sourceforge.net/) was installed and configured on the host machine to listen on the ```vboxnet0``` NIC. Please note that for security reasons, by default CNTLM only listens on the loopback interface; unless explicitly told to do otherwise
```bash
Listen		127.0.0.1:3128             # loopback
Listen		10.0.2.2:3128              # virtualbox
```
it is not reachable by VirtualBox VMs.

## Using the VM

In order to use the VM to run your Java applications, you simply need to log into it:
```bash
$> vagrant ssh
```
and then use the command line to run PostgreSQL-related commands.

If you need to share files between the host (your PC) and the VM you can place them in the same directory where ```Vagrantfile``` and ```setup.sh``` are, because ```vagrant``` makes sure it is mounted as a shared folder on the guest VM under ```/vagrant```. This is an easy way to move Java sources and binaries back and forth.

## Working with PostgreSQL

These are just a few brief reminders about what you can do with PostgreSQL.

### Running commands as user ```postgres``` (the DB admin)

PostgreSQL uses local users to authenticate connections, and then applies its own ```roles``` to grant or deny access to resources. The initial, super-powerful user is called ```postgres```; in order to start working with PostgreSQL you need to create some resources (users, databases) as this user.

User ```postgres``` has no password but you can still sudo into it: connect to the VM (```vagrant ssh```), then as user ```vagrant``` (the default) run:
``` bash
$> sudo su - postgres
```
and this will turn you into ```postgres```.

### Running the PostgreSQL CLI (```psql```)

Once you are running as user ```postgres```, the PostgreSQL CLI is available as:
``` bash
$> psql
```
The PostgreSQL CLI gives access to all the RDBMS functionalities: type ```\?``` at the propmp to receive a list (among which ```\l``` to list databases, ```\c``` to connect to a database etc.).

## Feedback and contributions

...are obviously exceedingly welcome; please use issues and pull requests to contribute back.