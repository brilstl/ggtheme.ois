#' @title helper function to add ois style to ggplot2
#' @import ggplot2
#' @export
theme_ois <- function(){


  if(Sys.info()['sysname'] == "Windows"){
    grDevices::windowsFonts("Corbel" = grDevices::windowsFont("Corbel"))
    font <- "Corbel"
  }
  else if(Sys.info()['sysname'] == "Linux"){
    dir.create('~/.fonts')
    file.copy('inst/exdata/fonts/CORBEL.TTF', '~/.fonts')
    system('fc-cache -f ~/.fonts')
    font <- "Corbel"
  }
  else{
    font <- "sans"
  }


  ggplot2::theme_bw() +
    ggplot2::theme(
      axis.text = ggplot2::element_text(family = font, size = 14),
      plot.caption = ggplot2::element_text(family = font, size = 14),
      axis.title = ggplot2::element_text(family = font, hjust = 1, size = 14),
      plot.subtitle = ggplot2::element_text(family = font, size = 15),
      legend.text = ggplot2::element_text(family = font, size = 12),
      plot.title = ggplot2::element_text(family = font, lineheight = 1.2, size = 15),
      legend.title = ggplot2::element_text(family = font, lineheight = 1.2, size = 13),
      panel.grid.minor = ggplot2::element_blank(),
      strip.background = ggplot2::element_blank(),
      legend.position="bottom",
      panel.border = ggplot2::element_rect(fill = "transparent", color = NA),
      strip.text = ggplot2::element_text(color = "black", family = font, face = "bold", size = 15)
    )


}
