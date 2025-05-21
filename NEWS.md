# plotme 0.2.0

## New Features

*   Added `colorscale` parameter to `count_to_sunburst()` and `count_to_treemap()` for custom color gradients when `fill_by_n = TRUE`.
*   Enabled passing of additional arguments (`...`) to `plotly::plot_ly()` from `count_to_sunburst()` and `count_to_treemap()` for advanced plot customization (e.g., titles, layout adjustments).
*   Introduced `na_handling` and `na_replace_str` parameters to control the processing of `NA` values in categorical grouping columns. Options include converting NAs to strings ("as_string"), omitting them ("omit"), or replacing them with a custom string ("replace").
*   Added `root_label` parameter to allow customization of the root node's label in sunburst and treemap plots.

## Improvements

*   Improved robustness of NA handling in internal utility functions, particularly ensuring correct conversion of `NA` values to `"NA"` strings when `na_handling = "as_string"`.
*   Enhanced unit test coverage for new features (`colorscale`, `...`, `na_handling`, `root_label`) and existing functionalities, including more detailed checks for NA processing in utility functions.
*   Refined argument passing for `layout` options to `plotly::plot_ly` for more reliable behavior.

# plotme 0.1.0

-   Added a `NEWS.md` file to track changes to the package.
-   Created package with `count_to_sunburst()` and `count_to_treemap()` functions.
