module Voted
  extend ActiveSupport::Concern
  included do
    before_action :load_votable, only: [:like, :dislike, :change_vote, :cancel_vote]
  end
  
  def like
    respond_to do |format|
      if @votable.user_can_vote?(current_user) && !@votable.user_voted?(current_user)
        if @votable.set_evaluate(current_user, 1)
          format.json { render partial: 'votes/vote', locals: { votable: @votable } }
        else
          format.json { render json: @votable.errors.full_messages, status: :unprocessable_entity }
        end  
      else
        format.json { render json: '{"error": "You cannot vote!"}', status: :unprocessable_entity }
      end
    end
  end
  
  def dislike
    respond_to do |format|
      if @votable.user_can_vote?(current_user) && !@votable.user_voted?(current_user)
        if @votable.set_evaluate(current_user, -1)
          format.json { render partial: 'votes/vote', locals: { votable: @votable } }
        else
          format.json { render json:  @votable.errors.full_messages, status: :unprocessable_entity }
        end
      else
        format.json { render json: '{"error": "You cannot vote!"}', status: :unprocessable_entity }
      end
    end
  end
  
  def change_vote
    respond_to do |format|
      if @votable.user_can_vote?(current_user) && @votable.user_voted?(current_user)
        if @votable.change_evaluate(current_user)
          format.json { render partial: 'votes/vote', locals: { votable: @votable } }
        else
          format.json { render json:  @votable.errors.full_messages, status: :unprocessable_entity }
        end
      else
        format.json { render json: '{"error": "You cannot vote!"}', status: :unprocessable_entity }
      end
    end  
  end
  
  def cancel_vote
    respond_to do |format|
      if @votable.user_can_vote?(current_user) && @votable.user_voted?(current_user)
        if @votable.cancel_evaluate(current_user)
          format.json { render partial: 'votes/vote', locals: { votable: @votable } }
        else
          format.json { render json:  @votable.errors.full_messages, status: :unprocessable_entity }
        end
      else
        format.json { render json: '{"error": "You cannot vote!"}', status: :unprocessable_entity }
      end
    end
  end  
    
  private
  
  def load_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end
end
