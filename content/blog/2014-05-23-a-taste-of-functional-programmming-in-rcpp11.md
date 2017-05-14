---
title:  A taste of functional programmming in Rcpp11
author: "Romain François"
date:  2014-05-23

---

<div class="post-content">
<p><a href="https://github.com/kevinushey">@kevinushey</a> requested some <a href="https://github.com/Rcpp11/Rcpp11/issues/140#issuecomment-43956758">functional programming</a> in <a href="https://github.com/Rcpp11/Rcpp11">Rcpp11</a> and provided initial versions of <code>map</code> and <code>filter</code>. <code>map</code> is actually doing exactly the same thing as <code>mapply</code> so I added <code>map</code> as a synonym to <code>mapply</code> so that we can do (see <a href="http://blog.r-enthusiasts.com/2014/05/22/using-mapply-in-rcpp11/">this previous post</a> for details): </p>

<pre><code class="cpp">// [[Rcpp::export]]
NumericVector mapply_example(NumericVector x, NumericVector y, double z){

    auto fun = [](double a, double b, double c){ return a + b + c ;} ;
    return map( fun, x, y, z ) ;

}
</code></pre>

<p><code>filter</code> takes a sugar expression (e.g. a vector) and a function predicte and only keeps the elements of the vector for which the predicate evaluates to <code>true</code>. Here is a simple example: </p>

<pre><code class="cpp">// [[Rcpp::export]]
NumericVector filter_example(NumericVector x ){  
    auto positives   = [](double a){ return a &gt;= 0 ;} ;
    return filter(x, positives ) ;
}
</code></pre>

<p>I've also put in the <code>negate</code> function. Intuitively enough, it takes a function (e.g. a lambda) and returns a function that negates it. For example, we can expand the previous example using both the <code>positives</code> lambda and a negated version of it: </p>

<pre><code class="cpp">// [[Rcpp::export]]
List filter_example_2(NumericVector x ){  
    auto positives   = [](double a){ return a &gt;= 0 ;} ;
    return list( 
        _["+"] = filter(x, positives ), 
        _["-"] = filter(x, negate(positives) ) 
    ) ;
}
</code></pre>

<p>We can also compose two functions: </p>

<pre><code class="cpp">// [[Rcpp::export]]
NumericVector filter_example_3(NumericVector x ){  
    auto small  = [](double a){ return a &lt; 4 ;} ;
    auto square = [](double a){ return a * a ;} ;

    return filter(x, compose(square, small) ) ;
}
</code></pre>

<p>But since I've been spoiled by <a href="https://github.com/smbache/magrittr"><code>magrittr</code></a> and <a href="https://github.com/hadley/dplyr"><code>dplyr</code></a>, I've put in this alternative way to compose the two functions: </p>

<pre><code class="cpp">// [[Rcpp::export]]
NumericVector filter_example_4(NumericVector x ){  
    auto small  = [](double a){ return a &lt; 4 ;} ;
    auto square = [](double a){ return a * a ;} ;

    return filter(x, _[square] &gt;&gt; small ) ;
}
</code></pre>

<p><code>_</code> turns <code>square</code> into a <code>Rcpp::functional::Functoid</code> which implements <code>operator&gt;&gt;</code>. <code>Functoid</code> can also be negated by the <code>operator!</code> : </p>

<pre><code class="cpp">// [[Rcpp::export]]
NumericVector filter_example_5(NumericVector x ){  
    auto small  = [](double a){ return a &lt; 4 ;} ;
    auto square = [](double a){ return a * a ;} ;
    auto fun    = _[square] &gt;&gt; small  ;

    return filter(x, !fun ) ;
}
</code></pre>

<p>I'm not sure this is going to be of any use or even if this will stay, but that was fun. </p>

<pre><code class="R">$ Rcpp11Script /tmp/filter.cpp

&gt; x &lt;- seq(-10, 10, by = 0.5)

&gt; filter_example_1(x)
 [1]  0.0  0.5  1.0  1.5  2.0  2.5  3.0  3.5  4.0  4.5  5.0  5.5  6.0  6.5  7.0
[16]  7.5  8.0  8.5  9.0  9.5 10.0

&gt; filter_example_2(x)
$`+`
 [1]  0.0  0.5  1.0  1.5  2.0  2.5  3.0  3.5  4.0  4.5  5.0  5.5  6.0  6.5  7.0
[16]  7.5  8.0  8.5  9.0  9.5 10.0

$`-`
 [1] -10.0  -9.5  -9.0  -8.5  -8.0  -7.5  -7.0  -6.5  -6.0  -5.5  -5.0  -4.5
[13]  -4.0  -3.5  -3.0  -2.5  -2.0  -1.5  -1.0  -0.5


&gt; filter_example_3(x)
 [1] -10.0  -9.5  -9.0  -8.5  -8.0  -7.5  -7.0  -6.5  -6.0  -5.5  -5.0  -4.5
[13]  -4.0  -3.5  -3.0  -2.5  -2.0   2.0   2.5   3.0   3.5   4.0   4.5   5.0
[25]   5.5   6.0   6.5   7.0   7.5   8.0   8.5   9.0   9.5  10.0

&gt; filter_example_4(x)
[1] -1.5 -1.0 -0.5  0.0  0.5  1.0  1.5

&gt; filter_example_5(x)
 [1] -10.0  -9.5  -9.0  -8.5  -8.0  -7.5  -7.0  -6.5  -6.0  -5.5  -5.0  -4.5
[13]  -4.0  -3.5  -3.0  -2.5  -2.0   2.0   2.5   3.0   3.5   4.0   4.5   5.0
[25]   5.5   6.0   6.5   7.0   7.5   8.0   8.5   9.0   9.5  10.0
</code></pre>
</div>
