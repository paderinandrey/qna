class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_comment
  
  def update
    if current_user.author_of?(@comment) 
      @comment.update(comment_params)
      #flash[:notice] = 'Comment updated'
      respond_to do |format|
        format.js do
          PrivatePub.publish_to "/questions/#{ question_id(@comment.commentable) }/comments", comment: @comment.to_json(only: [:id, :body]), method: :update
          head :ok
        end
      end
    else
      flash[:error] = 'You cannot change comments written by others!'
    end
  end
  
  def destroy
    if current_user.author_of?(@comment)
      @comment.destroy
      respond_to do |format|
        format.js do
          PrivatePub.publish_to "/questions/#{ question_id(@comment.commentable) }/comments", comment: @comment.to_json(only: :id), method: :delete
          head :ok
        end
      end
      #flash[:notice] = 'Comment deleted'
    else
      flash[:error] = 'You cannot delete comments written by others!' 
    end
  end
  
  private

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
  
  def question_id(commentable)
    commentable.class == Question ? commentable.id : commentable.question_id
  end
end
