#' @title kleuren brewer voor OIS huisstijl
#' @param dim het aantal unieke waardes in de fill
#' @export
kleur_fun <- function(dim){

  if(dim < 5){

    kleur <- c('#004699',
               '#a6c8ec',
               '#dbecfa')

    brew_fun <- grDevices::colorRampPalette(kleur)

    kleur <- brew_fun(dim*3)

    kleur <- kleur[c(TRUE,FALSE,FALSE)]

  }else{

    kleur <- c('#004699',
               '#a6c8ec',
               '#dbecfa')
    brew_fun <- grDevices::colorRampPalette(kleur)

    kleur <- brew_fun(dim*3)

    kleur <- kleur[c(TRUE,FALSE, FALSE)]

  }




}
