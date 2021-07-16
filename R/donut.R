donut_plot <- function(.data,y_as, fill){

  if(Sys.info()['sysname'] == "Windows"){
    windowsFonts("Corbel" = windowsFont("Corbel"))
    font <- "Corbel"
  }
  else{
    font <- "sans"
  }

  .data %>%
    dplyr::select({{y_as}}, {{fill}}) %>%
    dplyr::group_by({{y_as}}) %>%
    dplyr::mutate(n = n()) %>%
    dplyr::mutate(n = paste0(" (n = ", format(n, big.mark = "."), ")")) %>%
    dplyr::ungroup() %>%
    dplyr::mutate('{{y_as}}' := paste0({{y_as}}, " ", n),
                  '{{y_as}}' := forcats::as_factor({{y_as}}),
                  '{{y_as}}' := forcats::fct_rev({{y_as}})) %>%
    dplyr::ungroup() %>%
    dplyr::mutate('{{fill}}' := forcats::as_factor({{fill}}),
                  '{{fill}}' := forcats::fct_explicit_na({{fill}}, "niet bekend")) %>%
    dplyr::group_by({{y_as}}, {{fill}}) %>%
    dplyr::count() %>%
    dplyr::ungroup() %>%
    dplyr::group_by({{y_as}}) %>%
    dplyr::mutate(percentage = n/sum(n) * 100,
                  ymax = cumsum(percentage),
                  ymin = c(0, head(ymax, n=-1)),
                  labelPosition = (ymax + ymin) / 2) %>%
    ggplot2::ggplot(aes(ymax=ymax,
                        ymin=ymin,
                        xmax=4,
                        xmin=3,
                        fill={{fill}})) +
    ggplot2::geom_rect() +
    ggplot2::geom_text(x=2,
                      aes(y=labelPosition,
                          label= sprintf("%0.0f%%", percentage),
                          color={{fill}}),
                          fontface = "bold",
                          check_overlap = TRUE,
                          show.legend = FALSE,
                          family = font,
                          size=4) +
    # ggplot2::scale_fill_manual(values = kleur) +
    # ggplot2::scale_color_manual(values = kleur) +
    ggplot2::coord_polar(theta="y") +
    ggplot2::guides(fill = ggplot2::guide_legend(label.position = "bottom")) +
    ggplot2::labs(fill = NULL) +
    ggplot2::xlim(c(-1, 4)) +
    ggplot2::theme_void() +
    ggplot2::theme(legend.position = "bottom",
                   panel.border = ggplot2::element_rect(fill = "transparent", color = NA),
                   strip.text = ggplot2::element_text(color = "black",
                                                      family = font,
                                                      face = "bold",
                                                      size = 15))

}
