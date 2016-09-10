# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

editAnswer = (e) ->
  e.preventDefault()
  $(this).hide()
  answer_id = $(this).data('answerId')
  answer_body = $('#answer-body-' + answer_id).text()
  $("#edit-answer-#{ answer_id }").replaceWith(JST['templates/edit-answer']({ answer_id: answer_id, answer_body: answer_body }))
  $('form#edit-answer-' + answer_id).show()

voting = (e, data, status, xhr) ->
  votable = $.parseJSON(xhr.responseText)
  $("#vote-for-answer-#{ votable.votable_id }").replaceWith(JST['templates/vote']({ votable: votable }))
  
voteError = (e, data, status, xhr) ->
  errors = $.parseJSON(xhr.responseText)
  $.each errors, (index, value) ->
    $('.vote-errors').append(value)
    
$(document).ready ->
  $(document).on('click', '.edit-answer-link', editAnswer)
  $(document).on('ajax:success', '.voting', voting)
  $(document).on('ajax:error', '.vote-errors', voteError)
