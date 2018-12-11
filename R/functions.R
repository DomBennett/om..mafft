
#' @name mafft
#' @title mafft
#' @description Run mafft
#' @param ... Arguments
#' @example examples/mafft.R
#' @export
mafft <- function(...) {
  arglist <- outsider::.arglist_get(...)
  files_to_send <- outsider::.filestosend_get(arglist)
  arglist <- outsider::.arglist_parse(arglist)
  # write arglist as script
  script_flpth <- file.path(tempdir(), 'script')
  write(x = paste(c('mafft', arglist), collapse = ' '), file = script_flpth)
  on.exit(file.remove(script_flpth))
  otsdr <- outsider::.outsider_init(repo = 'dombennett/om..mafft',
                                    cmd = 'bash', wd = getwd(),
                                    files_to_send = c(files_to_send,
                                                      script_flpth),
                                    arglist = 'script')
  if ('--help' %in% arglist) {
    # mafft raises an error for --help
    otsdr$ignore_errors <- TRUE
    outsider::.run(otsdr)
  } else {
    res <- outsider::.run(otsdr)
  }
  invisible(res)
}
