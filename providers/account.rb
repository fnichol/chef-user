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

def load_current_resource
  @my_home = new_resource.home ||
    "#{node['user']['home_root']}/#{new_resource.username}"
  @my_shell = new_resource.shell || node['user']['default_shell']
  @manage_home = bool(new_resource.manage_home, node['user']['manage_home'])
  @create_group = bool(new_resource.create_group, node['user']['create_group'])
  @ssh_keygen = bool(new_resource.ssh_keygen, node['user']['ssh_keygen'])
end

action :create do
  user_resource             :create
  dir_resource              :create
  authorized_keys_resource  :create
  keygen_resource           :create
end

action :remove do
  keygen_resource           :delete
  authorized_keys_resource  :delete
  dir_resource              :delete
  user_resource             :remove
end

action :modify do
  user_resource             :modify
  dir_resource              :create
  authorized_keys_resource  :create
  keygen_resource           :create
end

action :manage do
  user_resource             :manage
  dir_resource              :create
  authorized_keys_resource  :create
  keygen_resource           :create
end

action :lock do
  user_resource             :lock
  dir_resource              :create
  authorized_keys_resource  :create
  keygen_resource           :create
end

action :unlock do
  user_resource             :unlock
  dir_resource              :create
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
  when 'no','false',false then false
  else true
  end
end

def user_resource(exec_action)
  # avoid variable scoping issues in resource block
  my_home, my_shell, manage_home = @my_home, @my_shell, @manage_home

  r = user new_resource.username do
    comment   new_resource.comment  if new_resource.comment
    uid       new_resource.uid      if new_resource.uid
    gid       new_resource.gid      if new_resource.gid
    home      my_home               if my_home
    shell     my_shell              if my_shell
    password  new_resource.password if new_resource.password
    system    new_resource.system_user
    supports  :manage_home => manage_home
    action    :nothing
  end
  r.run_action(exec_action)
  new_resource.updated_by_last_action(true) if r.updated_by_last_action?

  # fixes CHEF-1699
  Etc.endgrent
end

def dir_resource(exec_action)
  ["#{@my_home}/.ssh", @my_home].each do |dir|
    r = directory dir do
      owner       new_resource.username
      group       Etc.getpwnam(new_resource.username).gid
      mode        dir =~ %r{/\.ssh$} ? '0700' : '2755'
      recursive   true
      action      :nothing
    end
    r.run_action(exec_action)
    new_resource.updated_by_last_action(true) if r.updated_by_last_action?
  end
end

def authorized_keys_resource(exec_action)
  # avoid variable scoping issues in resource block
  ssh_keys = Array(new_resource.ssh_keys)

  r = template "#{@my_home}/.ssh/authorized_keys" do
    cookbook    'user'
    source      'authorized_keys.erb'
    owner       new_resource.username
    group       Etc.getpwnam(new_resource.username).gid
    mode        '0600'
    variables   :user     => new_resource.username,
                :ssh_keys => ssh_keys
    action      :nothing
  end
  r.run_action(exec_action)
  new_resource.updated_by_last_action(true) if r.updated_by_last_action?
end

def keygen_resource(exec_action)
  # avoid variable scoping issues in resource block
  fqdn, my_home = node['fqdn'], @my_home

  e = execute "create ssh keypair for #{new_resource.username}" do
    cwd       my_home
    user      new_resource.username
    command   <<-KEYGEN.gsub(/^ +/, '')
      ssh-keygen -t dsa -f #{my_home}/.ssh/id_dsa -N '' \
        -C '#{new_resource.username}@#{fqdn}-#{Time.now.strftime('%FT%T%z')}'
      chmod 0600 #{my_home}/.ssh/id_dsa
      chmod 0644 #{my_home}/.ssh/id_dsa.pub
    KEYGEN
    action    :nothing

    creates   "#{my_home}/.ssh/id_dsa"
  end
  e.run_action(:run) if @ssh_keygen && exec_action == :create
  new_resource.updated_by_last_action(true) if e.updated_by_last_action?

  if exec_action == :delete then
    ["#{@my_home}/.ssh/id_dsa", "#{@my_home}/.ssh/id_dsa.pub"].each do |keyfile|
      r = file keyfile do
        backup  false
        action :delete
      end
      new_resource.updated_by_last_action(true) if r.updated_by_last_action?
    end
  end
end
