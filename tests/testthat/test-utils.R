library(testthat)
library(dplyr)
library(plotme) # To access all_non_n_cols_to_char (assuming it's exported or accessible)

context("Utility functions - all_non_n_cols_to_char")

# Sample data for testing
sample_df_na <- tibble::tibble(
  group1 = c("A", "B", NA, "A"),
  group2 = c("X", NA, "Y", "X"),
  n = c(10, 5, 8, 12),
  another_col = c(1, NA, 3, 4) # Non-grouping, non-n, should also be affected by as.character
)

test_that("all_non_n_cols_to_char: na_handling = 'as_string'", {
  processed_df <- plotme:::all_non_n_cols_to_char(sample_df_na, na_handling = "as_string")
  
  # Check types - all non-n columns should be character
  expect_type(processed_df$group1, "character")
  expect_type(processed_df$group2, "character")
  expect_type(processed_df$another_col, "character")
  expect_type(processed_df$n, "double") # n should remain numeric

  # Check NA conversion to "NA" string
  expect_equal(processed_df$group1[3], "NA")
  expect_equal(processed_df$group2[2], "NA")
  expect_equal(processed_df$another_col[2], "NA")
  
  # Check non-NA values remain
  expect_equal(processed_df$group1[1], "A")
  expect_equal(processed_df$n, c(10, 5, 8, 12))
})

test_that("all_non_n_cols_to_char: na_handling = 'omit'", {
  # Case 1: NA in a grouping column used by the functions (group1, group2)
  processed_df_omit_grouping <- plotme:::all_non_n_cols_to_char(sample_df_na, na_handling = "omit")
  # Rows 2 and 3 have NAs in group1 or group2
  expect_equal(nrow(processed_df_omit_grouping), 2) 
  expect_false(any(is.na(processed_df_omit_grouping$group1)))
  expect_false(any(is.na(processed_df_omit_grouping$group2)))
  expect_false(any(processed_df_omit_grouping$group1 == "NA"))
  expect_false(any(processed_df_omit_grouping$group2 == "NA"))
  # Ensure the correct rows were kept (rows 1 and 4 of original)
  expect_equal(processed_df_omit_grouping$n, c(10, 12))

  # Case 2: NA only in 'another_col' (non-grouping for plotme main functions)
  # all_non_n_cols_to_char itself doesn't know which are grouping beyond !matches("^n$")
  # So, if NA is in 'another_col' it will also be omitted if that col is considered.
  # The current implementation of all_non_n_cols_to_char with "omit" uses tidyr::drop_na on *all* non-n columns.
  # This means row 2 (NA in group2 and another_col) and row 3 (NA in group1) will be dropped.
   df_na_in_non_grouping <- tibble::tibble(
    group1 = c("A", "B", "C"),
    n = c(1,2,3),
    non_group_col_with_na = c("X", NA, "Y")
  )
  processed_df_omit_non_grouping <- plotme:::all_non_n_cols_to_char(df_na_in_non_grouping, na_handling = "omit")
  expect_equal(nrow(processed_df_omit_non_grouping), 2) # Row with NA in non_group_col_with_na is dropped
  expect_equal(processed_df_omit_non_grouping$non_group_col_with_na, c("X", "Y"))
})

test_that("all_non_n_cols_to_char: na_handling = 'replace'", {
  replace_str <- "MISSING"
  processed_df_replace <- plotme:::all_non_n_cols_to_char(sample_df_na, na_handling = "replace", na_replace_str = replace_str)
  
  # Check types
  expect_type(processed_df_replace$group1, "character")
  expect_type(processed_df_replace$group2, "character")
  expect_type(processed_df_replace$another_col, "character")

  # Check NA replacement
  expect_equal(processed_df_replace$group1[3], replace_str)
  expect_equal(processed_df_replace$group2[2], replace_str)
  expect_equal(processed_df_replace$another_col[2], replace_str)
  
  # Check non-NA values remain
  expect_equal(processed_df_replace$group1[1], "A")
  expect_equal(processed_df_replace$n, c(10, 5, 8, 12))
  
  # Test if an existing "NA" string would also be replaced
  # Current behavior: replace_na only replaces actual NAs, not strings "NA". This is usually desired.
  df_with_NA_string <- tibble::tibble(group1 = c("A", "NA"), n = c(1,2))
  processed_df_NA_string <- plotme:::all_non_n_cols_to_char(df_with_NA_string, na_handling = "replace", na_replace_str = replace_str)
  expect_equal(processed_df_NA_string$group1[2], "NA") # Existing "NA" string should NOT be replaced with replace_str
})

test_that("all_non_n_cols_to_char: errors for invalid inputs", {
  expect_error(plotme:::all_non_n_cols_to_char(sample_df_na, na_handling = "wrong_option"),
               "na_handling must be one of 'as_string', 'omit', or 'replace'")
  expect_error(plotme:::all_non_n_cols_to_char(sample_df_na, na_replace_str = c("X", "Y")),
               "na_replace_str must be a single string")
})
