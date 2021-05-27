# creates correct params

    Code
      create_all_col_params(example_df)
    Output
      # A tibble: 7 x 5
        ids    parents labels values hovertext                       
        <chr>  <chr>   <chr>   <dbl> <glue>                          
      1 a      ""      a          30 "column: col_1\nvalue: a\nn: 30"
      2 b      ""      b          30 "column: col_1\nvalue: b\nn: 30"
      3 c      ""      c          40 "column: col_1\nvalue: c\nn: 40"
      4 a.->.x "a"     x          10 "column: col_2\nvalue: x\nn: 10"
      5 a.->.y "a"     y          20 "column: col_2\nvalue: y\nn: 20"
      6 b.->.x "b"     x          30 "column: col_2\nvalue: x\nn: 30"
      7 c.->.y "c"     y          40 "column: col_2\nvalue: y\nn: 40"

# dfs with col name col_num work

    Code
      create_all_col_params(example_df)
    Output
      # A tibble: 7 x 5
        ids    parents labels values hovertext                          
        <chr>  <chr>   <chr>   <dbl> <glue>                             
      1 a      ""      a          30 "column: col_name\nvalue: a\nn: 30"
      2 b      ""      b          30 "column: col_name\nvalue: b\nn: 30"
      3 c      ""      c          40 "column: col_name\nvalue: c\nn: 40"
      4 a.->.x "a"     x          10 "column: col_2\nvalue: x\nn: 10"   
      5 a.->.y "a"     y          20 "column: col_2\nvalue: y\nn: 20"   
      6 b.->.x "b"     x          30 "column: col_2\nvalue: x\nn: 30"   
      7 c.->.y "c"     y          40 "column: col_2\nvalue: y\nn: 40"   

