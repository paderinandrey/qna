require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception
  #after_filter :flash_to_headers
  
  #private
  
  #def flash_to_headers
  #  return unless request.xhr?
  #  response.headers['X-Message'] = flash_message
  #  response.headers["X-Message-Type"] = flash_type.to_s
  #  
  #  flash.discard
  #end
  
  #def flash_message
  #  [:error, :warning, :notice].each do |type|
  #    return flash[type] unless flash[type].blank?
  #  end
  #  return ''
  #end
  
  #def flash_type
  #  [:error, :warning, :notice].each do |type|
  #    return type unless flash[type].blank?
  #  end
  #end
  
  # def ensure_signup_complete
  #   # Ensure we don't go into an infinite loop
  #   return if action_name == 'finish_signup'

  #   # Redirect to the 'finish_signup' page if the user
  #   # email hasn't been verified yet
  #   if current_user && !current_user.email_verified?
  #     redirect_to finish_signup_path(current_user)
  #   end
  # end
end
