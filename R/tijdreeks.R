#' @title helper function to make ois bar plot in ggplot2
#' @import ggplot2 dplyr forcats
#' @importFrom rlang :=
#' @param .data het dataframe wat wordt meegeven aan de plot
#' @param y_as de waarde die op de y-as worden getoond
#' @param tijd_as de waarde die op de x-as worden getoond
#' @param percent y-as schaal in percentages
#' @param lijndikte dikte van lijn 0.9 lijkt meest op OIS-huisstijl
#' @export
tijdreeks <- function(.data, y_as, tijd_as, percent = TRUE, lijndikte = .9, ...){

  y_as <- enquo(y_as)
  tijd_as <- enquo(tijd_as)


  if(percent){

    y_scale <- scale_y_continuous(labels = scales::percent_format(accuracy = 1))

  } else {

    y_scale <- NULL

  }


  .data %>%
    ggplot2::ggplot(aes(
      y = {{y_as}},
      x = {{tijd_as}}
    )) +
    ggplot2::geom_line(size = lijndikte, color = kleur_fun(1)[1]) +
    ggtheme.ois::theme_ois() +
    y_scale +
    ggplot2::labs(x = NULL,
                  y = NULL) +
    ggplot2::theme(legend.position = "none")

}
