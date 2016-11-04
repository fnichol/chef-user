source 'https://rubygems.org'

gem 'rake'
gem 'minitest', '~> 4.7'

# version locking to support Ruby v2.1.4
gem 'foodcritic', '~> 7.1' # foodcritic 8.0+ drops support
gem 'rack', '~> 1.6'       # rack 2.0+ drops support

# allow CI to override the version of Chef for matrix testing
gem 'chef', (ENV['CHEF_VERSION'] || '12.1.0')

group :integration do
  gem 'berkshelf', '~> 4.3' # berkshelf 5.0+ drops support for Ruby <2.2
  gem 'test-kitchen', '~> 1.13'
  gem 'kitchen-vagrant'
end
