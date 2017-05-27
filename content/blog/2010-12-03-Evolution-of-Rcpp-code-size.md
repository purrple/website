---
title:   Evolution of Rcpp code size
author: "Romain François"
date:  2010-12-03
slug:  Evolution-of-Rcpp-code-size
tags:  [ "graphics", "R", "Rcpp" ]
---
<div class="post-content">
<script type="text/javascript"><!--
google_ad_client = "ca-pub-0193080271541659";
/* blog */
google_ad_slot = "4394100836";
google_ad_width = 468;
google_ad_height = 60;
//-->
</script><script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script><br><br><p>I've been contributing to <a href="http://dirk.eddelbuettel.com/code/rcpp.html">Rcpp</a> for about a year now, initially to add missing bits that were needed for the development of <a href="http://dirk.eddelbuettel.com/code/rprotobuf.html">RProtoBuf</a>. This led to a complete redesign of the API, which now goes way beyond the initial code (that we now call classic Rcpp API). This has been quite a journey in terms of development with more than 1500 commits to the <a href="https://r-forge.r-project.org/scm/?group_id=155">svn repository</a> of the project on R-forge, and promotion with presentations at <a href="http://romainfrancois.blog.free.fr/index.php?post/2010/06/30/Rmetrics-slides">RMetrics 2010</a>, <a href="http://romainfrancois.blog.free.fr/index.php?post/2010/07/27/useR!-2010">useR 2010</a>, <a href="http://romainfrancois.blog.free.fr/index.php?post/2010/10/07/LondonR-Rcpp-slides">LondonR</a> and at <a href="http://romainfrancois.blog.free.fr/index.php?post/2010/10/28/Google-tech-talk-/-Rcpp%2C-...-presentation-on-youtube">Google</a>, as well as many <a href="http://romainfrancois.blog.free.fr/index.php?category/R-package/Rcpp">blog posts</a> about Rcpp and the packages that derive from it.</p>

<p>I wanted to take this opportunity to express visually how vibrant the development of <a href="http://dirk.eddelbuettel.com/code/rcpp.html">Rcpp</a> has been since it was first relaunched in 2008, and since I started to contribute. </p>

<p>The graph below shows the evolution of the number of lines (counting the .h, .cpp, .R, .Rd, .Rnw files) accross released versions of the <a href="http://dirk.eddelbuettel.com/code/rcpp.html">Rcpp</a> package on CRAN</p>

<p>The first thing I need for this is to download the 32 versions of <a href="http://dirk.eddelbuettel.com/code/rcpp.html">Rcpp</a> that have been released since 0.6.0.</p>

<iframe src="/public/packages/Rcpp/code_size/download.R.html" width="500" height="200"></iframe>

<p>Then, all it takes is some processing with R to extract the relevant information (number of lines in files of interest), and present the data in a graph. I'm also taking this opportunity to have some fun with raster images and the <a href="http://www.rforge.net/png/">png</a> package</p>

<a href="/public/packages/Rcpp/code_size/nlines_rcpp.png"><img src="/public/packages/Rcpp/code_size/nlines_rcpp_m.jpg" alt="nlines_rcpp.png" style="margin: 0 auto; display: block;" title="nlines_rcpp.png, déc. 2010"></a>

<p>The code explosion that started around version 0.7.8 marks the beginning of development of two of the most exciting and addictive projects I ever worked on: <a href="http://cran.r-project.org/web/packages/Rcpp/vignettes/Rcpp-modules.pdf">modules</a> and <a href="http://cran.r-project.org/web/packages/Rcpp/vignettes/Rcpp-sugar.pdf">sugar</a>

</p>
<p>The acceleration between 0.8.8 and the current version 0.8.9 represents many of the improvements that were made in modules. That alone, with more than 8000 new lines of code and documentation represents about 4 times as many lines as the total number of lines in 0.6.0</p>

<p>We still have plenty of ideas, and <a href="http://dirk.eddelbuettel.com/code/rcpp.html">Rcpp</a> will continue to evolve to deliver a quality interface between R and C++, to the best of the current team's abilities. </p>

<p>The full code is available below: </p>

<iframe src="/public/packages/Rcpp/code_size/rcpp_lines.R.html" width="500" height="500"></iframe>
</div>
