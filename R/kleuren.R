#' @title kleuren brewer voor OIS huisstijl
#' @param dim het aantal unieke waardes in de fill
#' @export
kleur_fun <- function(dim){

  kleur <- c('#004699',
             '#dbecfa')

  if(dim < 3){

    brew_fun <- grDevices::colorRampPalette(kleur)

    kleur <- brew_fun(dim*4)

    kleur <- kleur[c(1, length(kleur))]

    kleur

    }else if(dim == 3){

      brew_fun <- grDevices::colorRampPalette(kleur)

      kleur <- brew_fun(dim*4)

      kleur <- kleur[c(1, (length(kleur)/2), length(kleur))]

      kleur


      }else{

        brew_fun <- grDevices::colorRampPalette(kleur)

        kleur <- brew_fun(dim)

        kleur

        }




}
