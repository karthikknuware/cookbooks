#
# Cookbook Name:: webalizer
# Attributes:: webalizer
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.webalizer.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Where the various parts of webalizer are
case platform
when "redhat","centos","fedora","suse"
  set[:webalizer][:dir]     = "/etc/webalizer"
  set[:webalizer][:var_dir]    = "/var/lib/webalizer/"
  set[:webalizer][:cron_base_prefix]  = "/etc/cron."
  set[:webalizer][:binary]  = "/usr/bin/webalizer"
else
  set[:webalizer][:dir]     = "/etc/webalizer"
  set[:webalizer][:var_dir]    = "/var/lib/webalizer/"
  set[:webalizer][:cron_base_prefix]  = "/etc/cron."
  set[:webalizer][:binary]  = "/sr/bin/webalizer"
end