# Takes count_df, barnchvalues (default = "total"), any additional arguments
# Returns sunburst plotly
# TODO find a way to incorporate colors? Maybe only in path function
# TODO figure out what to do with NAs, try and paint them differently
# TODO Add assertions
# TODO make different col types work (probably convert all to char)
# TODO Add option to send arguments to plot_ly func

#' Create a sunburst plot from count data
#'
#' @param count_df
#'
#' @return
#' @export
#'
#' @examples
count_to_sunburst <- function(count_df,
                              root = NULL){

  params <- create_all_col_params(count_df, root)

  purrr::exec(plotly::plot_ly,
              !!!params,
              type = 'sunburst',
              branchvalues = 'total')
}

create_all_col_params <- function(count_df,
                                  root){
  assert_count_df(count_df)
  if (!is.null(root)){
    assertthat::assert_that(is.character(root),
                            assertthat::is.scalar(root))
  }

  category_num <- ncol(count_df) - 1

  if(is.null(root)){
    root <- ""
  }

  purrr::map(1:category_num,
             create_one_col_params,
             df = count_df,
             root = root) %>%
    dplyr::bind_rows()
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





