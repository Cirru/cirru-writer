
var
  writer $ require :./writer
  req $ new XMLHttpRequest
  source $ document.querySelector :#source
  compiled $ document.querySelector :#compiled

require :./layout.css

req.open :GET :./ast/patel.json
= req.onload $ \ (res)
  var $ code req.responseText
  = source.value code
  render code

req.send

var $ render $ \ (code)
  try
    do
      var
        display $ writer.render $ JSON.parse code
      = compiled.value display
    err
      var
        message err.message
        stack err.stack
      = compiled.value $ + message ":\n\n" stack

source.addEventListener :input $ \ (event)
  render event.target.value

