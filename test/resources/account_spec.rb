require 'minitest/autorun'
require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe 'Chef::Resource::UserAccount' do
  include ResourceMixins

  let(:cookbook)    { :user }
  let(:lwrp)        { :account }

  before  { @it = load_resource(cookbook, lwrp).new("fuzzybear") }
  after   { unload_resource(cookbook, lwrp) }

  it "sets the name attribute to username attr" do
    @it.username.must_equal "fuzzybear"
  end

  %w{uid gid}.each do |attr|
    it "takes a String value for #{attr} attr" do
      @it.send(attr, "666")
      @it.send(attr).must_equal "666"
    end

    it "takes an Integer value for #{attr} attr" do
      @it.send(attr, 777)
      @it.send(attr).must_equal 777
    end
  end

  %w{comment home shell password}.each do |attr|
    it "takes a String value for #{attr} attr" do
      @it.send(attr, "goop")
      @it.send(attr).must_equal "goop"
    end
  end

  it "takes a Boolean value for system_user attr" do
    @it.system_user true
    @it.system_user.must_equal true
  end

  it "defaults to false for system_user attr" do
    @it.system_user.must_equal false
  end

  %w{manage_home create_group ssh_keygen}.each do |attr|
    it "takes a truthy value for #{attr} attr" do
      @it.send(attr, true)
      @it.send(attr).must_equal true
    end

    it "defaults to nil for #{attr} attr" do
      @it.send(attr).must_be_nil
    end
  end

  it "takes a String value for ssh_keys attr" do
    @it.ssh_keys "mykey"
    @it.ssh_keys.must_equal "mykey"
  end

  it "takes an Array value for ssh_keys attr" do
    @it.ssh_keys ["a", "b"]
    @it.ssh_keys.must_equal ["a", "b"]
  end

  it "defaults to an empty Array for ssh_keys attr" do
    @it.ssh_keys.must_equal []
  end
end
