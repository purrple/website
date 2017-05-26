---
title:   Code optimization, an Rcpp solution
author: "Romain François"
date:  2011-11-10
slug:  Code-optimization--an-Rcpp-solution
tags:  [ "R", "Rcpp" ]
---
<div class="post-content">
<p><a href="http://tonybreyal.wordpress.com/">Tony Breyal</a> woke up an old code optimization problem in this <a href="http://tonybreyal.wordpress.com/2011/11/02/code-optimization-one-r-problem-ten-solutions-%E2%80%93-now-eleven-2/">blog post</a>, so I figured it was time for an <a href="http://dirk.eddelbuettel.com/code/rcpp.html">Rcpp</a> based solution</p>

<p>This solutions moves down Henrik Bengtsson's idea (which was at the basis of attempt 10) down to C++. The idea was to call sprintf less than the other solutions to generate the strings "001", "002", "003", ...</p>


<iframe src="/public/packages/Rcpp/generateIndex14_2.html" height="400" width="500"></iframe>

<p>We can benchmark this version using the rbenchmark package:</p>

<pre>
&gt; library(rbenchmark)
&gt; n  benchmark(
+     generateIndex10(n), 
+     generateIndex11(n),
+     generateIndex12(n), 
+     generateIndex13(n),
+     generateIndex14(n),
+     columns = 
+        c("test", "replications", "elapsed", "relative"),
+     order = "relative",
+     replications = 20
+ )
                test replications elapsed relative
5 generateIndex14(n)           20  21.015 1.000000
3 generateIndex12(n)           20  22.034 1.048489
4 generateIndex13(n)           20  23.436 1.115203
2 generateIndex11(n)           20  23.829 1.133904
1 generateIndex10(n)           20  30.580 1.455151
&gt;    

</pre>
</div>
