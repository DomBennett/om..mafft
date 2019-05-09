library(outsider)
module_install(repo = 'dombennett/om..mafft')
mafft <- module_import('mafft', repo = 'dombennett/om..mafft')
mafft('--help')
