class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource
  
  def me
    respond_with current_resource_owner
  end
  
  def index
    respond_with User.everyone_but_me(current_resource_owner)
  end
end
