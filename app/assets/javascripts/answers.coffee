# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  
  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()
    
  $('form#new_answer').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    $('.answers').append(html)
  .bind 'ajax:error', (e, xhr, status, error) ->
    errors = $.parseJSON(xhr.responseText)
    $.each errors, (index, value) ->
      $('.answer-errors').append(value)

voting = (e, data, status, xhr) ->
  votable = $.parseJSON(xhr.responseText)
  $("#vote-for-answer-#{ votable.votable_id }").replaceWith(JST['templates/vote']({ votable: votable }))
  
voteError = (e, data, status, xhr) ->
  errors = $.parseJSON(xhr.responseText)
  $.each errors, (index, value) ->
    $('.vote-errors').append(value)
    
$(document).ready ->
  $(document).on('ajax:success', '.voting', voting)
  $(document).on('ajax:error', '.vote-errors', voteError)