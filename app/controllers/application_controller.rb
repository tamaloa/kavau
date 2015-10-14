require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  before_action :set_back_url

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  private
    def set_back_url
      if action_name == 'index' || action_name == 'show'
        session[:back_url] = url_for(controller: controller_name, action: action_name, only_path: true)
      end  
      session[:back_url] ||= url_for(controller: controller_name, action: 'index', only_path: true)
    end
end
