#
# Cookbook Name:: mm-jenkins
# Recipe:: default
#
# Copyright (c) 2016 Mike McCarthy, All Rights Reserved.

include_recipe 'java'

tomcat_install 'jenkins' do
  tarball_uri "#{node['mm-jenkins']['repo']}apache-tomcat-#{node['mm-jenkins']['version']}.tar.gz"
  version "#{node['mm-jenkins']['version']}"
  tomcat_user 'tomcat'
  tomcat_group 'tomcat'
end

template '/opt/tomcat_jenkins/conf/server.xml' do
  source 'server.xml.erb'
  owner 'tomcat'
  group 'tomcat'
  mode '0644'
  notifies :restart, 'tomcat_service[jenkins]'
end

remote_file '/opt/tomcat_jenkins/webapps/jenkins.war' do
  owner 'tomcat'
  mode '0644'
  source "#{node['mm-jenkins']['warurl']}"
end

tomcat_service 'jenkins' do
  action [:start, :enable]
  tomcat_user 'tomcat'
  tomcat_group 'tomcat'
end
