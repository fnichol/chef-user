require 'minitest/autorun'
require 'chef/node'
require 'chef/run_context'
require 'chef/recipe'
require 'chef/providers'
require 'chef/resources'
require 'chef/mixin/convert_to_class_name'

describe 'User::Recipe::Default' do

  include Chef::Mixin::ConvertToClassName

  before do
    @node = Chef::Node.new
    @run_context = Chef::RunContext.new(@node, nil, nil)
    @recipe = load_recipe(@run_context)
  end

  it "contains no resources" do
    resource_collection.all_resources.must_be_empty
  end

  private

  def load_recipe(run_context)
    recipe = Chef::Recipe.new(cookbook_name, recipe_name, @run_context)
    recipe.from_file(File.join(File.dirname(__FILE__), %w{.. .. .. recipes},
     "#{convert_to_snake_case(recipe_name)}.rb"))
    recipe
  end

  def cookbook_name
    self.class.to_s.split('::').first
  end

  def recipe_name
    self.class.to_s.split('::').last
  end

  def resource_collection
    @run_context.resource_collection
  end
end
