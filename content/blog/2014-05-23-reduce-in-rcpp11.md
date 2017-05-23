---
title:  reduce in Rcpp11
author: "Romain François"
date:  2014-05-23
tags: ["Rcpp", "Rcpp11"]
banner: "img/banners/cplusplus.png"
---

And <a href="https://github.com/Rcpp11/Rcpp11/commit/047e961f1e205b51a8e4f1766f8da3eb6ae07de8">now</a> for something completely different, the <code>reduce</code> function, doing something similar to what the <code>Reduce</code> function does in R: 

```
#include <Rcpp.h>
using namespace Rcpp ;

// [[Rcpp::export]]
double reduce_example(NumericVector x ){  
    auto add   = [](double a, double b){ return a + b ;} ;
    return reduce(x, add ) ;
}


/*** R
  x <- 1:10
  reduce_example(x)
*/
```

Giving: 

```
$ Rcpp11Script /tmp/reduce.cpp

> x <- 1:10

> reduce_example(x)
[1] 55
```

