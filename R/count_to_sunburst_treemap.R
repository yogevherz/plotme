
#' Create an interactive plotly from count data
#'
#' @description
#' These functions help you quickly create interactive hierarchical plots
#' from categorical data. They expect the summary of the data created by
#' `dplyr::count()` and produce either a sunburst plot (`count_to_sunburst()`) or
#' a treemap plot (`count_to_treemap()`)
#'
#' @param count_data An output of dplyr::count(), tibble or data frame
#' @param fill_by_n If TRUE, uses a continuous scale to fill plot by group size
#' @param sort_by_n If TRUE, sorts groups in plot by size, if FALSE sorts them alphabetically
#' @param colorscale Character string specifying the Plotly colorscale to use when `fill_by_n = TRUE`.
#' Defaults to "Viridis". See `plotly::schema()` under `traces > sunburst > marker > colorscale` for options.
#' @param na_handling Character string specifying how to handle NA values in grouping columns.
#'   One of "as_string" (default, NAs converted to "NA"), "omit" (rows with NAs are removed),
#'   or "replace" (NAs are replaced with `na_replace_str`).
#' @param na_replace_str Character string to replace NA values with when `na_handling = "replace"`.
#'   Defaults to "NA_string_rep".
#' @param root_label Character string to use as the label for the root node. Defaults to `""` (no explicit root node).
#' @param ... Additional arguments passed to \code{plotly::plot_ly}.
#'
#' @export
#' @examples
#' library(dplyr)
#' library(plotly) # For layout argument
#'
#' # Basic count data
#' starwars_count <- count(starwars, species, eye_color, name)
#'
#' # Basic sunburst plot
#' count_to_sunburst(starwars_count)
#'
#' # Sunburst with fill by group size and custom colorscale
#' count_to_sunburst(starwars_count, fill_by_n = TRUE, colorscale = "Plasma")
#'
#' # Sunburst with a title using ... for layout options
#' count_to_sunburst(starwars_count, layout = list(title = "Star Wars Character Distribution"))
#'
#' # Sunburst with a custom root label
#' count_to_sunburst(starwars_count, root_label = "All Characters")
#'
#' # Basic treemap plot, ordered by group size
#' count_to_treemap(starwars_count, sort_by_n = TRUE)
#'
#' # Treemap for characters by homeworld
#' starwars %>%
#'   count(homeworld, name) %>%
#'   count_to_treemap(sort_by_n = TRUE)
#'
#' # NA handling examples
#' # Create a dataset with NAs
#' starwars_na_data <- starwars %>%
#'   mutate(
#'     homeworld = case_when(
#'       name %in% c("Luke Skywalker", "Anakin Skywalker") ~ NA_character_,
#'       TRUE ~ homeworld
#'     ),
#'     species = case_when(
#'       name == "R2-D2" ~ NA_character_,
#'       TRUE ~ species
#'     )
#'   )
#' starwars_na_count <- count(starwars_na_data, homeworld, species, name)
#'
#' # NA handling: "as_string" (default) - NAs appear as "NA"
#' count_to_treemap(starwars_na_count, na_handling = "as_string", fill_by_n = TRUE)
#'
#' # NA handling: "omit" - Rows with NAs are removed
#' count_to_treemap(starwars_na_count, na_handling = "omit", fill_by_n = TRUE)
#'
#' # NA handling: "replace" - NAs are replaced with a custom string
#' count_to_treemap(starwars_na_count, na_handling = "replace", na_replace_str = "Unknown Species/Homeworld", fill_by_n = TRUE)
#'
#' # Combined example: treemap with NA replacement, root label, and title
#' count_to_treemap(
#'   starwars_na_count,
#'   na_handling = "replace",
#'   na_replace_str = "MISSING",
#'   root_label = "Galaxy Far, Far Away",
#'   fill_by_n = TRUE,
#'   colorscale = "Cividis",
#'   layout = list(title = "Character Hierarchy (with NAs replaced)")
#' )
count_to_sunburst <- function(count_data, fill_by_n = FALSE, sort_by_n = FALSE, colorscale = "Viridis", na_handling = "as_string", na_replace_str = "NA_string_rep", root_label = "", ...){
  
  assertthat::assert_that(is.character(colorscale), length(colorscale) == 1, msg = "colorscale must be a string")
  user_args <- list(...)
  user_layout <- user_args$layout
  user_args$layout <- NULL # Remove layout from ... to avoid conflict

  params_df <- create_all_col_params(count_data, fill_by_n, sort_by_n, na_handling, na_replace_str, root_label)

  plot_args <- list(
    data = params_df,
    ids = ~ids,
    labels = ~labels,
    parents = ~parents,
    values = ~values,
    type = "sunburst",
    branchvalues = "total",
    hoverinfo = "text"
  )

  if (fill_by_n && !is.null(params_df) && nrow(params_df) > 0) {
    plot_args$marker <- list(colors = ~values, colorscale = colorscale, colorbar = list(bgcolor = "transparent"))
  }
  
  # Combine remaining user-supplied arguments from ...
  plot_data_args <- utils::modifyList(plot_args, user_args) # user_args no longer contains layout

  # Create the plot
  p <- purrr::exec(plotly::plot_ly, !!!plot_data_args)

  # Apply layout if provided
  if (!is.null(user_layout) && length(user_layout) > 0) {
    p <- rlang::exec(plotly::layout, p = p, !!!user_layout)
  }
  
  return(p)
}


#' @export
#' @rdname count_to_sunburst
count_to_treemap <- function(count_data, fill_by_n = FALSE, sort_by_n = FALSE, colorscale = "Viridis", na_handling = "as_string", na_replace_str = "NA_string_rep", root_label = "", ...){

  assertthat::assert_that(is.character(colorscale), length(colorscale) == 1, msg = "colorscale must be a string")
  user_args <- list(...)
  user_layout <- user_args$layout
  user_args$layout <- NULL # Remove layout from general '...'

  params_df <- create_all_col_params(count_data, fill_by_n, sort_by_n, na_handling, na_replace_str, root_label)

  plot_args <- list(
    data = params_df,
    ids = ~ids,
    labels = ~labels,
    parents = ~parents,
    values = ~values,
    type = "treemap",
    branchvalues = "total",
    hoverinfo = "text"
  )

  if (fill_by_n && !is.null(params_df) && nrow(params_df) > 0) {
    plot_args$marker <- list(colors = ~values, colorscale = colorscale, colorbar = list(bgcolor = "transparent"))
  }
  
  plot_data_args <- utils::modifyList(plot_args, user_args)

  p <- purrr::exec(plotly::plot_ly, !!!plot_data_args)

  if (!is.null(user_layout) && length(user_layout) > 0) {
    p <- rlang::exec(plotly::layout, p = p, !!!user_layout)
  }

  return(p)
}


create_all_col_params <- function(count_data, fill_by_n, sort_by_n, na_handling = "as_string", na_replace_str = "NA_string_rep", root_label = ""){

  assert_count_df(count_data)
  assertthat::assert_that(is.logical(fill_by_n),
                          length(fill_by_n) == 1,
                          msg = "fill_by_n must be either TRUE or FALSE")
  assertthat::assert_that(is.logical(sort_by_n),
                          length(sort_by_n) == 1,
                          msg = "sort_by_n must be either TRUE or FALSE")
  # colorscale assertion removed as it's no longer directly used here
  assertthat::assert_that(
    na_handling %in% c("as_string", "omit", "replace"),
    msg = "na_handling must be one of 'as_string', 'omit', or 'replace'"
  )
  assertthat::assert_that(
    is.character(na_replace_str) && length(na_replace_str) == 1,
    msg = "na_replace_str must be a single string"
  )
  assertthat::assert_that(
    is.character(root_label) && length(root_label) == 1,
    msg = "root_label must be a single string"
  )

  count_data <- all_non_n_cols_to_char(count_data, na_handling, na_replace_str)

  # Return NULL early if all data was NA and na_handling = "omit"
  if (nrow(count_data) == 0) {
    return(NULL)
  }
  
  category_num <- ncol(count_data) - 1

  params <- purrr::map(1:category_num,
                       create_one_col_params,
                       df = count_data,
                       root_label = root_label) %>%
    dplyr::bind_rows() %>%
    dplyr::mutate(sort = sort_by_n)

  # Marker logic removed from here, will be handled in the calling functions
  params
}

create_one_col_params <- function(df,
                                  col_num,
                                  root_label){
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
                       root_label)
    ) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(labels = .[[!!col_num]],
                  hovertext = stringr::str_glue(
                    "column: {col_name}\nvalue: {labels}\nn: {values}")
    ) %>%
    dplyr::select(ids, parents, labels, values, hovertext)
}





