---
title:   Rcpp svn revision 2000
author: "Romain François"
date:  2010-08-13
slug:  Rcpp-svn-revision-2000
tags:  [ "Rcpp" ]
---
<div class="post-content">
<style type="text/css">
pre{
border : 1px solid black ;
}
</style>
<a href="http://www.flickr.com/photos/hijukal/146101132/"><img src="http://farm1.static.flickr.com/47/146101132_f1855e53b9_z_d.jpg?zz=1"></a>

<p>I commited the 2000th revision of <a href="http://dirk.eddelbuettel.com/code/rcpp.html">Rcpp</a> svn today, so I wanted to look back at what I did previously with the <a href="http://romainfrancois.blog.free.fr/index.php?post/2009/10/09/celebrating-R-commit-50000">50 000th</a> R commit. </p>

<p>Here are the number of commits per day and month</p>

<a href="/public/packages/Rcpp/commit2000/commits_per_day.png"><img src="/public/packages/Rcpp/commit2000/commits_per_day_m.jpg" alt="commits_per_day.png" style="margin: 0 auto; display: block;" title="commits_per_day.png, août 2010"></a>

<a href="/public/packages/Rcpp/commit2000/commits_per_month.png"><img src="/public/packages/Rcpp/commit2000/commits_per_month_m.jpg" alt="commits_per_month.png" style="margin: 0 auto; display: block;" title="commits_per_month.png, août 2010"></a>

<p>... the same thing, but focused on the period since I joined the project</p>

<a href="/public/packages/Rcpp/commit2000/commits_per_day__zoom.png"><img src="/public/packages/Rcpp/commit2000/commits_per_day__zoom_m.jpg" alt="commits_per_day__zoom.png" style="margin: 0 auto; display: block;" title="commits_per_day__zoom.png, août 2010"></a>

<a href="/public/packages/Rcpp/commit2000/commits_per_month__zoom.png"><img src="/public/packages/Rcpp/commit2000/commits_per_month__zoom_m.jpg" alt="commits_per_month__zoom.png" style="margin: 0 auto; display: block;" title="commits_per_month__zoom.png, août 2010"></a>

<p>... and now split by contributor</p>

<a href="/public/packages/Rcpp/commit2000/commits_per_day_per_author__zoom.png"><img src="/public/packages/Rcpp/commit2000/commits_per_day_per_author__zoom_m.jpg" alt="commits_per_day_per_author__zoom.png" style="margin: 0 auto; display: block;" title="commits_per_day_per_author__zoom.png, août 2010"></a>

<a href="/public/packages/Rcpp/commit2000/commits_per_month_author__zoom.png"><img src="/public/packages/Rcpp/commit2000/commits_per_month_author__zoom_m.jpg" alt="commits_per_month_author__zoom.png" style="margin: 0 auto; display: block;" title="commits_per_month_author__zoom.png, août 2010"></a>

<p>here are the month where each of us have been the most active</p>

<pre>
&gt; do.call( rbind, 
   lapply( 
    split( month_author_data, month_author_data$author ) , 
    function(x) x[ which.max( x[["commits"]] ), ] ) 
  )
               date  author commits month year
dmbates 2010-08-01 dmbates      19    08 2010
edd     2010-06-01     edd     118    06 2010
romain  2010-06-01  romain     256    06 2010
</pre>


<p>and the most active day</p>


<pre>
&gt; do.call( rbind, 
   lapply( 
    split( day_author_data, day_author_data$author ) , 
    function(x) x[ which.max( x[["commits"]] ), ] ) 
  )
              date  author commits month year
dmbates 2010-08-06 dmbates      13     8 2010
edd     2010-02-16     edd      20     2 2010
romain  2010-06-17  romain      30     6 2010
</pre>

<p>The code to reproduce the graphs is <a href="/public/packages/Rcpp/commit2000/svn.R">here</a></p>
</div>
