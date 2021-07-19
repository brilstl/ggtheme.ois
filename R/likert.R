#' @title helper function to make ois likert scale in ggplot2
#' @import ggplot2 dplyr forcats
#' @param y_as de waarde die op de y-as worden getoond
#' @param fill de waarde waarmee de balken worden gevuld
#' @export
likert_plot <- function(.data,y_as, fill){

  ## load fonts ----

  if(Sys.info()['sysname'] == "Windows"){
    grDevices::windowsFonts("Corbel" = grDevices::windowsFont("Corbel"))
    font <- "Corbel"
  }
  else{
    font <- "sans"
  }


  # check evaluation of vars ----


  fill <- ensym(fill)
  y_as <- ensym(y_as)


  # prepare data distribution ----

  .data <- .data %>%
    dplyr::select({{y_as}}, {{fill}}) %>%
    dplyr::group_by({{y_as}}) %>%
    dplyr::mutate(n = n()) %>%
    dplyr::mutate(n = paste0(" (n = ", format(n, big.mark = ".", decimal.mark = ","), ")")) %>%
    dplyr::ungroup() %>%
    dplyr::mutate('{{y_as}}' := paste0({{y_as}}, " ", n),
                  '{{y_as}}' := as_factor({{y_as}})) %>%
    dplyr::ungroup() %>%
    dplyr::mutate('{{fill}}' := as_factor({{fill}}),
                  '{{fill}}' := fct_explicit_na({{fill}}, "geen antwoord")) %>%
    dplyr::group_by({{y_as}}, {{fill}}) %>%
    dplyr::count() %>%
    dplyr::ungroup() %>%
    dplyr::group_by({{y_as}}) %>%
    dplyr::mutate(percent = n/sum(n) * 100)

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

  # plot data ----

  .data %>%
    ggplot2::ggplot(aes(y = {{y_as}},
               x = percent, fill = {{fill}})) +
    ggplot2::scale_fill_manual(values = c(kleur)) +
    ggplot2::geom_bar(stat = "identity",
             position = ggplot2::position_stack(),
             width = 0.8) +
    ggplot2::guides(fill = ggplot2::guide_legend(nrow = 1)) +
    ggplot2::labs(x=NULL, y=NULL, fill = NULL) +
    ggplot2::scale_x_reverse(breaks = seq(0, 100, 20),
                             labels = c("100%","80", "60", "40", "20", "0"),
                             expand = c(0.051,0.01)) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      axis.text = ggplot2::element_text(family = font, size = 15),
      plot.caption = ggplot2::element_text(family = font, size = 15),
      axis.title = ggplot2::element_text(family = font, hjust = 1, size = 15),
      plot.subtitle = ggplot2::element_text(family = font, size = 18),
      legend.text = ggplot2::element_text(family = font, size = 12),
      plot.title = ggplot2::element_text(family = font, lineheight = 1.2, size = 19),
      legend.title = ggplot2::element_text(family = font, lineheight = 1.2, size = 13),
      panel.grid.minor = ggplot2::element_blank(),
      strip.background = ggplot2::element_blank(),
      legend.position= "bottom",
      panel.border = ggplot2::element_rect(fill = "transparent", color = NA),
      strip.text = ggplot2::element_text(color = "black", family = font, face = "bold", size = 15)
    )
}
