#
# Cookbook Name:: user
# Provider:: account
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2011, Fletcher Nichol
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
require "chef/resource"

use_inline_resources

def whyrun_supported?
  true
end

def load_current_resource
  @my_home = new_resource.home ||
    "#{node['user']['home_root']}/#{new_resource.username}"
  @my_shell = new_resource.shell || node['user']['default_shell']
  @manage_home = bool(new_resource.manage_home, node['user']['manage_home'])
  @non_unique = bool(new_resource.non_unique, node['user']['non_unique'])
  @create_group = bool(new_resource.create_group, node['user']['create_group'])
  @ssh_keygen = bool(new_resource.ssh_keygen, node['user']['ssh_keygen'])
  @group_add = bool(new_resource.groups, node['user']['groups'])
end

action :create do # ~FC017: LWRP does not notify when updated
  user_resource             :create
  home_dir_resource         :create
  authorized_keys_resource  :create
  keygen_resource           :create
  group_resource            :create
end

action :remove do # ~FC017: LWRP does not notify when updated
  # Removing a user will also remove all the other file based resources.
  # By only removing the user it will make this action idempotent.
  user_resource             :remove
end

action :modify do # ~FC017: LWRP does not notify when updated
  user_resource             :modify
  home_dir_resource         :create
  authorized_keys_resource  :create
  keygen_resource           :create
end

action :manage do # ~FC017: LWRP does not notify when updated
  user_resource             :manage
  home_dir_resource         :create
  authorized_keys_resource  :create
  keygen_resource           :create
end

action :lock do # ~FC017: LWRP does not notify when updated
  user_resource             :lock
  home_dir_resource         :create
  authorized_keys_resource  :create
  keygen_resource           :create
end

action :unlock do # ~FC017: LWRP does not notify when updated
  user_resource             :unlock
  home_dir_resource         :create
  authorized_keys_resource  :create
  keygen_resource           :create
end

private

def bool(resource_val, default_val)
  if resource_val.nil?
    normalize_bool(default_val)
  else
    normalize_bool(resource_val)
  end
end

def normalize_bool(val)
  case val
  when nil, 'no', 'false', false then false
  else true
  end
end

def user_gid
  # this check is needed as the new user won't exit yet
  # in why_run mode, causing an uncaught ArgumentError exception
  Etc.getpwnam(new_resource.username).gid
rescue ArgumentError
  nil
end

def user_resource(exec_action)
  # avoid variable scoping issues in resource block
  my_home, my_shell, manage_home, non_unique = @my_home, @my_shell, @manage_home, @non_unique
  my_dir = ::File.dirname(my_home)

  r = directory "#{my_home} parent directory" do
    path my_dir
    recursive true
    action    :nothing
  end
  r.run_action(:create) unless exec_action == :remove
  new_resource.updated_by_last_action(true) if r.updated_by_last_action?

  r = user new_resource.username do
    comment   new_resource.comment  if new_resource.comment
    uid       new_resource.uid      if new_resource.uid
    gid       new_resource.gid      if new_resource.gid
    home      my_home               if my_home
    shell     my_shell              if my_shell
    password  new_resource.password if new_resource.password
    system    new_resource.system_user # ~FC048: Prefer Mixlib::ShellOut
    non_unique non_unique
    manage_home true
    action    :nothing
  end
  r.run_action(exec_action)
  new_resource.updated_by_last_action(true) if r.updated_by_last_action?

  # fixes CHEF-1699
  Etc.endgrent
end

def home_dir_resource(exec_action)
  # avoid variable scoping issues in resource block
  my_home = @my_home
  resource_gid = user_gid
  r = directory my_home do
    path        my_home
    owner       new_resource.username
    group       resource_gid
    mode        node['user']['home_dir_mode']
    recursive   true
    action      :nothing
  end
  r.run_action(exec_action)
  new_resource.updated_by_last_action(true) if r.updated_by_last_action?
end

def home_ssh_dir_resource(exec_action)
  # avoid variable scoping issues in resource block
  my_home = @my_home
  resource_gid = user_gid
  r = directory "#{my_home}/.ssh" do
    path        "#{my_home}/.ssh"
    owner       new_resource.username
    group       resource_gid
    mode        '0700'
    recursive   true
    action      :nothing
  end
  r.run_action(exec_action)
  new_resource.updated_by_last_action(true) if r.updated_by_last_action?
end

def authorized_keys_resource(exec_action)
  # avoid variable scoping issues in resource block
  ssh_keys = Array(new_resource.ssh_keys)
  unless ssh_keys.empty?
    home_ssh_dir_resource(exec_action)

    resource_gid = user_gid
    r = template "#{@my_home}/.ssh/authorized_keys" do
      cookbook    'user'
      source      'authorized_keys.erb'
      owner       new_resource.username
      group       resource_gid
      mode        '0600'
      variables   :user     => new_resource.username,
        :ssh_keys => ssh_keys,
        :fqdn     => node['fqdn']
      action      :nothing
    end

    r.run_action(exec_action)
    new_resource.updated_by_last_action(true) if r.updated_by_last_action?
  end
end

def keygen_resource(exec_action)
  # avoid variable scoping issues in resource block
  fqdn, my_home = node['fqdn'], @my_home

  e = execute "create ssh keypair for #{new_resource.username}" do
    cwd       my_home
    user      new_resource.username
    command   <<-KEYGEN.gsub(/^ +/, '')
      ssh-keygen -t rsa -f #{my_home}/.ssh/id_rsa -N '' \
        -C '#{new_resource.username}@#{fqdn}-#{Time.now.strftime('%FT%T%z')}'
      chmod 0600 #{my_home}/.ssh/id_rsa
      chmod 0644 #{my_home}/.ssh/id_rsa.pub
    KEYGEN
    action    :nothing

    creates   "#{my_home}/.ssh/id_rsa"
  end
  home_ssh_dir_resource(exec_action)
  e.run_action(:run) if @ssh_keygen && exec_action == :create
  new_resource.updated_by_last_action(true) if e.updated_by_last_action?

  if exec_action == :delete then
    ["#{@my_home}/.ssh/id_rsa", "#{@my_home}/.ssh/id_rsa.pub"].each do |keyfile|
      r = file keyfile do
        backup  false
        action :delete
      end
      new_resource.updated_by_last_action(true) if r.updated_by_last_action?
    end
  end
end

def group_resource(exec_action)
  new_resource.groups.each do |grp|
      r = group grp  do
            action :nothing
            members new_resource.username
            append true
          end
      r.run_action(:create) unless exec_action == :delete
      new_resource.updated_by_last_action(true) if r.updated_by_last_action?
  end
end
