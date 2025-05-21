assert_count_df <- function(var){
  msg <- paste(substitute(var), "must be a count dataframe (output of dplyr::count)")
  assertthat::assert_that(is.data.frame(var),
                          assertthat::has_name(var, "n"),
                          msg = msg)

  n_col <- var$n
  assertthat::assert_that(is.numeric(n_col), msg = msg)
}

all_non_n_cols_to_char <- function(df, na_handling = "as_string", na_replace_str = "NA_string_rep"){
  assertthat::assert_that(
    na_handling %in% c("as_string", "omit", "replace"),
    msg = "na_handling must be one of 'as_string', 'omit', or 'replace'"
  )
  assertthat::assert_that(
    is.character(na_replace_str) && length(na_replace_str) == 1,
    msg = "na_replace_str must be a single string"
  )

  if (na_handling == "omit") {
    # Identify non-n columns
    grouping_cols <- setdiff(names(df), "n")
    # Filter out rows where any grouping column is NA
    df <- df %>%
      tidyr::drop_na(dplyr::any_of(grouping_cols))
  }

  # Identify columns to process (all except 'n')
  cols_to_process <- setdiff(names(df), "n")

  if (na_handling == "as_string") {
    df <- df %>%
      dplyr::mutate(dplyr::across(dplyr::all_of(cols_to_process), ~tidyr::replace_na(as.character(.), "NA")))
  } else if (na_handling == "replace") {
    df <- df %>%
      dplyr::mutate(dplyr::across(dplyr::all_of(cols_to_process), ~tidyr::replace_na(as.character(.), na_replace_str)))
  } else if (na_handling == "omit") {
    # Already handled by drop_na. Ensure remaining columns are character.
     if (nrow(df) > 0 && length(cols_to_process) > 0) {
        df <- df %>%
            dplyr::mutate(dplyr::across(dplyr::all_of(cols_to_process), as.character))
    } else if (nrow(df) == 0) {
        # if all rows dropped, ensure structure is preserved by making existing cols (if any) character
        for(col_name in cols_to_process) {
            if(col_name %in% names(df)) { # Should always be true if cols_to_process derived from df
                 df[[col_name]] <- as.character(df[[col_name]])
            }
        }
    }
  }
  
  df
}
