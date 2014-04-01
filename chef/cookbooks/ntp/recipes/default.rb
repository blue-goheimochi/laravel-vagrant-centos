#
# Cookbook Name:: ntp
# Recipe:: default
#

package "ntp" do
  action :install
  not_if "rpm -q ntp"
end

execute "set timezone" do
  command <<-EOS
    echo -e 'ZONE="Asia/Tokyo"\nUTC="false"' > /etc/sysconfig/clock
    source /etc/sysconfig/clock
    yes | cp -p /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
  EOS
end

execute "adjust the time" do
  command "ntpdate #{node['ntp']['servers'][0]}"
end

service "ntpd" do
 supports :status => true, :restart => true
 action :nothing
end

template "/etc/ntp.conf" do
  source "ntp.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[ntpd]"
end