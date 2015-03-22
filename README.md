# <a name="title"></a> User Chef Cookbook

[![Build Status](https://secure.travis-ci.org/fnichol/chef-user.png?branch=master)](http://travis-ci.org/fnichol/chef-user)

## <a name="description"></a> Description

A convenient Chef LWRP to manage user accounts and SSH keys. This is **not**
the Opscode *users* cookbook.

* Website: http://fnichol.github.io/chef-user/
* Opscode Community Site: http://community.opscode.com/cookbooks/user
* Source Code: https://github.com/fnichol/chef-user

## <a name="usage"></a> Usage

Simply include this cookbook as a dependency in `metadata.rb` and the `user_account`
resource will be available. Example:

    # In your_cookbook/metadata.rb
    depends 'user'

    # In your_cookbook/recipes/default.rb
    user_account 'hsolo' do
        ssh_keygen true
    end

To use `recipe[user::data_bag]`, include it in your run\_list and have a
data bag called `"users"` with an item like the following:

    {
      "id"        : "hsolo",
      "comment"   : "Han Solo",
      "home"      : "/opt/hoth/hsolo",
      "groups"    : ["admin", "www-data"],
      "ssh_keys"  : ["123...", "456..."]
    }

or a user to be removed:

    {
      "id"      : "lando",
      "action"  : "remove"
    }

If you have a username containing a period, use a dash in the data bag item
and set a `username` attribute:

    {
      "id"        : "luke-skywalker",
      "username"  : "luke.skywalker",
      "action"    : ["create", "lock"]
    }

The data bag recipe will iterate through a list of usernames defined in
`node['users']` (by default) and attempt to pull in the user's information
from the data bag item. In other words, having:

    node['users'] = ['hsolo', 'lando', 'luke.skywalker']

will set up the `hsolo` user information and not use the `lando` user
information.

## <a name="requirements"></a> Requirements

### <a name="requirements-chef"></a> Chef

Tested on 0.10.8 but newer and older version should work just fine. File an
[issue][issues] if this isn't the case.

### <a name="requirements-platform"></a> Platform

The following platforms have been tested with this cookbook, meaning that the
recipes run on these platforms without error:

* ubuntu
* debian
* mac_os_x

### <a name="requirements-cookbooks"></a> Cookbooks

There are **no** external cookbook dependencies.

## <a name="installation"></a> Installation

Depending on the situation and use case there are several ways to install
this cookbook. All the methods listed below assume a tagged version release
is the target, but omit the tags to get the head of development. A valid
Chef repository structure like the [Opscode repo][chef_repo] is also assumed.

### <a name="installation-platform"></a> From the Community Site

To install this cookbook from the Community Site, use the *knife* command:

    knife cookbook site install user

### <a name="installation-berkshelf"></a> Using Berkshelf

[Berkshelf][berkshelf] is a cookbook dependency manager and development
workflow assistant. To install Berkshelf:

    cd chef-repo
    gem install berkshelf
    berks init

To use the Community Site version:

    echo "cookbook 'user'" >> Berksfile
    berks install

Or to reference the Git version:

    repo="fnichol/chef-user"
    latest_release=$(curl -s https://api.github.com/repos/$repo/git/refs/tags \
    | ruby -rjson -e '
      j = JSON.parse(STDIN.read);
      puts j.map { |t| t["ref"].split("/").last }.sort.last
    ')
    cat >> Berksfile <<END_OF_BERKSFILE
    cookbook 'user',
      :git => 'git://github.com/$repo.git', :branch => '$latest_release'
    END_OF_BERKSFILE
    berks install

### <a name="installation-librarian"></a> Using Librarian-Chef

[Librarian-Chef][librarian] is a bundler for your Chef cookbooks.
To install Librarian-Chef:

    cd chef-repo
    gem install librarian
    librarian-chef init

To use the Opscode platform version:

    echo "cookbook 'user'" >> Cheffile
    librarian-chef install

Or to reference the Git version:

    repo="fnichol/chef-user"
    latest_release=$(curl -s https://api.github.com/repos/$repo/git/refs/tags \
    | ruby -rjson -e '
      j = JSON.parse(STDIN.read);
      puts j.map { |t| t["ref"].split("/").last }.sort.last
    ')
    cat >> Cheffile <<END_OF_CHEFFILE
    cookbook 'user',
      :git => 'git://github.com/$repo.git', :ref => '$latest_release'
    END_OF_CHEFFILE
    librarian-chef install

## <a name="recipes"></a> Recipes

### <a name="recipes-default"></a> default

This recipe is a no-op and does nothing.

### <a name="recipes-data-bag"></a> data_bag

Processes a list of users with data drawn from a data bag. The default data bag
is `users` and the list of user accounts to create on this node is set on
`node['users']`.

## <a name="attributes"></a> Attributes

### <a name="attributes-home-root"></a> home_root

The default parent path of a user's home directory. Each resource can override
this value which varies by platform. Generally speaking, the default value is
`"/home"`.

### <a name="attributes-default-shell"></a> default_shell

The default user shell given to a user. Each resource can override this value
which varies by platform. Generally speaking, the default value is
`"/bin/bash"`.

### <a name="attributes-home-dir-mode"></a> home_dir_mode

The default Unix permissions applied to a user's home directory.

The default is `"2755"`.

### <a name="attributes-manage-home"></a> manage_home

Whether of not to manage the home directory of a user by default. Each resource
can override this value. The are 2 valid states:

* `"true"`, `true`, or `"yes"`: will manage the user's home directory.
* `"false"`, `false`, or `"no"`: will not manage the user's home directory.

The default is `true`.

### <a name="attributes-non-unique"></a> non_unique

Whether of not to allow the creation of a user account with a duplicate UID.
Each resource can override this value. The are 2 valid states:

* `"true"`, `true`, or `"yes"`: will allow duplicate UIDs.
* `"false"`, `false`, or `"no"`: will not allow duplicate UIDs.

The default is `false`.

### <a name="attributes-create-user-group"></a> create_group

Whether or not to to create a group with the same name as the user by default.
Each resource can override this value. The are 2 valid states:

* `"true"`, `true`, or `"yes"`: will create a group for the user by default.
* `"false"`, `false`, or `"no"`: will not create a group for the user by default.

The default is `true`.

### <a name="attributes-ssh-keygen"></a> ssh_keygen

Whether or not to generate an SSH keypair for the user by default. Each
resource can override this value. There are 2 valid states:

* `"true"`, `true`, or `"yes"`: will generate an SSH keypair when the account
  is created.
* `"false"`, `false`, or `"no"`: will not generate an SSH keypair when the account
  is created.

The default is `true`.

### <a name="attributes-data-bag-name"></a> data_bag_name

The data bag name containing a group of user account information. This is used
by the `data_bag` recipe to use as a database of user accounts.

The default is `"users"`.

### <a name="attributes-user-array-node-attr"></a> user_array_node_attr

The node attributes containing an array of users to be managed. If a nested
hash in the node's attributes is required, then use a `/` between subhashes.
For example, if the users' array is stored in `node['system']['accounts']`),
then set `node['user']['user_array_node_attr']` to `"system/accounts"`.

The default is `"users"`.

## <a name="lwrps"></a> Resources and Providers

### <a name="lwrps-ua"></a> user_account

**Note:** in order to use the `password` attribute, you must have the
[ruby-shadow gem][ruby-shadow_gem] installed. On Debian/Ubuntu you can get
this by installing the "libshadow-ruby1.8" package.

### <a name="lwrps-ua-actions"></a> Actions

<table>
  <thead>
    <tr>
      <th>Action</th>
      <th>Description</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>create</td>
      <td>
        Create the user, its home directory, <code>.ssh/authorized_keys</code>,
        and <code>.ssh/{id_rsa,id_rsa.pub}</code>.
      </td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>remove</td>
      <td>Remove the user account.</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>modify</td>
      <td>Modify the user account.</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>manage</td>
      <td>Manage the user account.</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>lock</td>
      <td>Lock the user's password.</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>unlock</td>
      <td>Unlock the user's password.</td>
      <td>&nbsp;</td>
    </tr>
  </tbody>
</table>

### <a name="lwrps-ua-attributes"></a> Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>username</td>
      <td><b>Name attribute:</b> The name of the user.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>comment</td>
      <td>Gecos/Comment field.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>uid</td>
      <td>The numeric user id.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>gid</td>
      <td>The primary group id.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>groups</td>
      <td>Array of other groups this user should be a member of.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>home</td>
      <td>Home directory location.</td>
      <td><code>"#{node['user']['home_root']}/#{username}</code></td>
    </tr>
    <tr>
      <td>shell</td>
      <td>The login shell.</td>
      <td><code>node['user']['default_shell']</code></td>
    </tr>
    <tr>
      <td>password</td>
      <td>Shadow hash of password.</td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>system_user</td>
      <td>Whether or not to create a system user.</td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td>manage_home</td>
      <td>Whether or not to manage the home directory.</td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td>non_unique</td>
      <td>Whether or not to allow the creation of a user account with a duplicate UID.</td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td>create_group</td>
      <td>
        Whether or not to to create a group with the same name as the user.
      </td>
      <td><code>node['user']['create_group']</code></td>
    </tr>
    <tr>
      <td>ssh_keys</td>
      <td>
        A <b>String</b> or <b>Array</b> of SSH public keys to populate the
        user's <code>.ssh/authorized_keys</code> file.
      </td>
      <td><code>[]</code></td>
    </tr>
    <tr>
      <td>ssh_keygen</td>
      <td>Whether or not to generate an SSH keypair for the user.</td>
      <td><code>node['user']['ssh_keygen']</code></td>
    </tr>
    <tr>
      <td>groups</td>
      <td>An Array of groups to which to add the user.</td>
      <td><code>[]</code></td>
    </tr>
  </tbody>
</table>

#### <a name="lwrps-ua-examples"></a> Examples

##### Creating a User Account

    user_account 'hsolo' do
      comment   'Han Solo'
      ssh_keys  ['3dc348d9af8027df7b9c...', '2154d3734d609eb5c452...']
      home      '/opt/hoth/hsolo'
    end

##### Creating and Locking a User Account

    user_account 'lando' do
      action  [:create, :lock]
    end

##### Removing a User account

    user_account 'obiwan' do
      action  :remove
    end

## <a name="development"></a> Development

* Source hosted at [GitHub][repo]
* Report issues/Questions/Feature requests on [GitHub Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make.

## <a name="license"></a> License and Author

Author:: [Fletcher Nichol][fnichol] (<fnichol@nichol.ca>) [![endorse](http://api.coderwall.com/fnichol/endorsecount.png)](http://coderwall.com/fnichol)

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

[berkshelf]:      http://berkshelf.com/
[chef_repo]:    https://github.com/opscode/chef-repo
[cheffile]:     https://github.com/applicationsonline/librarian/blob/master/lib/librarian/chef/templates/Cheffile
[kgc]:          https://github.com/websterclay/knife-github-cookbooks#readme
[librarian]:    https://github.com/applicationsonline/librarian#readme
[ruby-shadow_gem]:  https://rubygems.org/gems/ruby-shadow

[repo]:         https://github.com/fnichol/chef-user
[issues]:       https://github.com/fnichol/chef-user/issues
