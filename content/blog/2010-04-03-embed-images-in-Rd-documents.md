---
title:   embed images in Rd documents
author: "Romain François"
date:  2010-04-03
slug:  embed-images-in-Rd-documents
tags:  [ "html", "R", "Rd" ]
---
<div class="post-content">
<style type="text/css">
pre{ border: 1px solid black; }
</style>
<p>The new help system that was introduced in R 2.10.0 and documented in an <a href="http://journal.r-project.org/archive/2009-2/RJournal_2009-2_Murdoch+Urbanek.pdf">article</a> of the R journal is very promising. </p>

<p>One thing that is planned for future versions of R (maybe 2.12.0) is some way to include images into Rd documents using the fig option of the <a href="http://cran.r-project.org/doc/manuals/R-exts.html#Dynamic-pages">Sexpr macro</a></p>

<p>Another way is to use <a href="http://en.wikipedia.org/wiki/Data_URI_scheme">data uri</a> and embed the image directly inside the html code, so this morning I played with this and wrapped up <a href="http://base64.sourceforge.net/b64.c">this little c library</a> into an R package called base64 and hosted in the Rcpp project at r-forge.</p>

<p>The package allows encoding and decoding files using the <a href="http://fr.wikipedia.org/wiki/Base64">Base64</a> format. It currently has three functions: encode, decode and img. encode and decode do what their name implies, and img produces the html code suitable for embedding the image into an html document. </p>

<p>The <a href="/public/packages/base64/img.html">help page</a> for img actually contains an image, here is it: </p>

<iframe src="/public/packages/base64/img.html" width="500" height="500"></iframe>

<p> and here is how it is produced: </p>

<pre>
\details{
\if{html}{
	The following graph is embedded in the document using the \code{img} function	
	
\Sexpr[stage=render,results=rd,echo=FALSE]{
	library( base64 )
	library( grDevices )
	library( graphics )
	library( stats )
	
	pngfile </pre>
</div>
