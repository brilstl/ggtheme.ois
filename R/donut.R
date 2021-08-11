#' @title helper function to make ois donut plot in ggplot2
#' @import ggplot2 dplyr forcats
#' @param .data het dataframe wat wordt meegeven aan de plot
#' @param fill de waarde waarmee de balken worden gevuld
#' @param facet de waarde die de groepen onderverdeelt in 'facets'
#' @export
donut_plot <- function(.data, fill, facet = NULL){

  if(Sys.info()['sysname'] == "Windows"){
    grDevices::windowsFonts("Corbel" = grDevices::windowsFont("Corbel"))
    font <- "Corbel"
  }
  else{
    font <- "sans"
  }


  # check evaluation of vars ----

  fill <- dplyr::ensym(fill)

  if(!is.null(facet)){

    facet <- dplyr::sym(facet)

  }

  if(is.null(facet)){

    .data <- .data %>%
      dplyr::select({{fill}}) %>%
      dplyr::mutate(n = n()) %>%
      dplyr::mutate('{{fill}}' := forcats::as_factor({{fill}}),
                    '{{fill}}' := forcats::fct_explicit_na({{fill}}, "geen antwoord")) %>%
      dplyr::group_by({{fill}}) %>%
      dplyr::count() %>%
      dplyr::ungroup() %>%
      dplyr::mutate(percentage = n/sum(n) * 100,
                    ymax = cumsum(percentage),
                    ymin = c(0, head(ymax, n=-1)),
                    labelPosition = (ymax + ymin) / 2)

  }else if(!is.null(facet)){

    .data <- .data %>%
      dplyr::select({{fill}}, {{facet}}) %>%
      dplyr::mutate(n = n()) %>%
      dplyr::mutate('{{fill}}' := forcats::as_factor({{fill}}),
                    '{{fill}}' := forcats::fct_explicit_na({{fill}}, "geen antwoord")) %>%
      dplyr::group_by({{fill}}, {{facet}}) %>%
      dplyr::count() %>%
      dplyr::ungroup() %>%
      dplyr::group_by({{facet}}) %>%
      dplyr::mutate(percentage = n/sum(n) * 100,
                    ymax = cumsum(percentage),
                    ymin = c(0, head(ymax, n=-1)),
                    labelPosition = (ymax + ymin) / 2)

  }


  # check and assign 'gray' cat. ----

  kleur_lab <- .data %>%
    distinct({{fill}}) %>%
    arrange({{fill}}) %>%
    pull({{fill}})

  gray_check <- sum(
    grepl(
      "geen antwoord",
      kleur_lab,
      ignore.case = TRUE
    ),
    na.rm = TRUE
  )

  kleur_n <- length(kleur_lab)

  kleur <- kleur_fun(kleur_n)

  if(gray_check == 0){

    kleur <- kleur

  }
  else if(gray_check > 0){

    n_keep <- length(kleur) - gray_check

    brew_gray <- grDevices::colorRampPalette(c('gray85', 'gray91'))

    gray_add <- brew_gray(gray_check)

    kleur <- c(kleur[c(1:n_keep)], gray_add)

  }


  # facet ----

  if(is.null(facet)){

    facet_attach <- NULL

  }else if(!is.null(facet)){

    facet_attach <- ggplot2::facet_wrap(facets = {{facet}})

  }


  .data %>%
    ggplot2::ggplot(aes(ymax=ymax,
                        ymin=ymin,
                        xmax=4,
                        xmin=3,
                        fill={{fill}})) +
    ggplot2::geom_rect() +
    ggplot2::geom_text(x=2.2,
                       aes(y=labelPosition,
                           label= sprintf("%0.0f%%", percentage),
                           color={{fill}}),
                       fontface = "bold",
                       check_overlap = TRUE,
                       show.legend = FALSE,
                       family = font,
                       size=7) +
    ggplot2::scale_fill_manual(values = kleur) +
    ggplot2::scale_color_manual(values = kleur) +
    ggplot2::coord_polar(theta="y") +
    ggplot2::guides(fill = ggplot2::guide_legend(nrow = 1)) +
    ggplot2::labs(fill = NULL) +
    ggplot2::xlim(c(-1, 4)) +
    theme_ois() +
    ggplot2::theme_void() +
    ggplot2::theme(legend.position = c(.5,.05),
                   legend.text = ggplot2::element_text(family = font, size = 12),
                   plot.title = ggplot2::element_text(family = font, lineheight = 1.2, size = 15),
                   legend.title = ggplot2::element_text(family = font, lineheight = 1.2, size = 13),
                   panel.border = ggplot2::element_rect(fill = "transparent", color = NA),
                   strip.text = ggplot2::element_text(color = "black",
                                                      family = font,
                                                      face = "bold",
                                                      size = 15)) +
    facet_attach

}
