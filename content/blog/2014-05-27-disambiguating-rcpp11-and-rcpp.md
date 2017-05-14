---
title:  Disambiguating Rcpp11 and Rcpp
author: "Romain François"
date:  2014-05-27

---

<p>I pushed <a href="https://github.com/Rcpp11/Rcpp11/commit/2602e7a9fd745a695f9dceb839d766b85377adf7">some code</a> this morning to allow
us to use this alternative syntax to use <a href="https://github.com/Rcpp11/Rcpp11"><code>Rcpp11</code></a>. </p>

<pre><code>#include &lt;Rcpp11&gt;
using namespace Rcpp11 ;  
</code></pre>

<p>Of course the usual code will continue to work, and might even be preferable if you write code that needs to be compatible with both <code>Rcpp11</code> and <code>Rcpp</code>, e.g. when doing comparative benchmarks ... </p>

<pre><code>#include &lt;Rcpp.h&gt;
using namespace Rcpp ;  
</code></pre>

<p>But the new syntax makes it clearer that you are using <code>Rcpp11</code>. </p>
