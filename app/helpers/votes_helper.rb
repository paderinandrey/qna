module VotesHelper
  def voting_button_icon(votable, action)
    default_icon          = { like: 'fa-thumbs-o-up', dislike: 'fa-thumbs-o-down' }
    like_pressed_icon     = { change_vote: 'fa-thumbs-o-down', cancel_vote: 'fa-thumbs-up' }
    dislike_pressed_icon  = { change_vote: 'fa-thumbs-o-up', cancel_vote: 'fa-thumbs-down' }
    
    button_icon = current_user.voted?(votable) ? current_user.like?(votable) ? like_pressed_icon[action] : dislike_pressed_icon[action] : default_icon[action]  
  
    raw("<i class='fa #{ button_icon }'></i>")
  end
  
  def voting_buttons(votable)
    like    = { id: :like, method: :post, class: 'btn btn-secondary btn-sm' }
    dislike = { id: :dislike, method: :post, class: 'btn btn-secondary btn-sm' }
    change  = { id: :change_vote, method: :patch, class: 'btn btn-secondary btn-sm' }
    cancel  = { id: :cancel_vote, method: :delete, class: 'btn btn-primary active btn-sm' }
    
    html_options    = { remote: true, data: { type: :json } } 
    
    if user_signed_in? && !current_user.author_of?(votable)
      combinations = current_user.voted?(votable) ? current_user.like?(votable) ? [cancel, change] : [change, cancel] : [like, dislike]      
          
      content_tag(:span, class: "voting_buttons") do
        combinations.each do |param| 
          concat link_to(voting_button_icon(votable, param[:id]), polymorphic_path([param[:id], votable]), param.merge(html_options)) 
          concat " "
        end  
      end
    end  
  end
end
