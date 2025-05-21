# creates correct params

    Code
      create_all_col_params(example_df, fill_by_n = FALSE, sort_by_n = FALSE)
    Output
      # A tibble: 7 x 6
        ids    parents labels values hovertext                  sort 
        <chr>  <chr>   <chr>   <dbl> <glue>                     <lgl>
      1 a      ""      a          30 column: col_1
      value: a
      n: 30 FALSE
      2 b      ""      b          30 column: col_1
      value: b
      n: 30 FALSE
      3 c      ""      c          40 column: col_1
      value: c
      n: 40 FALSE
      4 a.->.x "a"     x          10 column: col_2
      value: x
      n: 10 FALSE
      5 a.->.y "a"     y          20 column: col_2
      value: y
      n: 20 FALSE
      6 b.->.x "b"     x          30 column: col_2
      value: x
      n: 30 FALSE
      7 c.->.y "c"     y          40 column: col_2
      value: y
      n: 40 FALSE

---

    Code
      create_all_col_params(example_df, fill_by_n = TRUE, sort_by_n = FALSE)
    Output
      # A tibble: 7 x 6
        ids    parents labels values hovertext                  sort 
        <chr>  <chr>   <chr>   <dbl> <glue>                     <lgl>
      1 a      ""      a          30 column: col_1
      value: a
      n: 30 FALSE
      2 b      ""      b          30 column: col_1
      value: b
      n: 30 FALSE
      3 c      ""      c          40 column: col_1
      value: c
      n: 40 FALSE
      4 a.->.x "a"     x          10 column: col_2
      value: x
      n: 10 FALSE
      5 a.->.y "a"     y          20 column: col_2
      value: y
      n: 20 FALSE
      6 b.->.x "b"     x          30 column: col_2
      value: x
      n: 30 FALSE
      7 c.->.y "c"     y          40 column: col_2
      value: y
      n: 40 FALSE

---

    Code
      create_all_col_params(example_df, fill_by_n = FALSE, sort_by_n = TRUE)
    Output
      # A tibble: 7 x 6
        ids    parents labels values hovertext                  sort 
        <chr>  <chr>   <chr>   <dbl> <glue>                     <lgl>
      1 a      ""      a          30 column: col_1
      value: a
      n: 30 TRUE 
      2 b      ""      b          30 column: col_1
      value: b
      n: 30 TRUE 
      3 c      ""      c          40 column: col_1
      value: c
      n: 40 TRUE 
      4 a.->.x "a"     x          10 column: col_2
      value: x
      n: 10 TRUE 
      5 a.->.y "a"     y          20 column: col_2
      value: y
      n: 20 TRUE 
      6 b.->.x "b"     x          30 column: col_2
      value: x
      n: 30 TRUE 
      7 c.->.y "c"     y          40 column: col_2
      value: y
      n: 40 TRUE 

# dfs with col name col_num works

    Code
      create_all_col_params(example_df, fill_by_n = FALSE, sort_by_n = FALSE)
    Output
      # A tibble: 7 x 6
        ids    parents labels values hovertext              sort 
        <chr>  <chr>   <chr>   <dbl> <glue>                 <lgl>
      1 a      ""      a          30 column: a
      value: a
      n: 30 FALSE
      2 b      ""      b          30 column: b
      value: b
      n: 30 FALSE
      3 c      ""      c          40 column: c
      value: c
      n: 40 FALSE
      4 a.->.x "a"     x          10 column: a
      value: x
      n: 10 FALSE
      5 a.->.y "a"     y          20 column: a
      value: y
      n: 20 FALSE
      6 b.->.x "b"     x          30 column: b
      value: x
      n: 30 FALSE
      7 c.->.y "c"     y          40 column: c
      value: y
      n: 40 FALSE

