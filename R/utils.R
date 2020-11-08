assert_count_df <- function(var){
  msg <- paste(substitute(var), "must be a count dataframe (output of dplyr::count)")
  assertthat::assert_that(is.data.frame(var),
                          assertthat::has_name(var, "n"),
                          msg = msg)

  n_col <- var$n
  assertthat::assert_that(is.numeric(n_col), msg = msg)
}

all_non_n_cols_to_char <- function(df){
  df %>%
    mutate(across(!matches("n"), as.character))
}
