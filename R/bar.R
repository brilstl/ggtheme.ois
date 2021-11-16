#' @title helper function to make ois bar plot in ggplot2
#' @import ggplot2 dplyr forcats
#' @importFrom rlang :=
#' @param .data het dataframe wat wordt meegeven aan de plot
#' @param y_as de waarde die op de y-as worden getoond
#' @export
bar_plot <- function(.data, y_as, percent = TRUE, ...){

  y_as <- enquo(y_as)


  if(percent){

    .data <- .data %>%
      dplyr::count({{y_as}}) %>%
      dplyr::mutate(n = n/sum(n))


  }else{

    .data <- .data %>%
      dplyr::count({{y_as}})

  }

  .data <- .data %>%
    mutate('{{y_as}}' := forcats::as_factor({{y_as}}),
           '{{y_as}}' := forcats::fct_explicit_na({{y_as}}, "niet ingevuld"),
           '{{y_as}}' := forcats::fct_reorder({{y_as}}, n))


  gray_check <- ggtheme.ois::gray_shades(.data, {{y_as}}, dim_output = TRUE, ...)

  if(percent){

    x_as <- ggplot2::scale_x_continuous(labels = label_percentage)


  }else{

    x_as <- ggplot2::scale_x_continuous(labels = function(x) format(round(x, digits = 1L), big.mark = '.', decimal.mark = ','))

  }

  if(
    identical(na.omit(gray_check), character(0))
  ){
    geen_antwoord <- ggplot2::scale_fill_manual(values = c("#71BDEE"))


  }
  else{

    brew_gray <- grDevices::colorRampPalette(c('gray85', 'gray91'))

    gray_add <- brew_gray(length(gray_check))

    kleur <- c(gray_add, "#71BDEE")

    geen_antwoord <- ggplot2::scale_fill_manual(values = kleur)
  }

  .data %>%
    mutate('{{y_as}}' := forcats::fct_relevel({{y_as}},
                                     gray_check,
                                     after = 0),
           highlight = forcats::fct_other({{y_as}},
                                 keep = gray_check,
                                 other_level = "named")) %>%
    ggplot2::ggplot(aes(
      y = {{y_as}},
      x = n,
      fill = highlight
    )) +
    ggplot2::geom_col() +
    ggtheme.ois::theme_ois() +
    ggplot2::labs(x = NULL,
         y = NULL) +
    ggplot2::theme(legend.position = "none") +
    x_as +
    geen_antwoord

}
