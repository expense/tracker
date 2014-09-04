
$ ->
  $('.authenticate-form')
    .on 'submit', (e) ->
      text = $('#key').val()
      localStorage.apiKey = text
      document.cookie = 'API_KEY=' + encodeURIComponent(text)
      e.preventDefault()
      location.reload()
    .each ->
      $('#key').val(localStorage.apiKey)
