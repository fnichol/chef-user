# Description

A convenient Chef LWRP to manage user accounts and SSH keys. This is **not**
the Opscode *users* cookbook.

# Requirements

## Chef

Tested on 0.10.2 but newer and older version should work just fine. File an
[issue][issues] if this isn't the case.

## Platform

The following platforms have been tested with this cookbook, meaning that the
recipes run on these platforms without error:

* ubuntu
* debian
* mac_os_x

## Cookbooks

There are **no** external cookbook dependencies.

# Installation

Depending on the situation and use case there are several ways to install
this cookbook. All the methods listed below assume a tagged version release
is the target, but omit the tags to get the head of development. A valid
Chef repository structure like the [Opscode repo][chef_repo] is also assumed.

## From the Opscode Community Platform

To install this cookbook from the Opscode platform, use the *knife* command:

    knife cookbook site install user

## Using Librarian

The [Librarian][librarian] gem aims to be Bundler for your Chef cookbooks.
Include a reference to the cookbook in a **Cheffile** and run
`librarian-chef install`. To install with Librarian:

    gem install librarian
    cd chef-repo
    librarian-chef init
    cat >> Cheffile <<END_OF_CHEFFILE
    cookbook 'user',
      :git => 'git://github.com/fnichol/chef-user.git', :ref => 'v0.2.10'
    END_OF_CHEFFILE
    librarian-chef install

## Using knife-github-cookbooks

The [knife-github-cookbooks][kgc] gem is a plugin for *knife* that supports
installing cookbooks directly from a GitHub repository. To install with the
plugin:

    gem install knife-github-cookbooks
    cd chef-repo
    knife cookbook github install fnichol/chef-user/v0.2.10

## As a Git Submodule

A common practice (which is getting dated) is to add cookbooks as Git
submodules. This is accomplishes like so:

    cd chef-repo
    git submodule add git://github.com/fnichol/chef-user.git cookbooks/user
    git submodule init && git submodule update

**Note:** the head of development will be linked here, not a tagged release.

## As a Tarball

If the cookbook needs to downloaded temporarily just to be uploaded to a Chef
Server or Opscode Hosted Chef, then a tarball installation might fit the bill:

    cd chef-repo/cookbooks
    curl -Ls https://github.com/fnichol/chef-user/tarball/v0.2.10 | tar xfz - && \
      mv fnichol-chef-user-* user

# Usage

Simply include `recipe[user]` in your run_list and the `user_account`
resource will be available.

To use `recipe[user::data_bag]`, include it in your run_list and have a
data bag called `"users"` with an item like the following:

    {
      "id"        : "hsolo",
      "comment"   : "Han Solo",
      "home"      : "/opt/hoth/hsolo",
      "ssh_keys"  : ["123...", "456..."]
    }

or a user to be removed:

    {
      "id"      : "lando",
      "action"  : "remove"
    }

The data bag recipe will iterate through a list of usernames defined in
`node['users']` and attempt to pull in the user's information from the data
bag item. In other words, having:

    node['users'] = ['hsolo']

will set up the `hsolo` user information and not use the `lando` user
information.

# Recipes

## default

This recipe is a no-op and does nothing.

## data_bag

Processes a list of users with data drawn from a data bag. The default data bag
is `users` and the list of user account to create on this node is set on
`node['users']`.

# Attributes

## `home_root`

The default parent path of a user's home directory. Each resource can override
this value which varies by platform. Generally speaking, the default value is
`"/home"`.

## `default_shell`

The default user shell given to a user. Each resource can override this value
which varies by platform. Generally speaking, the default value is
`"/bin/bash"`.

## `manage_home`

Whether of not to manage the home directory of a user by default. Each resource
can override this value. The are 2 valid states:

* `"true"`, `true`, or `"yes"`: will manage the user's home directory.
* `"false"`, `false`, or `"no"`: will not manage the user's home directory.

The default is `true`.

## `create_user_group`

Whether or not to to create a group with the same name as the user by default.
Each resource can override this value. The are 2 valid states:

* `"true"`, `true`, or `"yes"`: will create a group for the user by default.
* `"false"`, `false`, or `"no"`: will create a group for the user by default.

The default is `true`.

## `ssh_keygen`

Whether or not to generate an SSH keypair for the user by default. Each
resource can override this value. There are 2 valid states:

* `"true"`, `true`, or `"yes"`: will generate an SSH keypair when the account
  is created.
* `"false"`, `false`, or `"no"`: will generate an SSH keypair when the account
  is created.

The default is `true`.

## `data_bag`

The data bag name containing a group of user account information. This is used
by the `data_bag` recipe to use as a database of user accounts. The default is
`"users"`.

# Resource and Providers

## user_account

**Note:** in order to use the `password` attribute, you must have the
[ruby-shadow gem][ruby-shadow_gem] installed. On Debian/Ubuntu you can get
this by installing the "libshadow-ruby1.8" package.

## Actions

Action    |Description                   |Default
----------|------------------------------|-------
create    |Create the user, its home directory, `.ssh/authorized_keys`, and `.ssh/{id_dsa,id_dsa.pub}`. |Yes
remove    |Remove the user account. |
modify    |Modiy the user account. |
manage    |Manage the user account. |
lock      |Lock the user's password. |
unlock    |Unlock the user's password. |

## Attributes

Attribute   |Description |Default value
------------|------------|-------------
username    |**Name attribute:** The name of the user. |`nil`
comment     |Gecos/Comment field. |`nil`
uid         |The numeric user id. |`nil`
gid         |The primary group id. |`nil`
home        |Home directory location. |`"#{node['user']['home_root']}/#{username}`
shell       |The login shell. |`node['user']['default_shell']`
password    |Shadow hash of password. |`nil`
system_user |Whether or not to create a system user. |`false`
manage_home |Whether or not to manage the home directory. |`true`
create_group |Whether or not to to create a group with the same name as the user. |`node['user']['create_group']`
ssh_keys    |A **String** or **Array** of SSH public keys to populate the user's `.ssh/authorized_keys` file. |`[]`
ssh_keygen  |Whether or not to generate an SSH keypair for the user. |`node['user']['ssh_keygen']`

## Examples

### Creating a User Account

    user_account 'hsolo' do
      comment   'Han Solo'
      ssh_keys  ['3dc348d9af8027df7b9c...', '2154d3734d609eb5c452...']
      home      '/opt/hoth/hsolo'
    end

### Locking a User Account

    user_account 'lando' do
      action  :lock
    end

### Removing a User account

    user_account 'obiwan' do
      action  :remove
    end

# Development

* Source hosted at [GitHub][repo]
* Report issues/Questions/Feature requests on [GitHub Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make.

# License and Author

Author:: Fletcher Nichol (<fnichol@nichol.ca>)

Copyright 2011, Fletcher Nichol

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[chef_repo]:    https://github.com/opscode/chef-repo
[kgc]:          https://github.com/websterclay/knife-github-cookbooks#readme
[librarian]:    https://github.com/applicationsonline/librarian#readme
[ruby-shadow_gem]:  https://rubygems.org/gems/ruby-shadow

[repo]:         https://github.com/fnichol/chef-user
[issues]:       https://github.com/fnichol/chef-user/issues
