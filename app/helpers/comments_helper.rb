module CommentsHelper
  def comment_to_json(comment, action)
    render_to_string(partial: 'comments/comment.json.jbuilder', locals: { comment: comment, action: action })
  end
end
