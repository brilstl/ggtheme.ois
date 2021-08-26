#' @title helper function to make ois bar plot in ggplot2
#' @import ggplot2 dplyr forcats
#' @param .data het dataframe wat wordt meegeven aan de plot
#' @param y_as de waarde die op de y-as worden getoond
#' @export
bar_plot <- function(.data, y_as, percent = TRUE){

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
    mutate('{{y_as}}' := as_factor({{y_as}}),
           '{{y_as}}' := fct_explicit_na({{y_as}}, "geen antwoord"),
           '{{y_as}}' := fct_reorder({{y_as}}, n))


  kleur_lab <- .data %>%
    distinct({{y_as}}) %>%
    arrange({{y_as}}) %>%
    pull({{y_as}})

  kleur_lab


  gray_check <- as.character(
    kleur_lab[grepl(
    "geen antwoord",
    as.character(kleur_lab),
    ignore.case = TRUE
    )]
  )



  .data %>%
    mutate('{{y_as}}' := fct_relevel({{y_as}},
                                     gray_check,
                                     after = 0),
           highlight = fct_other({{y_as}},
                                 keep = gray_check,
                                 other_level = "named")) %>%
    ggplot(aes(
      y = {{y_as}},
      x = n,
      fill = highlight
    )) +
    geom_col() +
    scale_fill_manual(values = c("grey91", "#71BDEE")) +
    scale_x_continuous(labels = label_percentage) +
    theme_ois()


}
