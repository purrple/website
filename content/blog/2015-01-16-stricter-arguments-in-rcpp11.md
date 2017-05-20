---
title:  stricter arguments in Rcpp11 and Rcpp14
author: "Romain François"
date:  2015-01-16
tags: ["Rcpp11", "Rcpp14", "C++"]
banner: "img/banners/cplusplus.png"
---

The way some classes (e.g. `NumericVector` have been implemented in various
`R/C++` versions gives us automatic coercion.

For example passing an integer vector to a C++ function that has a
`NumericVector` as an argument will coerce the `integer` vector into a `numeric`
 vector automatically.

```cpp
// [[export]]
double foo( NumericVector x){  
   return sum(x) ;
}
```

will give us:

```
x <- c(1,2)  
foo(x)  
# 3

x <- c(1L, 2L)  
foo(x)  
# 3
```

Sometimes, we would like to restrict `x` to just be a `numeric` vector.
For this we would typically have to use `SEXP` as the argument class
and then test conformity manually, something like this:

```cpp
// [[export]]
double foo( SEXP x_ ){  
   if( !is<NumericVector>( x_ ) ) stop( "not a numeric vector" ) ;
   NumericVector x(x_) ;
   return sum(x) ;
}
```

Which is boring boiler plate code, so I've added the <code>Strict</code>
class into [Rcpp11](https://github.com/Rcpp11/Rcpp11) and
[Rcpp11](https://github.com/Rcpp11/Rcpp14).
The class is pretty simple, it has two things:

- a constructor taking a <code>SEXP</code>, which makes it a perfect candidate
  for an attributes generated function. The constructor stores the <code>SEXP</code>
  and checks if it is compatible using the appropriate <code>is&lt;&gt;</code> function, if not it throws an exception.
- a <code>get</code> member function that returns a new object of the target class.

With this, we can write `foo` :

```
// [[export]]
double foo( Strict<NumericVector> x){  
   return sum(x.get()) ;
}
```
