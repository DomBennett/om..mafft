.flpth_check <- function(flpth) {
  if (!any(c(file.exists(flpth), dir.exists(flpth)))) {
    stop('[', flpth, '] does not exist')
  }
}

#' @name mafft
#' @title mafft
#' @description Run mafft
#' @param arglist Arguments as character vector passed to mafft
#' @example examples/mafft.R
#' @export
# TODO: swtich arglist to args?
mafft <- function(arglist = arglist_get(...)) {
  if ('>' %in% arglist) {
    arglist_parsed <- arglist
    input_i <- which(arglist == '>') - 1
    input_file <- arglist[input_i]
    .flpth_check(input_file)
    arglist_parsed[input_i] <- basename(input_file)
    output_i <- which(arglist == '>') + 1
    output_file <- arglist[output_i]
    .flpth_check(dirpath_get(output_file))
    arglist_parsed[output_i] <- basename(output_file)
    if (arglist_parsed[output_i] == arglist_parsed[input_i]) {
      stop('Input and output file names must be different', call. = FALSE)
    }
  } else {
    arglist_parsed <- arglist
    input_file <- output_file <- NULL
  }
  # return files to tempdir
  tempwd <- file.path(tempdir(), 'om_mafft')
  dir.create(tempwd)
  on.exit(unlink(x = tempwd, recursive = TRUE, force = TRUE))
  # write arglist as script
  script_flpth <- file.path(tempwd, 'script')
  write(x = paste(c('mafft', arglist_parsed), collapse = ' '),
        file = script_flpth)
  otsdr <- outsider_init(pkgnm = 'om..mafft', cmd = 'bash',
                         wd = tempwd, files_to_send = c(input_file,
                                                        script_flpth),
                         arglist = 'script')
  if ('--help' %in% arglist) {
    # mafft raises an error for --help
    otsdr$ignore_errors <- TRUE
    res <- run(otsdr)
  } else {
    res <- run(otsdr)
    # return output file
    fls <- list.files(tempwd)
    returned_file <- fls[vapply(X = fls, FUN = grepl, FUN.VALUE = logical(1),
                                x = output_file)]
    file.copy(from = file.path(tempwd, returned_file), to = output_file)
  }
  invisible(res)
}
