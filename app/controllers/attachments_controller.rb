class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  
  def destroy
    @attachment = Attachment.find(params[:id])
    if current_user.author_of?(@attachment.attachable)
      @attachment.destroy
      flash[:notice] = 'File deleted'
    else
      flash[:error] = 'You cannot delete a file!'
    end
  end
end
