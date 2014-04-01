#
# Cookbook Name:: composer
# Attributes:: default

default['composer']['url'] = "https://getcomposer.org/installer"
default['composer']['install_dir'] = "/usr/local/bin/"
default['composer']['bin'] = "#{node['composer']['install_dir']}/composer"