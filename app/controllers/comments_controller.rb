class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create]
  before_action :load_comment, except: [:create]
  
  def create
    @comment = @commentable.comments.build(comment_params.merge(user: current_user))
    respond_to do |format|
      if @comment.save
        format.js { publish(@comment, :create); head :ok }
      else
        format.js { flash[:error] = 'ERROR!' }
      end
    end
  end
  
  def update
    if current_user.author_of?(@comment) 
      @comment.update(comment_params)
      respond_to do |format|
        format.js { publish(@comment, :update); head :ok }
      end
    else
      flash[:error] = 'You cannot change comments written by others!'
    end
  end
  
  def destroy
    if current_user.author_of?(@comment)
      @comment.destroy
      respond_to do |format|
        format.js { publish(@comment, :delete); head :ok }
      end
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
    params.require(:comment).permit(:body)
  end
  
  def question_id(commentable)
    commentable.class == Question ? commentable.id : commentable.question_id
  end
  
  def publish(comment, method)
    PrivatePub.publish_to "/questions/#{ question_id(comment.commentable) }/comments", 
                          comment: comment.to_builder, 
                          method: method
  end
end
