# creates correct params

    Code
      create_all_col_params(example_df, fill_by_n = FALSE, sort_by_n = FALSE)
    Output
      # A tibble: 7 x 6
        ids    parents labels values hovertext                        sort 
        <chr>  <chr>   <chr>   <dbl> <glue>                           <lgl>
      1 a      ""      a          30 "column: col_1\nvalue: a\nn: 30" FALSE
      2 b      ""      b          30 "column: col_1\nvalue: b\nn: 30" FALSE
      3 c      ""      c          40 "column: col_1\nvalue: c\nn: 40" FALSE
      4 a.->.x "a"     x          10 "column: col_2\nvalue: x\nn: 10" FALSE
      5 a.->.y "a"     y          20 "column: col_2\nvalue: y\nn: 20" FALSE
      6 b.->.x "b"     x          30 "column: col_2\nvalue: x\nn: 30" FALSE
      7 c.->.y "c"     y          40 "column: col_2\nvalue: y\nn: 40" FALSE

---

    Code
      create_all_col_params(example_df, fill_by_n = TRUE, sort_by_n = FALSE)
    Output
      # A tibble: 7 x 7
        ids    parents labels values hovertext                    sort  marker        
        <chr>  <chr>   <chr>   <dbl> <glue>                       <lgl> <named list>  
      1 a      ""      a          30 "column: col_1\nvalue: a\nn~ FALSE <named list [~
      2 b      ""      b          30 "column: col_1\nvalue: b\nn~ FALSE <named list [~
      3 c      ""      c          40 "column: col_1\nvalue: c\nn~ FALSE <named list [~
      4 a.->.x "a"     x          10 "column: col_2\nvalue: x\nn~ FALSE <named list [~
      5 a.->.y "a"     y          20 "column: col_2\nvalue: y\nn~ FALSE <named list [~
      6 b.->.x "b"     x          30 "column: col_2\nvalue: x\nn~ FALSE <named list [~
      7 c.->.y "c"     y          40 "column: col_2\nvalue: y\nn~ FALSE <named list [~

---

    Code
      create_all_col_params(example_df, fill_by_n = FALSE, sort_by_n = TRUE)
    Output
      # A tibble: 7 x 6
        ids    parents labels values hovertext                        sort 
        <chr>  <chr>   <chr>   <dbl> <glue>                           <lgl>
      1 a      ""      a          30 "column: col_1\nvalue: a\nn: 30" TRUE 
      2 b      ""      b          30 "column: col_1\nvalue: b\nn: 30" TRUE 
      3 c      ""      c          40 "column: col_1\nvalue: c\nn: 40" TRUE 
      4 a.->.x "a"     x          10 "column: col_2\nvalue: x\nn: 10" TRUE 
      5 a.->.y "a"     y          20 "column: col_2\nvalue: y\nn: 20" TRUE 
      6 b.->.x "b"     x          30 "column: col_2\nvalue: x\nn: 30" TRUE 
      7 c.->.y "c"     y          40 "column: col_2\nvalue: y\nn: 40" TRUE 

# dfs with col name col_num works

    Code
      create_all_col_params(example_df, fill_by_n = FALSE, sort_by_n = FALSE)
    Output
      # A tibble: 7 x 6
        ids    parents labels values hovertext                    sort 
        <chr>  <chr>   <chr>   <dbl> <glue>                       <lgl>
      1 a      ""      a          30 "column: a\nvalue: a\nn: 30" FALSE
      2 b      ""      b          30 "column: b\nvalue: b\nn: 30" FALSE
      3 c      ""      c          40 "column: c\nvalue: c\nn: 40" FALSE
      4 a.->.x "a"     x          10 "column: a\nvalue: x\nn: 10" FALSE
      5 a.->.y "a"     y          20 "column: a\nvalue: y\nn: 20" FALSE
      6 b.->.x "b"     x          30 "column: b\nvalue: x\nn: 30" FALSE
      7 c.->.y "c"     y          40 "column: c\nvalue: y\nn: 40" FALSE

