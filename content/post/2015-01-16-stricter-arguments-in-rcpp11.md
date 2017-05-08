---
title:  stricter arguments in Rcpp11/Rcpp14
author: "Romain François"
date:  2015-01-16
tags: []
---

<div class="post-content">
<p>The way some classes (e.g. <code>NumericVector</code> have been implemented in various <code>R/C++</code> versions gives us automatic coercion. For example passing an integer vector to a C++ function that has a <code>NumericVector</code> as an argument will coerce the <code>integer</code> vector into a <code>numeric</code> vector automatically. </p>

<pre><code class="cpp">// [[export]]
double foo( NumericVector x){  
   return sum(x) ;
}
</code></pre>

<p>will give us: </p>

<pre><code>x &lt;- c(1,2)  
foo(x)  
# 3

x &lt;- c(1L, 2L)  
foo(x)  
# 3
</code></pre>

<p>Sometimes, we would like to restrict <code>x</code> to just be a <code>numeric</code> vector. For this we would typically have to use <code>SEXP</code> as the argument class and then test conformity manually, something like this: </p>

<pre><code class="cpp">// [[export]]
double foo( SEXP x_ ){  
   if( !is&lt;NumericVector&gt;( x_ ) ) stop( "not a numeric vector" ) ;
   NumericVector x(x_) ;
   return sum(x) ;
}
</code></pre>

<p>Which is boring boiler plate code, so I've added the <code>Strict</code> class into <a href="https://web.archive.org/web/20150304070858/https://github.com/Rcpp11/Rcpp11"><code>Rcpp11</code></a> and <a href="https://web.archive.org/web/20150304070858/https://github.com/Rcpp11/Rcpp14"><code>Rcpp14</code></a>. The class is pretty simple, it has two things: </p>

<ul>
<li>a constructor taking a <code>SEXP</code>, which makes it a perfect candidate for an attributes generated function. The constructor stores the <code>SEXP</code> and checks if it is compatible using the appropriate <code>is&lt;&gt;</code> function, if not it throws an exception. </li>
<li>a <code>get</code> member function that returns a new object of the target class. </li>
</ul>
<p>With this, we can write <code>foo</code> : </p>

<pre><code class="cpp">// [[export]]
double foo( Strict&lt;NumericVector&gt; x){  
   return sum(x.get()) ;
}
</code></pre>
</div>
