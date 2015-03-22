include_recipe 'user'

user_account 'hsolo' do
  comment   'Han Solo'
  ssh_keys  ['key111...', 'key222...']
  home      '/opt/hoth/hsolo'
end

user_account 'lando' do
  action  [:create, :lock]
end

user_account 'obiwan' do
  action  :remove
end

user_account 'darth.vader' do
  uid         4042
  non_unique  true
end

user_account 'askywalker' do
  uid         4042
  non_unique  true
end

# set up an existing user with an existing key.

test_user = 'leia'
test_user_home = "/home/#{test_user}"

user test_user do
  supports :manage_home => true
  home test_user_home
end

directory "#{test_user_home}/.ssh" do
  mode '0700'
  owner test_user
  group test_user
end

file "#{test_user_home}/.ssh/id_dsa" do
  content 'bogus'
end

user_account 'leia'
