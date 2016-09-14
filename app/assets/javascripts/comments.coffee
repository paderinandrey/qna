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
 
AddComment = (e) ->
  e.preventDefault()
  $(this).hide()
  commentable_id = $(this).data('commentableId')
  commentable_type = $(this).data('commentableType')
  $(".new-comment#for-#{ commentable_type }-#{ commentable_id }").replaceWith(JST['templates/new-comment']({ commentable_id: commentable_id, commentable_type: commentable_type }))
  $("form#new-comment-for-#{ commentable_type }-#{ commentable_id }").show()
 
$(document).ready ->
  $(document).on('click', '.edit-comment-link', editComment)
  $(document).on('click', '.add-comment-link', AddComment)
