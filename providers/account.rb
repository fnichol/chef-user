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
  @my_home = new_resource.home || ::File.join(node['user']['home_root'],
                                             new_resource.username)
  @my_shell = new_resource.shell || node['user']['default_shell']
end

action :create do
  user_resource :create
end

action :remove do
  user_resource :remove
end

action :modify do
  user_resource :modify
end

action :manage do
  user_resource :manage
end

action :lock do
  user_resource :lock
end

action :unlock do
  user_resource :unlock
end

private

def user_resource(exec_action)
  user new_resource.username do
    comment   new_resource.comment  if new_resource.comment
    uid       new_resource.comment  if new_resource.uid
    gid       new_resource.gid      if new_resource.gid
    shell     @my_shell             if @my_shell
    home      @my_home              if @my_home
    action :nothing
  end.run_action(exec_action)
end
