
#' @name mafft
#' @title mafft
#' @description Run mafft
#' @param ... Arguments
#' @example examples/mafft.R
#' @export
mafft <- function(...) {
  arglist <- outsider::.arglist_get(...)
  files_to_send <- outsider::.filestosend_get(arglist)
  otsdr <- outsider::.outsider_init(repo = 'dombennett/om..mafft',
                                    cmd = 'mafft', wd = getwd(),
                                    files_to_send = files_to_send,
                                    arglist = arglist)
  if (arglist == '--help') {
    # mafft raises an error for --help
    try(outsider::.run(otsdr), silent = TRUE)
    res <- TRUE
  } else {
    res <- outsider::.run(otsdr)
  }
  invisible(res)
}
