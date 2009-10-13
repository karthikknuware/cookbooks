#
# Cookbook Name:: webalizer
# Definition:: webalizer
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

define :webalizer,
       :conf_template => "webalizer.conf.erb",
       :ssl => true,
       :site_template => "webalizer.site.erb",
       :cron_schedule => :daily,
       :log_type => :clf,
       :cookbook => "webalizer" do

  include_recipe "apache2"
  include_recipe "webalizer"

  server_name = (params[:server_name]) ? params[:server_name] : node[:fqdn]
  log_file_name = (params[:log_file_name]) ? params[:log_file_name] : "#{node[:apache][:log_dir]}/#{params[:name]}-access.log"
  output_dir = (params[:output_dir]) ? params[:output_dir] : "/var/www/usage/#{params[:name]}"

  [output_dir, node[:webalizer][:dir],"#{node[:webalizer][:dir]}/#{server_name}"].each do |dir|

    directory dir do
      owner "root"
      group "root"
      mode "0755"
      action :create
    end
  end

  # The webalizer config file. can be can be called with webalizer -c <the config file>
  template "#{node[:webalizer][:dir]}/chef-#{params[:name]}.conf" do
    source params[:conf_template]
    owner "root"
    group "root"
    mode 0644
    cookbook params[:cookbook]
    variables(
            :params => params,
            :log_file_name => log_file_name,
            :output_dir => output_dir
    )
  end

  # a cron job for webalizer, will iterate over all chef*.conf files and call webalizer -c
  template "#{node[:webalizer][:cron_base_prefix]}#{params[:cron_schedule].to_s}/00-webalizer" do
    source "00webalizer.cron.erb"
    owner "root"
    group "root"
    mode 0755
    backup false
    cookbook params[:cookbook]
    variables(
            :params => params
    )
  end

 # the apache vhost file (one per server_name => allows for more than one usage statistics )
  template "#{node[:apache][:dir]}/sites-available/webalizer-#{server_name}.conf" do
    source params[:site_template]
    owner "root"
    group "root"
    mode 0644
    cookbook params[:cookbook]
    variables(
            :output_dir => output_dir,
            :server_name => server_name,
            :params => params
    )
    if File.exists?("#{node[:apache][:dir]}/sites-enabled/webalizer-#{server_name}.conf")
      notifies :reload, resources(:service => "apache2"), :delayed
    end
  end

   # the apache alias file to allow for more usage statistics per vhost
  template File.join(node[:webalizer][:dir],server_name,"#{params[:name]}.alias") do
    source "webalizer.site.alias.erb"
    owner "root"
    group "root"
    mode 0644
    cookbook params[:cookbook]
    variables(
            :output_dir => output_dir,
            :server_name => server_name,
            :params => params
    )
    if File.exists?("#{node[:apache][:dir]}/sites-enabled/webalizer-#{server_name}.conf")
      notifies :reload, resources(:service => "apache2"), :delayed
    end
  end


  apache_site "webalizer-#{server_name}.conf" do
    enable enable_setting
  end
end