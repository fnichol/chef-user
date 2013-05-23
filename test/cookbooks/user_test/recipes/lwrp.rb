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
