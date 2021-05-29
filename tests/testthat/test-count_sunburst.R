example_df <- dplyr::tibble(
  col_1 = c("a", "a", "b", "c"),
  col_2 = c("x", "y", "x", "y"),
  n = c(10, 20, 30, 40)
)

test_that("gets erros where needed",{
  expect_error(count_to_sunburst(count_df = 1),
               "count")
  expect_error(count_to_sunburst(count_df = iris),
               "count")
  expect_error(count_to_sunburst(example_df, fill_by_n = "TRUE"))
  expect_error(count_to_sunburst(example_df, fill_by_n = c(TRUE, FALSE)))
  expect_error(count_to_sunburst(example_df, sort_by_n = "FALSE"))
  expect_error(count_to_sunburst(example_df, sort_by_n =  c(TRUE, FALSE)))
})

test_that("creates correct params", {
  expect_snapshot(create_all_col_params(example_df, fill_by_n = FALSE, sort_by_n = FALSE))
  expect_snapshot(create_all_col_params(example_df, fill_by_n = TRUE, sort_by_n = FALSE))
  expect_snapshot(create_all_col_params(example_df, fill_by_n = FALSE, sort_by_n = TRUE))
})

test_that("dfs with col name col_num works", {
  example_df <- dplyr::rename(example_df, col_name = col_1)
  expect_snapshot(create_all_col_params(example_df, fill_by_n = FALSE, sort_by_n = FALSE))
})

test_that("functions work",{
  expect_true("plotly" %in% class(count_to_sunburst(example_df)))
  expect_true("plotly" %in% class(count_to_treemap(example_df)))
})

