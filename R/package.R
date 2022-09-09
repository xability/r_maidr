#' Print R objects in \pkg{knitr} documents nicely
#'
#' The main documentation of this package is the package vignette
#' \file{data11y-intro.html}. Please check out \code{vignette('data11y', package =
#' 'data11y')}.
#' @name data11y
#' @aliases data11y-package
#' @import utils
#' @importFrom knitr asis_output kable knit_print
NULL

# unregister S3 methods in this package
unregister_S3 = function() {
  if (!('knitr' %in% loadedNamespaces())) return()
  objs = ls(asNamespace('data11y'))
  s3env = getFromNamespace('.__S3MethodsTable__.', 'knitr')
  rm(list = intersect(objs, ls(s3env)), envir = s3env)
}

# remove S3 methods when the package is unloaded
.onUnload = function(libpath) unregister_S3()
