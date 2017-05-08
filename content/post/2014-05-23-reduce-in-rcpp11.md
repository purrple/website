---
title:  reduce in Rcpp11
author: "Romain François"
date:  2014-05-23
tags: []
---

<div class="post-content">
<p>And <a href="https://web.archive.org/web/20140528031555/https://github.com/Rcpp11/Rcpp11/commit/047e961f1e205b51a8e4f1766f8da3eb6ae07de8">now</a> for something completely difference, the <code>reduce</code> function, doing something similar to what the <code>Reduce</code> function does in R: </p>

<pre><code class="cpp">#include &lt;Rcpp.h&gt;
using namespace Rcpp ;

// [[Rcpp::export]]
double reduce_example(NumericVector x ){  
    auto add   = [](double a, double b){ return a + b ;} ;
    return reduce(x, add ) ;
}


/*** R
  x &lt;- 1:10
  reduce_example(x)
*/
</code></pre>

<p>Giving: </p>

<pre><code class="txt">$ Rcpp11Script /tmp/reduce.cpp

&gt; x &lt;- 1:10

&gt; reduce_example(x)
[1] 55
</code></pre>
</div>
