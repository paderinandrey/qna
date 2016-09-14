module Commented
  extend ActiveSupport::Concern
  included do
    before_action :load_commentable, only: [:add_comment]
  end
  
  def add_comment
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
  end

  private
  
  def comment_params
    params.require(:comment).permit(:body)
  end
  
  def load_commentable
    @commentable = controller_name.classify.constantize.find(params[:id])
  end
end
