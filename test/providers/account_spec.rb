require 'minitest/autorun'
require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe 'Chef::Provider::UserAccount' do
  include ProviderMixins

  let(:cookbook)  { :user }
  let(:lwrp)      { :account }

  before  { @it = load_provider(cookbook, lwrp).new }
  after   { unload_provider(cookbook, lwrp) }
end
