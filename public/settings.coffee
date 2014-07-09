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

request_get = ->
  client = new XMLHttpRequest()
  client.addEventListener 'load', handle_get_success
  client.responseType = 'json'
  client.open 'GET', '/settings'
  client.setRequestHeader 'Accept', 'application/json'
  client.send()
  return

handle_get_success = ->
  console.log this
  console.log this.response

request_get()

d.addEventListener 'DOMContentLoaded', ->
    delete_button = d.getElementById('button_delete')

    d.getElementById('checkbox_enable_delete').addEventListener 'change', ->
      delete_button.disabled = !@checked

    delete_button.addEventListener 'click', ->
      alert('Coming soon!')
