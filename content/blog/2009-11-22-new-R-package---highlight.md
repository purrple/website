---
title:   new R package - highlight
author: "Romain François"
date:  2009-11-22
slug:  new-R-package---highlight
tags:  [ "highlight", "html", "latex", "package", "parser", "R" ]
---
<div class="post-content">
<p>I finally pushed <strong>highlight</strong> to CRAN, which should be available in a few days. The package uses the information gathered by the <a href="http://romainfrancois.blog.free.fr/index.php?post/2009/07/28/R-parser-package-on-CRAN">parser</a> package to perform syntax highlighting of R code</p>

<p>The main function of the package is <strong>highlight</strong>, which takes a number of argument including :</p>

<ul>
<li>
<strong>file</strong> : the file in which the R code is</li>
<li>
<strong>output</strong> : some output connection or file name where to write the result (The default is standard output)</li>
<li>
<strong>renderer</strong> : a collection of function controlling how to render code into a given markup language</li>
</ul>
<p>The package ships three functions that create such renderers </p>

<ul>
<li>
<strong>renderer_html</strong> : renders in html/css</li>
<li>
<strong>renderer_latex</strong>: renders in latex</li>
<li>
<strong>renderer_verbatim</strong>: does nothing</li>
</ul>
<p>And additionally, the <a href="http://romainfrancois.blog.free.fr/index.php?post/2009/04/18/Colorful-terminal%3A-the-R-package-%22xterm256%22">xterm256</a> package defines a renderer that allows syntax highlighting directly in the console (if the console knows xterm 256 colors)</p>

<p>Let's assume we have this code file (/tmp/code.R) </p>

<pre>
f 

<p>Then we can syntax highlight it like this :</p>

<pre>
&gt; highlight( "/tmp/code.R", renderer = renderer_html(), output = "/tmp/code.R.html" )
&gt; highlight( "/tmp/code.R", renderer = renderer_latex(), output = "/tmp/code.R.latex" )
</pre>

<p>which makes these files : <a href="/public/packages/highlight/code.R.html">code.R.html</a> and <a href="/public/packages/highlight/code.R.latex">code.R.latex</a></p>

<p>The package also ships a sweave driver that can highlight code chunks in a sweave document, but I'll talk about this in another post</p></pre>
</div>
