#' Search interface for queries based on different topic models
#'
#' @export
topicsearch <- function(){
  shiny::runApp(system.file("search", package="couplr"), launch.browser = T)
}
