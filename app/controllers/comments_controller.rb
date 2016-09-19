class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create]
  before_action :load_comment, except: [:create]
  after_action -> { publish_comment(params[:action]) }
  
  respond_to :js
  
  def create
    respond_with(@comment = @commentable.comments.create(comment_params))
  end
  
  def update
    if current_user.author_of?(@comment) 
      @comment.update(comment_params)
      respond_with(@comment)
    else
      flash[:error] = 'You cannot change comments written by others!'
    end
  end
  
  def destroy
    if current_user.author_of?(@comment)
      respond_with(@comment.destroy)
    else
      flash[:error] = 'You cannot delete comments written by others!' 
    end
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
    params.require(:comment).permit(:body).merge(user: current_user)
  end
  
  def question_id(commentable)
    commentable.class == Question ? commentable.id : commentable.question_id
  end
  
  def publish_comment(action)
    PrivatePub.publish_to "/questions/#{ question_id(@comment.commentable) }/comments",
      comment: render_to_string(partial: 'comments/comment.json.jbuilder', locals: { action: action })
  end
end
