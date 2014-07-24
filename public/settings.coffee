d = document

request_patch = (path, value) ->
  client = new XMLHttpRequest()
  client.addEventListener 'load', handle_patch_success
  client.open 'PATCH', '/settings'
  client.setRequestHeader 'Content-Type', 'application/json-patch+json'

  body = [
    {
      'op': 'replace',
      'path': path,
      'value': value
    }
  ]

  client.send JSON.stringify body
  return

handle_patch_success = ->
  return

update_ui_values = (settings) ->

  # TODO: populate the email dropdown with all the valid options, then set it

  # settings.default_email will contain either 'main', which is a directive to
  # use the main email address in settings.emails.main, or an email address
  d.getElementById('default_email').value = settings.default_email

  # TODO: populate the values and names of each Organization

  d.getElementById('daily_hour').value = settings.hour
  d.getElementById('daily_timezone').value = settings.time_zone

  return

show_ui = () ->
  d.getElementById('loading').style.display = 'none'
  d.getElementById('settings_main').style.display = 'inline-block'

request_get = (url, success_callback) ->
  client = new XMLHttpRequest()
  client.addEventListener 'load', success_callback
  client.responseType = 'json'
  client.open 'GET', url
  client.setRequestHeader 'Accept', 'application/json'
  client.send()
  return

handle_get_settings_success = ->
  console.log this
  console.log this.response
  settings = this.response

  # possible race condition here with the DOM being loaded.
  update_ui_values settings
  show_ui()

  return

# possible race condition here with the DOM being loaded.
request_get '/settings', handle_get_settings_success

d.addEventListener 'DOMContentLoaded', ->
    delete_button = d.getElementById('button_delete')

    d.getElementById('checkbox_enable_delete').addEventListener 'change', ->
      delete_button.disabled = !@checked

    delete_button.addEventListener 'click', ->
      alert('Coming soon!')
