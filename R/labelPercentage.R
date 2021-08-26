#' @title labels voor percentages in OIS huisstijl
#' @param digit de waardes op de x-as van 0 t/m 1
#' @export
label_percentage <- function(digit){

  digit_cut <- digit[-length(digit)]

  digit_special <- digit[length(digit)]

  digit_cut <- format(
    round(
      digit_cut*100,
      digits = 1L),
    decimal.mark = ','
    )

  digit_special <- paste0(
    format(
      round(
        digit_special*100,
      digits = 1L
    ),
    decimal.mark = ','),
    "%"
    )

  c(digit_cut, digit_special)

}
