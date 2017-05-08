---
title:  Modernizing sugar in Rcpp11
author: "Romain François"
date:  2014-05-27
tags: []
---

<div class="post-content">
<p><img src="/web/20140531145511im_/http://blog.r-enthusiasts.com:80/content/images/2014/May/sugar.jpg" alt=""></p>

<p>I'm in the process of <a href="https://web.archive.org/web/20140531145511/https://github.com/Rcpp11/Rcpp11/issues/183">modernizing the implementation</a> of sugar in <a href="https://web.archive.org/web/20140531145511/https://github.com/Rcpp11/Rcpp11">Rcpp11</a>. Previous work already improved performance of sugar by allowing sugar classes themselves to implement how to apply themselves into their target vector. For example the sugar class <a href="https://web.archive.org/web/20140531145511/https://github.com/Rcpp11/Rcpp11/blob/master/inst/include/Rcpp/sugar/functions/seq_along.h#L7"><code>SeqLen</code></a> leverages <a href="https://web.archive.org/web/20140531145511/http://www.cplusplus.com/reference/numeric/iota/"><code>std::iota</code></a> instead of a manual for loop. </p>

<pre><code class="cpp">template &lt;typename Target&gt;  
inline void apply( Target&amp; target ) const {  
    std::iota( target.begin(), target.end(), 1 ) ;     
}
</code></pre>

<p>sugar is based on the expression templates technique, a very popular pattern in C++ libraries that reduces the use of temporaries. Consider the following R code: </p>

<pre><code class="R">y &lt;- exp(abs(x))  
</code></pre>

<p>To calculate <code>y</code> in R, we must first create a temporary vector to hold the result of <code>abs(x)</code> and then create a new vector to hold the result of <code>exp(abs(x))</code>. Then the vector we allocated to hold <code>abs(x)</code> is no longer referenced so becomes candidate for garbage collection, etc ... we just allocated something to throw it away right after. </p>

<p>If we were to implement this manually in C++, we would typically write a for loop. </p>

<pre><code class="cpp">int n = x.size() ;  
NumericVector y(n) ;  
for( int i=0; i&lt;n; i++){  
    y[i] = exp( abs( x[i] ) ) ;
}
</code></pre>

<p>There are other ways to do it as well. For example using <code>std::transform</code> </p>

<pre><code>NumericVector y(n) ;  
std::transform( x.begin(), x.end(), y.begin(), [](double a){  
    return exp(abs(a)) ;
}) ;
</code></pre>

<p>or using <code>Rcpp::transform</code> : </p>

<pre><code class="cpp">NumericVector y = transform( x.begin(), x.end(), []( double a){  
    return exp(abs(a));
}) ;
</code></pre>

<p>But sugar definitely gives us the most expressive and closest to R solution: </p>

<pre><code class="cpp">NumericVector y = exp(abs(x)) ;  
</code></pre>

<p>Here <code>exp</code> and <code>abs</code> operate on the entire vector, not just the scalar <code>double</code>. As with other expression templates libraries, sugar delays the actual work as much as possible. The expression <code>exp(abs(x))</code> itself does not create a vector but creates an object that can be assigned to a <code>NumericVector</code> : </p>

<pre><code class="cpp">auto y = exp(abs(x)) ;  
Rprintf( "type(y) = %s", DEMANGLE(y) ) ;  
// type(y) = Rcpp::sugar::Sapply&lt;14, true, Rcpp::sugar::Sapply&lt;14, true, Rcpp::Vector&lt;14, Rcpp::PreserveStorage&gt;, double (*)(double)&gt;, double (*)(double)&gt;
</code></pre>

<p>The expression <code>exp(abs(x))</code> has created the same object as the expression <code>sapply(sapply(x,::abs),::exp)</code>. The first benefit from this is that the code for <code>abs</code> and for <code>exp</code> is exactly the same. After all, we just vectorize a function that operate on scalar values. </p>

<p>The second benefit is that we can identify that we want function composition here. We don't want to first <code>sapply</code> <code>abs</code> over <code>x</code> and then <code>sapply</code> <code>exp</code> over the previous result, what we really want is <code>sapply</code> the composition of the <code>abs</code> and <code>exp</code> scalar functions. That's exactly how it is implemented in <code>Rcpp11</code>. We can even retrieve that function: </p>

<pre><code class="cpp">auto fun = y.fun ;  
Rprintf( "type(fun) = %s\n", DEMANGLE(decltype(fun)) ) ;  
// type(fun) = Rcpp::functional::Compose&lt;int (*)(int), double (*)(double)&gt;
</code></pre>

<p>And the <code>Compose</code> class looks like this: </p>

<pre><code class="cpp">template &lt;typename F1, typename F2&gt;  
class Compose : public Functoid&lt;Compose&lt;F1,F2&gt;&gt; {  
private:  
    F1 f1 ;
    F2 f2 ;

public:  
    Compose( F1 f1_, F2 f2_ ) : f1(f1_), f2(f2_){}

    template &lt;typename... Args&gt;
    inline auto operator()( Args&amp;&amp;... args ) const -&gt; decltype( f2( f1( std::forward&lt;Args&gt;(args)... ) ) ) {
        return f2( f1( std::forward&lt;Args&gt;(args)... ) );
    }

} ;
</code></pre>

<p>And we can just as easily compose lambda functions: </p>

<pre><code>#include &lt;Rcpp.h&gt;
using namespace Rcpp ;

// [[export]]
NumericVector test(NumericVector x){  
  auto square = []( double a ){ return a*a ; } ;
  auto twice  = []( double a ){ return a*2 ; } ; 

  auto y = sapply( sapply(x, square), twice ) ;
  Rprintf( "type(y) = %s\n", DEMANGLE(decltype(y)) ) ;

  auto fun = y.fun ;
  Rprintf( "type(fun) = %s\n", DEMANGLE(decltype(fun)) ) ;

  double val = fun(3.0);
  Rprintf( "val = %5.3f\n", val ) ;

  NumericVector res = y ;
  return res ;
}

/*** R
    test(1:10)
*/
</code></pre>

<p>which gives:</p>

<pre><code>$ Rcpp11Script /tmp/exp.cpp

&gt; test(1:10)
type(y) = Rcpp::sugar::Sapply&lt;14, true, Rcpp::sugar::Sapply&lt;14, true, Rcpp::Vector&lt;14, Rcpp::PreserveStorage&gt;, test(Rcpp::Vector&lt;14, Rcpp::PreserveStorage&gt;)::$_0&gt;, test(Rcpp::Vector&lt;14, Rcpp::PreserveStorage&gt;)::$_1&gt;  
type(fun) = Rcpp::functional::Compose&lt;test(Rcpp::Vector&lt;14, Rcpp::PreserveStorage&gt;)::$_0, test(Rcpp::Vector&lt;14, Rcpp::PreserveStorage&gt;)::$_1&gt;  
val = 18.000  
 [1]   2   8  18  32  50  72  98 128 162 200
</code></pre>

<p>It becomes even more interesting for how missing values should be treated. Let's now consider that the expression is used on an integer vector. </p>

<pre><code class="cpp">auto square = []( int a ){ return a*a ; } ;  
auto twice  = []( int a ){ return a*2 ; } ;  
auto y = sapply( sapply(x, square), twice ) ;  
</code></pre>

<p>In an iteration based implementation of sugar (like e.g. the implementation in Rcpp), to be correct we would have no choice but to check for <code>NA</code> twice because the two functions operate somewhat independently from one another. So the iteration based implementation in Rcpp would lead to code equivalent to this: </p>

<pre><code class="cpp">for( int i=0; i&lt;n; i++){  
    int x_i = x[i] ;
    int tmp_i = (x_i == NA_INTEGER) ? NA_INTEGER : square(i) ;
    y[i] = (tmp_i == NA_INTEGER ) ? NA_INTEGER : twice(i) ;
}
</code></pre>

<p>With the new composition based approach, we only have to check for <code>NA</code> once, which leads to code much closer to what we would intuitively write manually: </p>

<pre><code class="cpp">for( int i=0; i&lt;n; i++){  
    int x_i = x[i] ;
    y[i] = x_i == NA_INTEGER ? NA_INTEGER : twice(square(x_i)) ;
}
</code></pre>

<p>The composition based approach is still a work in progress, but I believe it will be yet another way to achieve performance improvements for the modernized version of sugar. </p>

<p>We can also generalize the composition approach to several input vectors, via <a href="https://web.archive.org/web/20140531145511/http://blog.r-enthusiasts.com/2014/05/22/using-mapply-in-rcpp11/">mapply</a>. Consider the expression : <code>x + exp(y) + abs(sin(z))</code>. The challenge is to identify actual vectors we want to iterate over: <code>x</code>, <code>y</code> and <code>z</code> and generate the appropriate function composition. Should be fun. </p>
</div>
