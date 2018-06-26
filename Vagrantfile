# coding: utf-8
$script = <<-SCRIPT
echo Installing…
pacman -Syyuu --noconfirm elixir git
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "archlinux/archlinux"

  config.vm.hostname = "development"
  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "90"]
  end

  config.vm.provision "shell", inline: $script
end
