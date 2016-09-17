# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

voting = (e, data, status, xhr) ->
  votable = $.parseJSON(xhr.responseText)
  $("#vote-for-question-#{ votable.votable_id }").replaceWith(JST['templates/vote']({ votable: votable }))
  
voteError = (e, data, status, xhr) ->
  errors = $.parseJSON(xhr.responseText)
  $.each errors, (index, value) ->
    $('.vote-errors').append(value)

createQuestion = (question) ->
  $('.questions').append('<h4><a href="/questions/'+question.id+'">' + question.title + '</a></h4>')
  $('.questions').append('<p>'+ question.body + '</p>')

$(document).ready ->
  $(document).on('ajax:success', '.voting', voting)
  $(document).on('ajax:error', '.vote-errors', voteError)

  PrivatePub.subscribe '/questions', (data, channel) ->
    question = $.parseJSON(data['question'])
    console.log(question)
    createQuestion(question)
