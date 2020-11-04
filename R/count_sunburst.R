# Takes count_df, barnchvalues (default = "total"), any additional arguments
# Returns sunburst plotly
# TODO find a way to incorporate colors? Maybe only in path function
# TODO figure out what to do with NAs, try and paint them differently
# TODO Add assertions
# TODO make different col types work (probably convert all to char)
# TODO Add option to sendd arguments to plotly func
# TODO Add prefixes
# TODO Add unit tests

#' Create a sunburst plot from count data
#'
#' @param count_df
#'
#' @return
#' @export
#'
#' @examples
count_to_sunburst <- function(count_df){
  category_num <- ncol(count_df) - 1

  params <- map(1:category_num,
                create_col_params,
                df = count_df) %>%
    bind_rows()

  exec(plot_ly,
       !!!params,
       type = 'sunburst',
       branchvalues = 'total')
}

create_col_params <- function(df,
                              col_num){
  df %>%
    group_by(across(1:col_num)) %>%
    summarise(values = sum(n), .groups = "drop") %>%
    rowwise() %>%
    mutate(ids = paste(c_across(1:col_num), collapse = ".->."),
           parents = ifelse(col_num > 1,
                            paste(c_across(1 :(col_num - 1)), collapse = ".->."),
                            "")) %>%
    ungroup() %>%
    mutate(labels = .[[col_num]],
           hovertext = names(.)[col_num]) %>%
    select(ids, parents, labels, values, hovertext)
}





