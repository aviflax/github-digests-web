d = document

request_patch = (path, value) ->
  client = new XMLHttpRequest()
  client.addEventListener 'load', handle_patch_success
  client.open 'PATCH', '/account/settings'
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
  #TODO
  return

populate_orgs = (orgs) ->
  #TODO
  return

clear_emails = () ->
  dropdown = d.getElementById 'default_email'
  children = (child for child in dropdown.children)
  dropdown.removeChild child for child in children
  return

populate_emails = (emails) ->
  dropdown = d.getElementById 'default_email'

  create_option = (value, text) ->
    option = d.createElement 'option'
    option.value = value
    option.appendChild d.createTextNode text
    return option

  dropdown.appendChild create_option 'primary', "primary address (currently #{emails.primary})"
  dropdown.appendChild create_option address, address for address in emails.additional

  return

update_ui_values = (settings) ->

  # TODO: populate the email dropdown with all the valid options, then set it
  clear_emails()
  populate_emails settings.emails

  # settings.default_email will contain either 'primary', which is a directive to
  # use the primary email address in settings.emails.primary, or an email address
  d.getElementById('default_email').value = settings.default_email

  # TODO: populate the values and names of each Organization
  populate_orgs(settings.per_org_email)

  d.getElementById('daily_hour').value = settings.hour
  d.getElementById('daily_timezone').value = settings.time_zone

  return

show_ui = () ->
  d.getElementById('loading').style.display = 'none'
  d.getElementById('settings_main').style.display = 'inline-block'

delete_account = () ->
  client = new XMLHttpRequest()
  client.addEventListener 'load', ->
    alert('Account Deleted!')
    window.location = '/'
  client.open 'DELETE', '/account'
  client.send()
  return

request_get = (url, success_callback, error_callback) ->
  client = new XMLHttpRequest()

  client.addEventListener 'load', ->
    if this.status is 200
      success_callback.call this
    else if error_callback
      error_callback.call this

  if error_callback then client.addEventListener 'error', error_callback

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

redirect_home = -> window.location = '/'

# possible race condition here with the DOM being loaded.
request_get '/account/settings', handle_get_settings_success, redirect_home

d.addEventListener 'DOMContentLoaded', ->
    delete_button = d.getElementById('button_delete')

    d.getElementById('checkbox_enable_delete').addEventListener 'change', ->
      delete_button.disabled = !@checked

    delete_button.addEventListener 'click', delete_account
