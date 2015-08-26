#
# Cookbook Name:: user
# Resource:: account
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

actions :create, :remove, :modify, :manage, :lock, :unlock

attribute :username,      :kind_of => String, :name_attribute => true
attribute :comment,       :kind_of => String
attribute :uid,           :kind_of => [String,Integer]
attribute :gid,           :kind_of => [String,Integer]
attribute :home,          :kind_of => String
attribute :shell,         :kind_of => String
attribute :password,      :kind_of => String
attribute :system_user,   :default => false
attribute :manage_home,   :default => nil
attribute :non_unique,    :default => nil
attribute :create_group,  :default => nil
attribute :ssh_keys,      :kind_of => [Array,String], :default => []
attribute :groups,        :kind_of => [Array,String], :default => []
attribute :ssh_keygen,    :default => nil

def initialize(*args)
  super
  @action = :create
end
