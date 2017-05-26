---
title:   OOP with Rcpp modules
author: "Romain François"
date:  2012-11-05
slug:  OOP-with-Rcpp-modules
tags:  [ "cplusplus", "OOP", "R", "Rcpp" ]
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
</script><br><br><p>The purpose of <a href="http://dirk.eddelbuettel.com/code/rcpp.html">Rcpp</a> modules has always been to make it easy to expose C++ functions and classes to R. Up to now, Rcpp modules did not have a way to declare inheritance between C++ classes. This is now fixed in the development version, and the next version of Rcpp will have a simple mechanism to declare inheritance. </p>

<p>Consider this simple example, we have a base class <strong>Shape</strong> with two virtual methods (<strong>area</strong> and <strong>contains</strong>) and two classes <strong>Circle</strong> and <strong>Rectangle</strong>) each deriving from <strong>Shape</strong> and representing a specific shape. </p>

<p>The classes might look like this: </p>

<iframe src="/public/posts/shapes/classes.html" width="500" height="900" frameborder="0"></iframe>

<p>And we can expose these classes to R using the following module declarative code: </p>

<iframe src="/public/posts/shapes/module.html" width="500" height="400" frameborder="0"></iframe>

<p>It is worth noticing that: </p>

<ul>
<li>The <strong>area</strong> and <strong>contains</strong> methods are exposed as part of the base <strong>Shape</strong> class</li>
<li>Classes <strong>Rectangle</strong> and <strong>Circle</strong> simply declare that they derive from <strong>Shape</strong> using the <strong>derives</strong> notation. </li>
</ul>
<p>R code that uses these classes looks like this: </p>

<iframe src="/public/posts/shapes/play.html" width="500" height="200" frameborder="0"></iframe>

<img src="/public/posts/shapes/.shapes_m.jpg" alt="shapes.jpg" style="margin: 0 auto; display: block;" title="shapes.jpg, nov. 2012">
</div>
