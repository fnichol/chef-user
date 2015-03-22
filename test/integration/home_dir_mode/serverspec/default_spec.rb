require 'spec_helper'

describe 'chef-user-test::default' do
  %w[lando darth.vader askywalker leia].each do |user|
    describe user(user) do
      it { should exist }
    end
  end

  describe user('obiwan') do
    it { should_not exist }
  end
  
  %w[darth.vader askywalker].each do |user|
    describe user(user) do
      it { should have_uid '4042' }
    end
  end
  
  describe user('hsolo') do
    it { should have_home_directory '/opt/hoth/hsolo' }
  end
  describe file('/opt/hoth/hsolo/.ssh') do
    it { should be_directory }
  end
  describe file('/opt/hoth/hsolo/.ssh/authorized_keys') do
    its(:content) { should match /key111\.\.\./ }
    its(:content) { should match /key222\.\.\./ }
  end



  describe user('leia') do
    it { should have_home_directory '/home/leia' }
  end
  describe file('/home/leia/.ssh') do
    it { should be_directory }
  end
  describe file('/home/leia/.ssh/id_dsa') do
    its(:content) { should match /bogus/ }
  end

end

