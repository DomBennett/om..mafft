.flpth_check <- function(flpth) {
  if (!any(c(file.exists(flpth), dir.exists(flpth)))) {
    stop('[', flpth, '] does not exist')
  }
}

#' @name mafft
#' @title Multiple Alignment through Fast Fourier Transformation
#' @description Run the muleiple alignment program mafft.
#' @param arglist Arguments as character vector passed to mafft
#' @example examples/mafft.R
#' @export
mafft <- function(arglist = arglist_get(...)) {
  if ('>' %in% arglist) {
    mt_pos <- which(arglist == '>')
    if (mt_pos != (length(arglist) - 1)) {
      stop('Argument order must be: c("--option", input, ">", output)',
           call. = FALSE)
    }
    output_file <- arglist[length(arglist)]
    input_file <- arglist[mt_pos - 1]
    .flpth_check(input_file)
    .flpth_check(dirpath_get(output_file))
    files_to_send <- filestosend_get(arglist = arglist)
    arglist_parsed <- arglist_parse(arglist = arglist)
    arglist_parsed[length(arglist_parsed)] <-
      basename(arglist_parsed[length(arglist_parsed)])
  } else {
    arglist_parsed <- arglist
    files_to_send <- output_file <- NULL
  }
  # return files to tempdir
  tempwd <- file.path(tempdir(), 'om_mafft')
  dir.create(tempwd)
  on.exit(unlink(x = tempwd, recursive = TRUE, force = TRUE))
  # write arglist as script
  script_flpth <- file.path(tempwd, 'script')
  script_cnntn <- file(script_flpth, 'wb')
  write(x = paste(c('mafft', arglist_parsed), collapse = ' '),
        file = script_cnntn)
  close(script_cnntn)
  otsdr <- outsider_init(pkgnm = 'om..mafft', cmd = 'bash',
                         wd = tempwd, files_to_send = c(files_to_send,
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
    returned_files <- vapply(X = fls, FUN = basename, FUN.VALUE = character(1))
    returned_file <- returned_files[returned_files == basename(output_file)]
    file.copy(from = file.path(tempwd, returned_file), to = output_file)
  }
  invisible(res)
}
