#
# Cookbook Name:: httpd
# Recipe:: default
#

default_vhosts = data_bag_item("vhosts","default")

package "httpd" do
  action :install
  not_if "rpm -q httpd"
end

service "httpd" do
    action :enable
end

data_bag("vhosts").each do |vhost|
  execute "init #{data_bag_item('vhosts', vhost)['domain']} dir" do
    command <<-EOC
      mkdir -p /var/log/httpd/#{data_bag_item('vhosts', vhost)['domain']}
      mkdir -p /var/www/#{data_bag_item("vhosts", vhost)['domain']}
      mkdir -p /var/www/#{data_bag_item("vhosts", vhost)['domain']}/#{data_bag_item("vhosts", vhost)['doc_root']}
    EOC
  end
end

execute "remove files" do
  command <<-EOC
    rm -rf /var/www/cgi-bin
    rm -rf /var/www/error
    rm -rf /var/www/html
    rm -rf /var/www/icons
    rm -f /etc/httpd/conf.d/welcome.conf
  EOC
end

# httpd.conf
template "/etc/httpd/conf/httpd.conf" do
  source "conf/httpd.conf.erb"
  owner "root"
  group "root"
  mode "0664"
  variables({
    :default_domain => default_vhosts['domain']
  })
  notifies :restart, "service[httpd]"
end

# virtualhost.conf
template "/etc/httpd/conf.d/virtualhost.conf" do
  source "conf.d/virtualhost.conf.erb"
  owner "root"
  group "root"
  mode "0664"
  notifies :restart, "service[httpd]"
end

data_bag("vhosts").each do |vhost|
  template "/etc/httpd/conf.d/virtualhost-#{data_bag_item('vhosts', vhost)['domain']}.conf" do
    source "conf.d/virtualhost-domains.conf.erb"
    owner "root"
    group "root"
    mode "0664"
    variables({
      :domain   => data_bag_item('vhosts', vhost)['domain'],
      :doc_root => data_bag_item('vhosts', vhost)['doc_root']
    })
    notifies :restart, "service[httpd]"
  end
end