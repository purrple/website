---
title:  sapply with variadic trailing arguments
author: "Romain François"
date:  2014-05-28
tags: ["Rcpp11"]
banner: "img/banners/cplusplus.png"
---


<h3 id="motivation">Motivation</h3>

In R, we can pass further arguments to <code>sapply</code>. The arguments are then passed the function to be applied over. 

<pre><code>x &lt;- seq(-3, 3, by=.2 )  
sapply( x, dnorm, 0, 4, FALSE )  
</code></pre>

Conceptually this does something like: 

<pre><code>sapply( x, function(.){  
    dnorm(.,0,4,FALSE)
} )
</code></pre>

<h3 id="implementationinrcpp11">Implementation in Rcpp11</h3>

<code>sapply</code> has been part of sugar for a long time, and is now very central <a href="http://blog.r-enthusiasts.com/2014/05/27/updating-sugar/">to the modernized</a> version of sugar in the devel version of <a href="https://github.com/Rcpp11/Rcpp11"><code>Rcpp11</code></a>, but until now we did not have a mechanism similar to R's ellipsis. 

<a href="http://www.cplusplus.com/articles/EhvU7k9E/">variadic templates</a> and <a href="http://www.cplusplus.com/reference/tuple/tuple/">std::tuple</a> give us the tools to <a href="https://github.com/Rcpp11/Rcpp11/commit/a13fc9240f3ab9967fb7a8dfc7d2ac03c99e6786">implement the feature</a> in Rcpp11. 

<pre><code class="cpp">#include &lt;Rcpp11&gt;
using namespace Rcpp11 ;

// [[Rcpp::export]]
NumericVector bazinga(NumericVector x){  
    NumericVector res = sapply( x, ::Rf_dnorm4, 0.0, 4.0, false ) ;
    return res ;
}

/*** R
    x &lt;- seq(-3, 3, by=.2 )
    bazinga(x)
*/
</code></pre>

<h3 id="details">Details</h3>

For the details, further arguments are tied together into a functor object <code>SapplyFunctionBinder</code> wrapping both the underlying function to be called <code>::Rf_dnorm4</code> and the data as <code>std::tuple&lt;double,double,bool&gt;</code>. 

<pre><code class="cpp">template &lt;int RTYPE, typename Function, typename... Args &gt;  
class SapplyFunctionBinder {  
public:  
    typedef typename Rcpp::traits::storage_type&lt;RTYPE&gt;::type storage_type ;
    typedef typename std::tuple&lt;Args...&gt; Tuple ;
    typedef typename Rcpp::traits::index_sequence&lt;Args...&gt;::type Sequence ;
    typedef typename std::result_of&lt;Function(storage_type,Args...)&gt;::type fun_result_type ;

    SapplyFunctionBinder( Function fun_, Args&amp;&amp;... args) :
        fun(fun_), tuple(std::forward&lt;Args&gt;(args)...){}

    inline fun_result_type operator()( storage_type x ) const {
        return apply( x, Sequence() ) ;        
    }

private:  
    Function fun ;
    Tuple tuple ;

    template &lt;int... S&gt;
    inline fun_result_type apply( storage_type x, Rcpp::traits::sequence&lt;S...&gt; ) const {
        return fun( x, std::get&lt;S&gt;(tuple)... );  
    }

} ;
</code></pre>

<h3 id="alternatives">Alternatives</h3>

Alternatively, this can be done with <a href="http://www.cprogramming.com/c++11/c++11-lambda-closures.html">lambda functions</a> : 

<pre><code>NumericVector res = sapply( x, [](double a){  
    return ::Rf_dnorm4(a, 0.0, 4.0, false ) ;
} ) ;
</code></pre>

We could also bind the function with <code>std::bind</code> : 

<pre><code>using namespace std::placeholders ;  
NumericVector res = sapply( x, std::bind(::Rf_dnorm4, _1, 0.0, 4.0, false) ) ;  
</code></pre>

<h3 id="comparisoncostoftheabstraction">Comparison. Cost of the abstraction</h3>

Let's compare these alternatives through <a href="http://cran.r-project.org/web/packages/microbenchmark/index.html">microbenchmark</a>. 

<pre><code class="cpp">#include &lt;Rcpp11&gt;
using namespace Rcpp11 ;

// [[Rcpp::export]]
NumericVector sapply_variadic(NumericVector x){  
    NumericVector res = sapply( x, ::Rf_dnorm4, 0.0, 4.0, false ) ;
    return res ;
}

// [[Rcpp::export]]
NumericVector sapply_lambda(NumericVector x){  
    NumericVector res = sapply( x, [](double a){
            return ::Rf_dnorm4(a, 0.0, 4.0, false ) ;
    } ) ;
    return res ;
}

// [[Rcpp::export]]
NumericVector sapply_bind(NumericVector x){  
    using namespace std::placeholders ;
    NumericVector res = sapply( x, std::bind(::Rf_dnorm4, _1, 0.0, 4.0, false) ) ;
    return res ;
}

// [[Rcpp::export]]
NumericVector sapply_loop(NumericVector x){  
    int n = x.size() ;
    NumericVector res(n);
    for( int i=0; i&lt;n; i++){
        res[i] = Rf_dnorm4( x[i], 0.0, 4.0, false ) ;    
    }
    return res ;
}
</code></pre>

Here are the results. 

<pre><code>$ Rcpp11Script /tmp/test.cpp

&gt; x &lt;- seq(-3, 3, length.out = 1e+06)

&gt; require(microbenchmark)
Loading required package: microbenchmark

&gt; microbenchmark(sapply_variadic(x), sapply_lambda(x),
+     sapply_bind(x), sapply_loop(x))
Unit: milliseconds  
               expr      min       lq   median       uq      max neval
 sapply_variadic(x) 20.01696 20.11962 21.36856 22.07377 31.22063   100
   sapply_lambda(x) 20.53550 20.63079 21.83883 22.55680 31.62075   100
     sapply_bind(x) 19.96870 20.56051 21.32460 22.26086 30.66203   100
     sapply_loop(x) 20.81417 20.92458 22.13156 22.84175 31.48991   100
</code></pre>

All 4 solutions give pretty identical performance. This is abstraction we did not have to pay for. In comparisons, a direct call to the vectorised R function <code>dnorm</code> 

<pre><code>R_direct &lt;- function(x){  
    dnorm(x, 0, 4, FALSE)
}
</code></pre>

yields: 

<pre><code>&gt; microbenchmark(sapply_variadic(x), sapply_lambda(x),
+     sapply_bind(x), sapply_loop(x), R_direct(x))
Unit: milliseconds  
               expr      min       lq   median       uq      max neval
 sapply_variadic(x) 20.05441 20.12312 21.35391 22.67544 31.34657   100
   sapply_lambda(x) 20.28648 20.39238 21.60423 22.31166 30.66797   100
     sapply_bind(x) 19.94212 20.02965 21.26132 21.92637 30.68198   100
     sapply_loop(x) 20.25010 20.31937 21.57333 22.89537 31.75865   100
        R_direct(x) 33.73723 33.89319 35.06729 36.05020 43.95266   100
</code></pre>

I also intended to test the versio using R's sapply. 

<pre><code>sapply_R &lt;- function(x){  
    sapply(x, dnorm, 0, 4, FALSE )
}
</code></pre>

But ... life's too short and I killed it. 

