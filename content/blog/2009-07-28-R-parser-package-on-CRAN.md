---
title:   R parser package on CRAN
author: "Romain François"
date:  2009-07-28
slug:  R-parser-package-on-CRAN
tags:  [ "bison", "package", "parser", "R" ]
---
<div class="post-content">
<style>
pre{
border: 1px solid black; 
font-family: "Courier New" !important; 
font-size: xx-small !important; 
}
</style>
<p>The <em>parser</em> package has been released to <a href="http://cran.r-project.org/web/packages/parser/index.html">CRAN</a>, the package mainly defines a function <em>parser</em> that is similar to the usual R function <em><a href="http://finzi.psych.upenn.edu/R/library/base/html/parse.html">parse</a></em>, with the few following differences: </p>

<ul>
<li>The information about the location of each token is structured differently, in a data frame</li>
<li>location is gathered for <em>all</em> symbols from the source code, including terminal symbols (tokens), comments</li>
<li>An equal sign is identified to be either an assignment, the declaration of a formal argument or the use of an argument</li>
</ul>
<p>Here is an example file containing R source code that we are going to parse with <em>parser</em></p>

<pre>
#' a roxygen comment
f 

<p>It is a very simple file, for illustration purpose. Let's look what to do with it with the parser package</p>

<iframe src="/public/posts/parser/parser-example.html" width="500" height="600" frameborder="1">
</iframe>

<p>The parser generates a list of expressions, just like the regular <a href="http://finzi.psych.upenn.edu/R/library/base/html/parse.html">parse</a> function, but the gain is the <code>data</code> attribute. This is a data frame where each token of the parse tree is a line. The id column identifies each line, and the parent column identifies the parent of the current line. </p>

<p>At the moment, only the forthcoming <a href="http://r-forge.r-project.org/projects/highlight/">highlight</a> package uses the parser package (actually the parser package has been factored out of highlight), but some anticipated uses of the package include:
</p></pre>
<ul>
<li>rework the <a href="http://cran.r-project.org/web/packages/codetools/index.html">codetools</a> package so that it tells source location of potential problems</li>
<li>code coverage in <a href="http://cran.r-project.org/web/packages/RUnit/index.html">RUnit</a> or <a href="http://cran.r-project.org/web/packages/svUnit/index.html">svUnit</a>
</li>
<li>rework the <a href="http://roxygen.org/">roxygen</a> parser</li> 
</ul>
</div>
