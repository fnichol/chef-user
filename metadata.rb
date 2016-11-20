name             'user'
maintainer       'Fletcher Nichol'
maintainer_email 'fnichol@nichol.ca'
license          'Apache 2.0'
description      'A convenient Chef LWRP to manage user accounts and SSH keys (this is not the opscode users cookbook)'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.6.0'

issues_url 'https://github.com/fnichol/chef-user/issues'
source_url 'https://github.com/fnichol/chef-user'

supports 'ubuntu'
supports 'debian'
supports 'mac_os_x'
supports 'suse'
supports 'omnios'

recipe 'user', 'This recipe is a no-op and does nothing.'
recipe 'user::data_bag', 'Processes a list of users with data drawn from a data bag.'
