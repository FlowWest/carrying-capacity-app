shinyServer(function(input, output) {
  callModule(natal_shed_cc, 'one')
  callModule(notes, 'one')
  callModule(migrants_cc, 'one')
})