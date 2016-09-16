module Commented
  extend ActiveSupport::Concern
  included do
    before_action :load_commentable, only: [:add_comment]
  end
  
  def add_comment
    @comment = @commentable.comments.build(comment_params.merge(user: current_user))
    respond_to do |format|
      if @comment.save
        format.js do
          PrivatePub.publish_to "/questions/#{ question_id(@commentable) }/comments", comment: @comment.to_json
          head :ok
        end
      else
        format.js { flash[:error] = 'ERROR!' }
      end
    end
  end

  private
  
  def comment_params
    params.require(:comment).permit(:body)
  end
  
  def load_commentable
    @commentable = controller_name.classify.constantize.find(params[:id])
  end
  
  def question_id(commentable)
    commentable.class == Question ? commentable.id : commentable.question_id
  end
end
