# Takes count_df, barnchvalues (default = "total"), any additional arguments
# Returns sunburst plotly
# TODO add documentation
# TODO create readme
# TODO Add option to send arguments to plot_ly func
# TODO Add option to mask default branchvalue
# TODO pretify hover text
# TODO figure out what to do with NAs, try and paint them differently
# TODO find a way to incorporate colors? Maybe only in path function

#' Create a sunburst plot from count data
#'
#' @param count_df
#' @param root
#'
#' @return
#' @export
#'
#' @examples
count_to_sunburst <- function(count_df){

  params <- create_all_col_params(count_df)

  purrr::exec(plotly::plot_ly,
              !!!params,
              type = "sunburst",
              branchvalues = "total",
              hoverinfo = "text")
}


#' Title
#'
#' @param count_df
#' @param root
#'
#' @return
#' @export
#'
#' @examples
count_to_treemap <- function(count_df){

  params <- create_all_col_params(count_df)

  purrr::exec(plotly::plot_ly,
              !!!params,
              type = "treemap",
              branchvalues = "total",
              hoverinfo = "text")
}


create_all_col_params <- function(count_df){

  assert_count_df(count_df)

  count_df <- all_non_n_cols_to_char(count_df)

  category_num <- ncol(count_df) - 1

  purrr::map(1:category_num,
             create_one_col_params,
             df = count_df,
             root = "") %>%
    dplyr::bind_rows() %>%
    dplyr::mutate(hovertext = stringr::str_glue(
      "column: {hovertext}\nvalue: {labels}\nn: {values}"))
}

create_one_col_params <- function(df,
                                  col_num,
                                  root){
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
                  hovertext = names(.)[!!col_num]) %>%
    dplyr::select(ids, parents, labels, values, hovertext)
}





