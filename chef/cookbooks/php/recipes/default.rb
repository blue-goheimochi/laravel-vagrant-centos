#
# Cookbook Name:: php
# Recipe:: default
#

package "php" do
  action :install
  options "--enablerepo=remi"
  not_if "rpm -q php"
end

package "php-mcrypt" do
  action :install
  options "--enablerepo=remi"
  not_if "rpm -q php-mcrypt"
end

package "php-pdo" do
  action :install
  options "--enablerepo=remi"
  not_if "rpm -q php-pdo"
end

template "/etc/php.ini" do
  source "php.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[httpd]"
end

template "/etc/httpd/conf.d/php.conf" do
  source "php.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[httpd]"
end