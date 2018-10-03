pkgnm <- environmentName(env = environment())

#' @name mafft
#' @title mafft
#' @description Run mafft
#' @param ... Arguments
#' @example examples/mafft.R
#' @export
mafft <- function(...) {
  args <- outsider::.args_parse(...)
  files_to_send <- outsider::.which_args_are_filepaths(args)
  outsider::.run(pkgnm = pkgnm, files_to_send = files_to_send,
                 'mafft', args)
}
