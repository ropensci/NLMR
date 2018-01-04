#' Import Roboto Condensed font for use in charts
#'
#' Roboto Condensed is a trademark of Google.
#'
#' @md
#' @note This will take care of ensuring PDF/PostScript usage. The location of the
#'   font directory is displayed after the base import is complete. It is highly
#'   recommended that you install them on your system the same way you would any
#'   other font you wish to use in other programs.
#' @export
#' @aliases util_import_roboto_condensed
#' @rdname util_import_roboto_condensed
#'
util_import_roboto_condensed <- function() {
  # borrowed from hrbrmstr and his great package hrbrthemes
  # https://github.com/hrbrmstr/hrbrthemes

  rc_font_dir <-
    system.file("fonts", "roboto-condensed", package = "NLMR")

  suppressWarnings(suppressMessages(extrafont::font_import(rc_font_dir, prompt =
                                                             FALSE)))

  message(
    sprintf(
      "You will likely need to install these fonts on your system as well.\n\n
      You can find them in [%s]",
      rc_font_dir
    )
  )

}
