# creates correct params

    Code
      create_all_col_params(example_df, root = NULL)
    Output
      # A tibble: 7 x 5
        ids    parents labels values hovertext
        <chr>  <chr>   <chr>   <dbl> <chr>    
      1 a      ""      a          30 col_1    
      2 b      ""      b          30 col_1    
      3 c      ""      c          40 col_1    
      4 a.->.x "a"     x          10 col_2    
      5 a.->.y "a"     y          20 col_2    
      6 b.->.x "b"     x          30 col_2    
      7 c.->.y "c"     y          40 col_2    

---

    Code
      create_all_col_params(example_df, root = "grand_col")
    Output
      # A tibble: 7 x 5
        ids    parents   labels values hovertext
        <chr>  <chr>     <chr>   <dbl> <chr>    
      1 a      grand_col a          30 col_1    
      2 b      grand_col b          30 col_1    
      3 c      grand_col c          40 col_1    
      4 a.->.x a         x          10 col_2    
      5 a.->.y a         y          20 col_2    
      6 b.->.x b         x          30 col_2    
      7 c.->.y c         y          40 col_2    

# dfs with col name col_num work

    Code
      create_all_col_params(example_df, root = NULL)
    Output
      # A tibble: 7 x 5
        ids    parents labels values hovertext
        <chr>  <chr>   <chr>   <dbl> <chr>    
      1 a      ""      a          30 col_name 
      2 b      ""      b          30 col_name 
      3 c      ""      c          40 col_name 
      4 a.->.x "a"     x          10 col_2    
      5 a.->.y "a"     y          20 col_2    
      6 b.->.x "b"     x          30 col_2    
      7 c.->.y "c"     y          40 col_2    

