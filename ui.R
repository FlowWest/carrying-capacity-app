navbarPage(
  title = 'Chinook Carrying Capacity',
  theme = shinytheme('cosmo'),
  # tags$header(includeCSS('styles.css')),
  # title + branding
  tabPanel('Natal-shed Capacity',
           natal_shed_ccUI('one')),
  tabPanel('Accumulated Downstream Capacity'),
  tabPanel('Notes',
           notesUI('one'))
)
