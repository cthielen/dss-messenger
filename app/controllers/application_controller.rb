class ApplicationController < ActionController::Base
  include Authentication
  
  before_filter :authenticate, :except => [:open, :show]
  
  protect_from_forgery
  
  def logout
      CASClient::Frameworks::Rails::Filter.logout(self)
  end
end
