# TODO add documentation
# TODO create readme


#' Create an interactive plotly from count data
#'
#' @description
#' These functions help you quickly create heirarchal and interactive plots
#' from categorical data. They expect the summary of the data created by
#' `dplyr::count()` and produce either a sunburst plot (`count_to_sunburst()`) or
#' a treemap plot (`count_to_treemap()`)
#'
#' @param count_data An output of dplyr::count(), tibble or data frame
#' @param fill_by_n If TRUE, uses a continuous scale to fill plot by group size
#' @param sort_by_n If TRUE, sorts groups in plot by size, if FALSE sorts them alphabetically
#'
#' @export
#' @examples
#' library(dplyr)
#' starwars_count <- count(starwars, species, eye_color, name)
#'
#' # sunburst plot
#' count_to_sunburst(starwars_count)
#'
#' # fill by group size
#' count_to_sunburst(starwars_count, fill_by_n = TRUE)
#'
#' # treemap plot, ordered by group size
#' count_to_treemap(starwars_count, sort_by_n = TRUE)
#'
#' # display al charchaters by homeworld
#' starwars %>%
#'   count(homeworld, name) %>%
#'   count_to_treemap(sort_by_n = TRUE)
count_to_sunburst <- function(count_data, fill_by_n = FALSE, sort_by_n = FALSE){

  params <- create_all_col_params(count_data, fill_by_n, sort_by_n)

  purrr::exec(plotly::plot_ly,
              !!!params,
              type = "sunburst",
              branchvalues = "total",
              hoverinfo = "text")
}


#' @export
#' @rdname count_to_sunburst
count_to_treemap <- function(count_data, fill_by_n = FALSE, sort_by_n = FALSE){

  params <- create_all_col_params(count_data, fill_by_n, sort_by_n)

  purrr::exec(plotly::plot_ly,
              !!!params,
              type = "treemap",
              branchvalues = "total",
              hoverinfo = "text")
}


create_all_col_params <- function(count_data, fill_by_n, sort_by_n){

  assert_count_df(count_data)
  assertthat::assert_that(is.logical(fill_by_n),
                          length(fill_by_n) == 1,
                          msg = "fill_by_n must be either TRUE or FALSE")
  assertthat::assert_that(is.logical(sort_by_n),
                          length(sort_by_n) == 1,
                          msg = "sort_by_n must be either TRUE or FALSE")

  count_data <- all_non_n_cols_to_char(count_data)

  category_num <- ncol(count_data) - 1

  params <- purrr::map(1:category_num,
                       create_one_col_params,
                       df = count_data,
                       root = "") %>%
    dplyr::bind_rows() %>%
    dplyr::mutate(sort = sort_by_n)

  if(fill_by_n){
    params <- params %>%
      dplyr::mutate(marker = list(
        colorbar = list(
          bgcolor = ""
          )
      ))
  }
  params
}

create_one_col_params <- function(df,
                                  col_num,
                                  root){
  col_name <- names(df)[col_num]

  df %>%
    dplyr::group_by(dplyr::across(1:dplyr::all_of(col_num))) %>%
    dplyr::summarise(values = sum(.data$n), .groups = "drop") %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      ids = paste(dplyr::c_across(1: !!col_num),
                  collapse = ".->."),
      parents = ifelse(!!col_num > 1,
                       paste(dplyr::c_across(1 :(!!col_num - 1)),
                             collapse = ".->."),
                       root)
    ) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(labels = .[[!!col_num]],
                  hovertext = stringr::str_glue(
                    "column: {col_name}\nvalue: {labels}\nn: {values}")
    ) %>%
    dplyr::select(ids, parents, labels, values, hovertext)
}





