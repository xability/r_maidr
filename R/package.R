#' Make visualization accessible in \pkg{knitr} documents
#'
#' @name maidr
#' @aliases maidr-package
#' @import utils
# @importFrom knitr asis_output kable knit_print
NULL

# unregister S3 methods in this package
unregister_S3 <- function() {
  if (!("knitr" %in% loadedNamespaces())) {
    return()
  }
  objs <- ls(asNamespace("maidr"))
  s3env <- getFromNamespace(".__S3MethodsTable__.", "knitr")
  rm(list = intersect(objs, ls(s3env)), envir = s3env)
}

# remove S3 methods when the package is unloaded
.onUnload <- function(libpath) unregister_S3()
