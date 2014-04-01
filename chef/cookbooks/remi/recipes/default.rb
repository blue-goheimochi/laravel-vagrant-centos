#
# Cookbook Name:: remi
# Recipe:: default
#

execute "add remi repository" do
  command <<-EOS
    rpm -Uhv #{node['remi']['rpm_url']}
    yum -y update remi-release
  EOS
end