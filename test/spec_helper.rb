require 'chef/resource'
require 'chef/resource'

module ResourceMixins
  def load_resource(cookbook, lrwp)
    Chef::Resource.build_from_file(cookbook.to_s, File.expand_path(File.join(
      File.dirname(__FILE__), %w{.. resources}, "#{lwrp.to_s}.rb")), nil)
  end

  def unload_resource(cookbook, lwrp)
    Chef::Resource.send(:remove_const, lwrp_const(cookbook, lwrp))
  end

  def resource_klass(cookbook, lwrp)
    Chef::Resource.const_get(lwrp_const(cookbook, lrwp))
  end

  private

  def lwrp_const(cookbook, lwrp)
    :"#{cookbook.to_s.capitalize}#{lwrp.to_s.capitalize}"
  end
end

module ProviderMixins
  def load_provider(cookbook, lrwp)
    Chef::Provider.build_from_file(cookbook.to_s, File.expand_path(File.join(
      File.dirname(__FILE__), %w{.. resources}, "#{lwrp.to_s}.rb")), nil)
  end

  def unload_provider(cookbook, lwrp)
    Chef::Provider.send(:remove_const, lwrp_const(cookbook, lwrp))
  end

  def provider_klass(cookbook, lwrp)
    Chef::Provider.const_get(lwrp_const(cookbook, lrwp))
  end

  private

  def lwrp_const(cookbook, lwrp)
    :"#{cookbook.to_s.capitalize}#{lwrp.to_s.capitalize}"
  end
end
