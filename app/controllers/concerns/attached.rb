module Attached
  extend ActiveSupport::Concern
  included do
    before_action :load_attachable, only: [:destroy_file]
    authorize_resource
  end

  def destroy_file
    if current_user.author_of?(@attachable.attachable)
      @attachable.destroy
      flash[:notice] = 'File deleted'
    else
      flash[:error] = 'You cannot delete a file!'
    end
  end
  
  private
  
  def load_attachable
    @attachable = controller_name.classify.constantize.find(params[:id])
  end
end
