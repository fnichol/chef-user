require 'minitest/autorun'
require 'chef/node'
require 'chef/platform'

describe 'User::Attributes::Default' do
  let(:attr_ns) { 'user' }

  before do
    @node = Chef::Node.new
    @node.consume_external_attrs(ohai_data, {})
    @node.from_file(File.join(File.dirname(__FILE__), %w{.. .. attributes default.rb}))
  end

  let(:ohai_data) do
    { :platform => "default_os", :platform_version => '1.23' }
  end

  %w{debian ubuntu redhat centos amazon scientific fedora freebsd suse}.each do |platform|
    describe "for #{platform} platform" do
      let(:ohai_data) do
        { :platform => platform, :platform_version => '666' }
      end

      it "sets default home root" do
        @node[attr_ns]['home_root'].must_equal "/home"
      end

      it "sets default shell" do
        @node[attr_ns]['default_shell'].must_equal "/bin/bash"
      end
    end
  end

  %w{openbsd}.each do |platform|
    describe "for #{platform} platform" do
      let(:ohai_data) do
        { :platform => platform, :platform_version => '666' }
      end

      it "sets default home root" do
        @node[attr_ns]['home_root'].must_equal "/home"
      end

      it "sets default shell" do
        @node[attr_ns]['default_shell'].must_equal "/bin/ksh"
      end
    end
  end

  %w{mac_os_x mac_os_x_server}.each do |platform|
    describe "for #{platform} platform" do
      let(:ohai_data) do
        { :platform => platform, :platform_version => '666' }
      end

      it "sets default home root" do
        @node[attr_ns]['home_root'].must_equal "/Users"
      end

      it "sets default shell" do
        @node[attr_ns]['default_shell'].must_equal "/bin/bash"
      end
    end
  end

  %w{bogus_os}.each do |platform|
    describe "for #{platform} platform" do
      let(:ohai_data) do
        { :platform => platform, :platform_version => '666' }
      end

      it "sets default home root" do
        @node[attr_ns]['home_root'].must_equal "/home"
      end

      it "sets a nil default shell" do
        @node[attr_ns]['default_shell'].must_be_nil
      end
    end
  end

  describe "for all platforms" do
    it "sets default manage home" do
      @node[attr_ns]['manage_home'].must_equal "true"
    end

    it "sets default create user group" do
      @node[attr_ns]['create_user_group'].must_equal "true"
    end

    it "sets default ssh keygen" do
      @node[attr_ns]['ssh_keygen'].must_equal "true"
    end

    it "sets default data bag name" do
      @node[attr_ns]['data_bag_name'].must_equal "users"
    end
  end
end
