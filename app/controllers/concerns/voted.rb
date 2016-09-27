module Voted
  extend ActiveSupport::Concern
  included do
    before_action :load_votable, only: [:like, :dislike, :change_vote, :cancel_vote]
    respond_to :json, only: [:like, :dislike, :change_vote, :cancel_vote]
    authorize_resource
  end
  
  def like
    respond_with(@votable.set_evaluate(current_user, 1), template: vote_json_tmpl)
  end
  
  def dislike
    respond_with(@votable.set_evaluate(current_user, -1), template: vote_json_tmpl)
  end
  
  def change_vote
    respond_with(@votable.change_evaluate(current_user), template: vote_json_tmpl)
  end
  
  def cancel_vote
    respond_with(@votable.cancel_evaluate(current_user), template: vote_json_tmpl)
  end  
    
  private
  
  def load_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end
  
  def vote_json_tmpl
    'votes/vote.json.jbuilder'
  end
end
