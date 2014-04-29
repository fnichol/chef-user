if defined?(ChefSpec)
  ChefSpec::Runner.define_runner_method :user_account
  def create_user_account(user)
    ChefSpec::Matchers::ResourceMatcher.new(:user_account, :create, user)
  end
  def remove_user_account(user)
    ChefSpec::Matchers::ResourceMatcher.new(:user_account, :remove, user)
  end
  def modify_user_account(user)
    ChefSpec::Matchers::ResourceMatcher.new(:user_account, :modify, user)
  end
  def manage_user_account(user)
    ChefSpec::Matchers::ResourceMatcher.new(:user_account, :manage, user)
  end
  def lock_user_account(user)
    ChefSpec::Matchers::ResourceMatcher.new(:user_account, :lock, user)
  end
  def unlock_user_account(user)
    ChefSpec::Matchers::ResourceMatcher.new(:user_account, :unlock, user)
  end
end
