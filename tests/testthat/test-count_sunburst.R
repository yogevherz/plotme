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
})

test_that("creates correct params", {
  expect_snapshot(create_all_col_params(example_df))
})

test_that("dfs with col name col_num work", {
  example_df <- dplyr::rename(example_df, col_name = col_1)
  expect_snapshot(create_all_col_params(example_df))
})


