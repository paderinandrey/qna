# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

editComment = (e) ->
  e.preventDefault()
  $(this).hide()
  comment_id = $(this).data('commentId')
  comment_body = $('#comment-body-' + comment_id).text()
  $(".edit-comment#comment-#{ comment_id }").replaceWith(JST['templates/edit-comment']({ comment_id: comment_id, comment_body: comment_body }))
  $('form#edit-comment-' + comment_id).show()
 
addComment = (e) ->
  e.preventDefault()
  $(this).hide()
  commentable_id = $(this).data('commentableId')
  commentable_type = $(this).data('commentableType')
  $(".new-comment#for-#{ commentable_type }-#{ commentable_id }").replaceWith(JST['templates/new-comment']({ commentable_id: commentable_id, commentable_type: commentable_type }))
  $("form#new-comment-for-#{ commentable_type }-#{ commentable_id }").show()
 
createComment = (comment) ->
  $('.comments#for-' + comment.commentable_type.toLowerCase() + '-' + comment.commentable_id).append(comment.body)
  $('#comment_body').val('')

deleteComment = (comment) ->
  $("#comment-#{ comment.id }").remove()  

updateComment = (comment) ->
  $("#comment-body-#{ comment.id }").replaceWith(comment.body)
  $('form#edit-comment-' + comment.id).remove() 
 
$(document).ready ->
  $(document).on('click', '.edit-comment-link', editComment)
  $(document).on('click', '.add-comment-link', addComment)

  commentableId = $('.comments').data('commentableId')
  PrivatePub.subscribe "/questions/#{ commentableId }/comments", (data, channel) ->
    comment = $.parseJSON(data['comment'])
    switch data['method']
      when 'delete' then deleteComment(comment)
      when 'update' then updateComment(comment)
      else createComment(comment)
