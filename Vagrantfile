# -*- mode: ruby -*-
# vi: set ft=ruby :

# TODO: uses a prefetched bootstrap-salt.sh script, because the vagrant script that downloads the salt-bootstrap script doesn't use the --insecure flage with curl and fails

Vagrant.configure("2") do |config|
  config.vm.box = "contes65-x86_64-20140116"
  config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box"

  config.ssh.forward_agent = true

  # Deployment instance salt master
  config.vm.define :monitor do |monitor|
    monitor.vm.network :private_network, ip: "192.168.100.100"
    monitor.vm.hostname = 'monitor-dev'

    monitor.vm.synced_folder "salt/roots/", "/srv/"

    monitor.vm.network :forwarded_port, guest: 22, host: 2220, auto_correct: true

    monitor.vm.provider "virtualbox" do |v|
      v.name = "monitor-dev"
      v.customize ["modifyvm", :id, "--memory", "1024"]
    end

    monitor.vm.provision :salt do |salt|
      # we need a custom master config to set up state tree properly
      salt.master_config = "salt/master"
      salt.minion_key = "salt/key/monitor-dev.pem"
      salt.minion_pub = "salt/key/monitor-dev.pub"
      salt.master_key = "salt/key/master.pem"
      salt.master_pub = "salt/key/master.pub"
      salt.install_master = true
      salt.seed_master = {"monitor-dev" => salt.minion_pub,
                          "worker-dev" => "salt/key/worker-dev.pub",
                          "bccvl-dev" => "salt/key/bccvl-dev.pub"}
      salt.run_highstate = false
      salt.verbose = true
      salt.install_type = "stable"
      salt.temp_config_dir = "/tmp"
      salt.always_install = true
      # bootstrap debug log, set minion_id, set master ip
      salt.bootstrap_options = '-F -D -i monitor-dev -A 192.168.100.100'
      # TODO: custom bootstrap-salt.sh which fixes master preseeding
      salt.bootstrap_script = "bootstrap-salt.sh"
      #-D ... bootstrap debug output
      #-F ... override existing files?
      #-A ... salt master ip (for minions ... placed in /etc/salt/minion.d/...)
      #-i ... salt minion id (for minions ... placed in /etc/sart/minion.d/...)
      #
      # set pillar data if necessary
      # salt.pillar({
      #   "key" => {
      #      subkey => "value"
      #   }
      # })
    end
  end


  # appX instance salt ninion
  config.vm.define :worker do |worker|
    worker.vm.network :private_network, ip: "192.168.100.101"
    worker.vm.hostname = "worker-dev"

    worker.vm.network :forwarded_port, guest: 22, host: 2221, auto_correct: true

    worker.vm.provider "virtualbox" do |v|
      v.name = "worker"
      v.customize ["modifyvm", :id, "--memory", "1024"]
    end

    worker.vm.provision :salt do |salt|
      #salt.minion_config = "salt/minion"
      salt.minion_key = "salt/key/worker-dev.pem"
      salt.minion_pub = "salt/key/worker-dev.pub"
      salt.verbose = true
      salt.install_type = "stable"
      salt.temp_config_dir = "/tmp"
      # bootstrap debug log, set minion_id, set master ip
      salt.bootstrap_options = "-D -i worker-dev -A 192.168.100.100"
      salt.bootstrap_script = "bootstrap-salt.sh"
    end
  end

  config.vm.define :bccvl do |bccvl|

    bccvl.vm.network :private_network, ip: "192.168.100.200"
    bccvl.vm.hostname = "bccvl-dev"

    # port 2222 is reserved by vagrant :(
    bccvl.vm.network :forwarded_port, guest: 22, host: 2223, auto_correct: true
    # Rabbitmq web management
    bccvl.vm.network :forwarded_port, guest: 15672, host: 15672, auto_correct: true

    bccvl.vm.provider "virtualbox" do |v|
      v.name = "bccvl"
      v.customize ["modifyvm", :id, "--memory", "2048"]
    end

    bccvl.vm.provision :salt do |salt|
      salt.minion_key = "salt/key/bccvl-dev.pem"
      salt.minion_pub = "salt/key/bccvl-dev.pub"
      salt.verbose = true
      salt.install_type = "stable"
      salt.temp_config_dir = "/tmp"
      salt.bootstrap_options = "-D -i bccvl-dev -A 192.168.100.100"
      salt.bootstrap_script = "bootstrap-salt.sh"
    end
  end
end
