navbarPage(
  title = 'Chinook Carrying Capacity',
  theme = shinytheme('cosmo'),
  header = includeCSS('styles.css'),
  # title + branding
  tabPanel('Natal-shed Capacity',
           natal_shed_ccUI('one')),
  tabPanel('Accumulated Downstream Capacity',
           migrants_ccUI('one')),
  tabPanel('Notes',
           notesUI('one'))
)
