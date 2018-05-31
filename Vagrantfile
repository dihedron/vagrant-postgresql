# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

    # use this when behind a proxy:     
    required_plugins = %w( vagrant-vbguest vagrant-disksize vagrant-proxyconf )
  
#   required_plugins = %w( vagrant-vbguest vagrant-disksize )  
    _retry = false
    required_plugins.each do |plugin|
        unless Vagrant.has_plugin? plugin
            system "vagrant plugin install #{plugin}"
            _retry=true
        end
    end

    config.vm.box = "ubuntu/bionic64"
    config.vm.hostname = "postgresql"
    config.vm.define "postgresql"
    config.vm.box_check_update = false
#   config.vm.network "forwarded_port", guest: 80, host: 8080
#   config.vm.network "private_network", ip: "192.168.33.12"
    config.vm.provider "virtualbox" do |vb|
        vb.name = "PostgreSQL"
        vb.memory = "4096"
        vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
    end
    config.vm.provision "shell" do |sh|
        sh.path = "setup.sh"
	    sh.privileged = false
	    # JDK version, can be one or more of 8 and 10; the last one is set as default
        # sh.args = ["8", "10"] 
    end  

    if Vagrant.has_plugin?("vagrant-vbguest")
        config.vbguest.auto_update = false
    end

    if Vagrant.has_plugin?("vagrant-disksize")
        config.disksize.size = '10GB'
    end

    if Vagrant.has_plugin?("vagrant-proxyconf")
        # let CNTLM listen on the vboxnet interface, set your localhost
        # as the proxy for VirtualBox machines, so APT can get through
        # note that _gateway is the hostname of the host as ssen from the guest 
        # VM (tweak as needed!)
        config.proxy.http     = "http://_gateway:3128/"
        config.proxy.https    = "http://_gateway:3128/"
        config.proxy.no_proxy = "localhost,127.0.0.1,.example.com"
    end
end
