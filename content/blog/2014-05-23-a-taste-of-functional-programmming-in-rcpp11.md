---
title:  A taste of functional programmming in Rcpp11
author: "Romain François"
date:  2014-05-23
tags: ["Rcpp11"]
banner: "img/banners/cplusplus.png"
---

<p><a href="https://github.com/kevinushey">@kevinushey</a> requested some <a href="https://github.com/Rcpp11/Rcpp11/issues/140#issuecomment-43956758">functional programming</a> in <a href="https://github.com/Rcpp11/Rcpp11">Rcpp11</a> and provided initial versions of `map` and `filter`. `map` is actually doing exactly the same thing as `mapply` so I added `map` as a synonym to `mapply` so that we can do (see <a href="http://blog.r-enthusiasts.com/2014/05/22/using-mapply-in-rcpp11/">this previous post</a> for details): </p>

```
// [[Rcpp::export]]
NumericVector mapply_example(NumericVector x, NumericVector y, double z){

    auto fun = [](double a, double b, double c){ return a + b + c ;} ;
    return map( fun, x, y, z ) ;

}
```

<p>`filter` takes a sugar expression (e.g. a vector) and a function predicte and only keeps the elements of the vector for which the predicate evaluates to `true`. Here is a simple example: </p>

```
// [[Rcpp::export]]
NumericVector filter_example(NumericVector x ){  
    auto positives   = [](double a){ return a >= 0 ;} ;
    return filter(x, positives ) ;
}
```

<p>I've also put in the `negate` function. Intuitively enough, it takes a function (e.g. a lambda) and returns a function that negates it. For example, we can expand the previous example using both the `positives` lambda and a negated version of it: </p>

```
// [[Rcpp::export]]
List filter_example_2(NumericVector x ){  
    auto positives   = [](double a){ return a >= 0 ;} ;
    return list( 
        _["+"] = filter(x, positives ), 
        _["-"] = filter(x, negate(positives) ) 
    ) ;
}
```

<p>We can also compose two functions: </p>

```
// [[Rcpp::export]]
NumericVector filter_example_3(NumericVector x ){  
    auto small  = [](double a){ return a < 4 ;} ;
    auto square = [](double a){ return a * a ;} ;

    return filter(x, compose(square, small) ) ;
}
```

<p>But since I've been spoiled by <a href="https://github.com/smbache/magrittr">`magrittr`</a> and <a href="https://github.com/hadley/dplyr">`dplyr`</a>, I've put in this alternative way to compose the two functions: </p>

```
// [[Rcpp::export]]
NumericVector filter_example_4(NumericVector x ){  
    auto small  = [](double a){ return a < 4 ;} ;
    auto square = [](double a){ return a * a ;} ;

    return filter(x, _[square] >> small ) ;
}
```

<p>`_` turns `square` into a `Rcpp::functional::Functoid` which implements `operator>>`. `Functoid` can also be negated by the `operator!` : </p>

```
// [[Rcpp::export]]
NumericVector filter_example_5(NumericVector x ){  
    auto small  = [](double a){ return a < 4 ;} ;
    auto square = [](double a){ return a * a ;} ;
    auto fun    = _[square] >> small  ;

    return filter(x, !fun ) ;
}
```

<p>I'm not sure this is going to be of any use or even if this will stay, but that was fun. </p>

```
$ Rcpp11Script /tmp/filter.cpp

> x <- seq(-10, 10, by = 0.5)

> filter_example_1(x)
 [1]  0.0  0.5  1.0  1.5  2.0  2.5  3.0  3.5  4.0  4.5  5.0  5.5  6.0  6.5  7.0
[16]  7.5  8.0  8.5  9.0  9.5 10.0

> filter_example_2(x)
$`+`
 [1]  0.0  0.5  1.0  1.5  2.0  2.5  3.0  3.5  4.0  4.5  5.0  5.5  6.0  6.5  7.0
[16]  7.5  8.0  8.5  9.0  9.5 10.0

$`-`
 [1] -10.0  -9.5  -9.0  -8.5  -8.0  -7.5  -7.0  -6.5  -6.0  -5.5  -5.0  -4.5
[13]  -4.0  -3.5  -3.0  -2.5  -2.0  -1.5  -1.0  -0.5


> filter_example_3(x)
 [1] -10.0  -9.5  -9.0  -8.5  -8.0  -7.5  -7.0  -6.5  -6.0  -5.5  -5.0  -4.5
[13]  -4.0  -3.5  -3.0  -2.5  -2.0   2.0   2.5   3.0   3.5   4.0   4.5   5.0
[25]   5.5   6.0   6.5   7.0   7.5   8.0   8.5   9.0   9.5  10.0

> filter_example_4(x)
[1] -1.5 -1.0 -0.5  0.0  0.5  1.0  1.5

> filter_example_5(x)
 [1] -10.0  -9.5  -9.0  -8.5  -8.0  -7.5  -7.0  -6.5  -6.0  -5.5  -5.0  -4.5
[13]  -4.0  -3.5  -3.0  -2.5  -2.0   2.0   2.5   3.0   3.5   4.0   4.5   5.0
[25]   5.5   6.0   6.5   7.0   7.5   8.0   8.5   9.0   9.5  10.0
```

