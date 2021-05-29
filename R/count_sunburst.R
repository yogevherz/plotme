# TODO add documentation
# TODO create readme
#' Create a sunburst plot from count data
#'
#' @param count_df
#'
#' @return
#' @export
#'
#' @examples
count_to_sunburst <- function(count_df, fill_by_n = FALSE, sort_by_n = FALSE){

  params <- create_all_col_params(count_df, fill_by_n, sort_by_n)

  purrr::exec(plotly::plot_ly,
              !!!params,
              type = "sunburst",
              branchvalues = "total",
              hoverinfo = "text")
}


#' Title
#'
#' @param count_df
#'
#' @return
#' @export
#'
#' @examples
count_to_treemap <- function(count_df, fill_by_n = FALSE, sort_by_n = FALSE){

  params <- create_all_col_params(count_df, fill_by_n, sort_by_n)

  purrr::exec(plotly::plot_ly,
              !!!params,
              type = "treemap",
              branchvalues = "total",
              hoverinfo = "text")
}


create_all_col_params <- function(count_df, fill_by_n, sort_by_n){

  assert_count_df(count_df)
  assertthat::assert_that(is.logical(fill_by_n),
                          length(fill_by_n) == 1,
                          msg = "fill_by_n must be either TRUE or FALSE")

  count_df <- all_non_n_cols_to_char(count_df)

  category_num <- ncol(count_df) - 1

  params <- purrr::map(1:category_num,
                       create_one_col_params,
                       df = count_df,
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





