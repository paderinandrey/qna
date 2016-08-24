show_unobtrusive_flash_message = (msg, alert_type) ->
  $("#unobtrusive_flash").replaceWith("<div id='unobtrusive_flash'>
  		<p>&nbsp;</p>
          <div class='row'>
            <div class='span10 offset1'>
              <div class='alert " + alert_type + "'>
                <button type='button' class='close' data-dismiss='alert'>&times;</button>
                " + msg + "
              </div>
            </div>
          </div>
         </div>") if msg
  $("#unobtrusive_flash").delay(3000).slideUp 'fast'
  $("#unobtrusive_flash").replaceWith("<div id='unobtrusive_flash'></div>") unless msg

$(document).ajaxComplete (event, request) ->
  msg = request.getResponseHeader("X-Message")
  alert_type = 'alert-success'
  alert_type = 'alert-danger' unless request.getResponseHeader("X-Message-Type").indexOf("error") is -1
  show_unobtrusive_flash_message msg, alert_type
