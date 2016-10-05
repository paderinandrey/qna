require "application_responder"

class ApplicationController < ActionController::Base
  include CommentsHelper
  
  self.responder = ApplicationResponder
  respond_to :html, :js, :json
  
  check_authorization :unless => :devise_controller?

  protect_from_forgery with: :exception
  
  respond_to do |format|
    rescue_from CanCan::AccessDenied do |exception|
      format.html { redirect_to root_url, alert: exception.message }
      format.js { head :forbidden }
      format.json { head :forbidden } 
    end
  end
end
