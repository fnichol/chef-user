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
