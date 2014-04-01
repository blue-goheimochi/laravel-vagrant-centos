#
# Cookbook Name:: laravel
# Recipe:: default
#
data_bag("vhosts").each do |vhost|
  execute "composer install #{data_bag_item('vhosts', vhost)['domain']}" do
    command <<-EOC
      cd /var/www/#{data_bag_item("vhosts", vhost)['domain']}
      composer install
    EOC
    not_if { !File.exists?("/var/www/#{data_bag_item('vhosts', vhost)['domain']}/composer.json") }
  end
end