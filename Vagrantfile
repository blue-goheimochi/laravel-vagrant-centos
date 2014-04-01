VAGRANTFILE_API_VERSION = "2"

DOMAIN = 'laravel.loc'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "centos65-x86_64-20131205"
  config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.1/centos65-x86_64-20131205.box"

  # Set the IP address of unused if it would conflict with the IP you are using already
  config.vm.network :private_network, ip: "192.168.33.100"

  config.vm.synced_folder "./", "/var/www/#{DOMAIN}"

  # Install chef
  config.vm.provision :shell, :inline => "curl -L 'http://www.opscode.com/chef/install.sh' | sudo bash"

  # provisioning with chef solo.
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "./chef/cookbooks"
    chef.data_bags_path = "./chef/data_bags"
    chef.add_recipe "ntp"
    chef.add_recipe "remi"
    chef.add_recipe "httpd"
    chef.add_recipe "php"
    chef.add_recipe "composer"
    chef.add_recipe "laravel"
  end

end