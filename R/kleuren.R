#' @title kleuren brewer voor OIS huisstijl
#' @param dim
#' @export
kleur_fun <- function(dim){

  kleur <- c('#004699',
             '#1f76c1',
             '#4fa8e4',
             '#aad5f4',
             '#e5f2fc')

  brew_fun <- grDevices::colorRampPalette(kleur)

  kleur <- brew_fun(dim*2)

  kleur <- kleur[c(TRUE,FALSE)]


}
