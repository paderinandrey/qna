class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create]
  before_action :load_comment, except: [:create]
  after_action -> { publish_comment(params[:action]) }
  authorize_resource
  
  respond_to :js, :json
  
  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end
  
  def update
    @comment.update(comment_params)
    respond_with(@comment)
  end
  
  def destroy
    respond_with(@comment.destroy)
  end
  
  private

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def load_commentable
    @commentable = commentable.find(params["#{ commentable_type }_id"])
  end
  
  def commentable_type
    params[:commentable_type]
  end
  
  def commentable
    commentable_type.classify.constantize
  end
  
  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment(action)
    PrivatePub.publish_to("/questions/#{ @comment.question_id }/comments",
      comment: comment_to_json(@comment, action)) if @comment.valid?
  end
end
