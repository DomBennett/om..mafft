library(outsider)
repo <-  'dombennett/om..mafft'
module_install(repo = repo, force = TRUE)
mafft <- module_import('mafft', repo = repo)
mafft('--help')
module_uninstall(repo = repo)
