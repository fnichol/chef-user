# Description

A convenient Chef LWRP to manage user accounts and SSH keys.

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

There are no external cookbook dependencies.

# Usage

Coming soon...

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
uid         |The numberic user id. |`nil`
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
Ideally create a topic branch for every seperate change you make.

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

[repo]:         https://github.com/fnichol/chef-user
[issues]:       https://github.com/fnichol/chef-user/issues
