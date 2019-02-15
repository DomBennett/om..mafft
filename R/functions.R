flpth_check <- function(flpth) {
  if (!file.exists(flpth)) {
    stop('[', flpth, '] does not exist')
  }
}

#' @name mafft
#' @title mafft
#' @description Run mafft
#' @param ... Arguments
#' @example examples/mafft.R
#' @export
mafft <- function(...) {
  arglist <- outsider::.arglist_get(...)
  if ('>' %in% arglist) {
    input_file <- arglist[which(arglist == '>') - 1]
    flpth_check(input_file)
    output_file <- arglist[which(arglist == '>') + 1]
    flpth_check(outsider::.dirpath_get(output_file))
  } else {
    input_file <- output_file <- NULL
  }
  arglist <- outsider::.arglist_parse(arglist)
  # return files to tempdir
  tempwd <- file.path(tempdir(), 'om_mafft')
  dir.create(tempwd)
  on.exit(unlink(x = tempwd, recursive = TRUE, force = TRUE))
  # write arglist as script
  script_flpth <- file.path(tempwd, 'script')
  write(x = paste(c('mafft', arglist), collapse = ' '), file = script_flpth)
  otsdr <- outsider::.outsider_init(repo = 'dombennett/om..mafft',
                                    cmd = 'bash', wd = tempwd,
                                    files_to_send = c(input_file,
                                                      script_flpth),
                                    arglist = 'script')
  if ('--help' %in% arglist) {
    # mafft raises an error for --help
    otsdr$ignore_errors <- TRUE
    res <- outsider::.run(otsdr)
  } else {
    res <- outsider::.run(otsdr)
    # return output file
    fls <- list.files(tempwd)
    returned_file <- fls[vapply(X = fls, FUN = grepl, FUN.VALUE = logical(1),
                              x = output_file)]
    file.copy(from = file.path(tempwd, returned_file), to = output_file,
              recursive = TRUE)
  }
  invisible(res)
}
