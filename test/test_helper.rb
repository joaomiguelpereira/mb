ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
require "factories/factories"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  def assert_error_flashed(i18nkey, *params)
    assert_equal I18n.t(i18nkey,*params), flash[:error]
  end
  
   def assert_success_flashed(i18nkey,*params)
    assert_equal I18n.t(i18nkey,*params), flash[:success]
  end
  
  def authenticated_user(user)
    {:user_id=>user.id}
  end
end
