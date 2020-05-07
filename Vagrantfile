# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.require_version ">= 1.8.4"

Vagrant.configure(2) do |config|
    # Tight configuration to a good known box version
    config.vm.box_check_update = false
    config.vm.box = 'centos/7'
    config.vm.box_version = '1902.01'
    interface = 'eth1'

    config.vm.define :dhcpserver do |svr|
        svr.vm.hostname = 'dhcpserver'
        svr.vm.network "private_network", ip: "5.5.5.5", auto_config: false
        #svr.vm.network "private_network", ip: "5.5.5.5", auto_config: false
        svr.vm.provider 'virtualbox' do |v|
            v.customize ['modifyvm', :id, '--memory', 512 * 1 ]
            v.customize ["modifyvm", :id, "--cpus", 1]
        end
        svr.vm.provision 'ansible' do |s|
          # configiure tird nic
          s.playbook = 'ansible/set_iface.yml'
          s.groups = {
            "dhcpd_hosts" => [ "dhcpserver" ],
            "dhcpd_hosts:vars" => [
              'interface=' + interface,
              'ip=192.168.1.1',
              'cidr=28'
            ]
          }
          s.raw_arguments = ['-vv']
          s.become = true
        end
        svr.vm.provision 'ansible' do |s|
          # configure node with dhcp role
          s.playbook = 'ansible/playbook.yml'
          # generate inventory file set only one subnet
          s.groups = {
            "dhcpd_hosts" => [ "dhcpserver" ],
            "dhcpd_hosts:vars" => [
              'interface=' + interface,
              # configure only one subnet - calcualte with sipcalc
              'ip=192.168.1.1',
              'cidr=28'
            ]
          }
          s.raw_arguments = ['-vv']
          s.become = true
        end

    end

    # DEFINE 3 CLIENTS TO TEST DHCP - USE PORT 68
    (1..1).each do |i|
        config.vm.define "dhcpclient-#{i}", autostart: true do |cli|
            cli.vm.network "private_network", ip: "5.5.5.5", auto_config: false
            cli.vm.provider 'virtualbox' do |v|
                v.customize ['modifyvm', :id, '--memory', 512 * 1 ]
                v.customize ["modifyvm", :id, "--cpus", 1]
            end
            cli.vm.provision 'ansible' do |s|
              # configiure tird nic
              s.playbook = 'ansible/set_iface.yml'
              s.groups = {
                "dhcpd_hosts" => [ "dhcpclient-#{i}" ],
                "dhcpd_hosts:vars" => [
                  'interface=' + interface
                ]
              }
              s.raw_arguments = ['-vv']
              s.become = true
            end
        end
    end
end
