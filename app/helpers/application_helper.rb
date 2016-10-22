module ApplicationHelper
  def posted_by(object, with_icons = false)
   "#{ with_icons ? content_tag(:i,'', class: "fa fa-clock-o") : '' } 
      Posted #{ time_ago_in_words(object.created_at) } ago by 
      #{ with_icons ? content_tag(:i,'', class: "fa fa-user") : '' }  
      #{object.user.username}".html_safe
  end
  
  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
  
  def bootstrap_class_for(flash_type)
    { success: "success", error: "danger", alert: "warning", notice: "info" }[flash_type] || flash_type.to_s
  end
end
