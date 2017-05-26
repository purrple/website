---
title:   Rcpp reverse dependency graph
author: "Romain François"
date:  2011-10-30
slug:  Rcpp-reverse-dependency-graph
tags:  [ "CRAN", "graphviz", "R", "Rcpp" ]
---
<div class="post-content">
<p>I played around with reverse dependencies of <a href="http://dirk.eddelbuettel.com/code/rcpp.html">Rcpp</a>. At the moment, 44 packages depend on <a href="http://dirk.eddelbuettel.com/code/rcpp.html">Rcpp</a> and the number goes up to 53 when counting recusive reverse dependencies.</p>

<p>I've used <a href="http://www.graphviz.org/">graphviz</a> for the representation of the directed graph</p>

<img src="/public/packages/Rcpp/dep.png" alt="dep.png" style="margin: 0 auto; display: block;" title="dep.png, oct. 2011"><p>Here is the code I've used to generate the dot file:</p>

<iframe src="/public/packages/Rcpp/depends.html" width="550" height="400"></iframe>
</div>
