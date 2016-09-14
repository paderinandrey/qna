class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_comment
  
  def update
    if current_user.author_of?(@comment) 
      @comment.update(comment_params)
      flash[:notice] = 'Comment updated'
    else
      flash[:error] = 'You cannot change comments written by others!'
    end
  end
  
  def destroy
    if current_user.author_of?(@comment)
      @comment.destroy
      flash[:notice] = 'Comment deleted'
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
end
