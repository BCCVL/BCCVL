# -*- mode: ruby -*-
# vi: set ft=ruby :

# read in customisable local config if available
custom_conf = {}
if (File.exists?('vagrant.json'))
  begin
    require "json"
    custom_conf = JSON.parse(IO.read('vagrant.json'))
  rescue JSON::JSONError => ex
    $stderr.print("Found vagrant.json but failed to parse it:\n")
    $stderr.print(ex)
    exit(1)
  end
end

# TODO: uses a prefetched bootstrap-salt.sh script, because the vagrant script that downloads the salt-bootstrap script doesn't use the --insecure flage with curl and fails

Vagrant.configure("2") do |config|
  monitor_conf = custom_conf.fetch("monitor", {})

  config.vm.box = "contes65-x86_64-20140116"
  config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box"

  config.ssh.forward_agent = true

  # Deployment instance salt master
  config.vm.define :monitor do |monitor|
    monitor.vm.network :private_network, ip: "192.168.100.100"
    monitor.vm.hostname = 'monitor-dev'

    monitor.vm.synced_folder "salt/roots/", "/srv/"

    monitor.vm.provider "virtualbox" do |v|
      v.name = "monitor-dev"
      v.memory = monitor_conf.fetch("memory", 1024)
      v.cpus = monitor_conf.fetch("cpus", 2)
      v.customize ["modifyvm", :id, "--ioapic", "on"]
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

    end
  end


  # appX instance salt ninion
  config.vm.define :worker do |worker|
    worker_conf = custom_conf.fetch("worker", {})

    worker.vm.network :private_network, ip: "192.168.100.101"
    worker.vm.hostname = "worker-dev"

    worker.vm.synced_folder "dev/worker/org.bccvl.tasks", "/home/bccvl/worker/org.bccvl.tasks", create: true, mount_options: ["uid=401,gid=401"]

    worker.vm.provider "virtualbox" do |v|
      v.name = "worker-dev"
      v.memory = worker_conf.fetch("memory", 1024)
      v.cpus = worker_conf.fetch("cpus", 2)
      v.customize ["modifyvm", :id, "--ioapic", "on"]
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
    bccvl_conf = custom_conf.fetch("bccvl", {})

    bccvl.vm.network :private_network, ip: "192.168.100.200"
    bccvl.vm.hostname = "bccvl-dev"

    # source checkouts for plone
    bccvl.vm.synced_folder "dev/bccvl/bccvl_buildout", "/home/plone/bccvl_buildout", create: true, mount_options: ["uid=402,gid=402"]
    # source checkouts for data_mover
    bccvl.vm.synced_folder "dev/bccvl/bccvl_data_mover", "/home/data_mover/bccvl_data_mover", create: true, mount_options: ["uid=403,gid=403"]
    bccvl.vm.synced_folder "dev/bccvl/bccvl_data_mover_worker/org.bccvl.tasks", "/home/data_mover/worker/org.bccvl.tasks", create: true, mount_options: ["uid=403,gid=403"]
    # source checkouts for visualiser
    bccvl.vm.synced_folder "dev/bccvl/BCCVL_Visualiser", "/home/visualiser/BCCVL_Visualiser", create: true, mount_options: ["uid=404,gid=404"]

    bccvl.vm.provider "virtualbox" do |v|
      v.name = "bccvl-dev"
      v.memory = bccvl_conf.fetch("memory", 2048)
      v.cpus = bccvl_conf.fetch("cpus", 2)
      v.customize ["modifyvm", :id, "--ioapic", "on"]
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
