module ApplicationHelper
  def posted_by(object, with_icons = false)
   "#{ with_icons ? content_tag(:i,'', class: "fa fa-clock-o") : '' } 
      Posted #{ time_ago_in_words(object.created_at) } ago by 
      #{ with_icons ? content_tag(:i,'', class: "fa fa-user") : '' }  
      #{object.user.username}".html_safe
  end
end
