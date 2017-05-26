---
title:   Code2html speaks Latex too
author: "Romain François"
date:  2009-01-22
slug:  Code2html-speaks-Latex-too
tags:  [ "code2html", "jedit", "latex", "sweave" ]
---
<div class="post-content">For highlighting code inside latex documents there are several options: 
<ul>
<li>the <a href="http://www.pvv.ntnu.no/~berland/latex/docs/listings.pdf">listings</a> package (somehow supported by the R package <a href="http://cran.r-project.org/web/packages/SweaveListingUtils/index.html">SweaveListingUtils</a>
</li>
<li>Using <a href="http://www.andre-simon.de/">highlight</a>. I am using it in the <a href="http://addictedtor.free.fr/graphiques">graph</a> gallery for example
</li>
<li>There are probably other ways ...
</li>
</ul>
<br>

This might be a judgement call, but I don't find the latex output of listings or highlight to be visually pleasing enough, but maybe it is just a lack of understanding on how to customize them. Anyway, jedit has the <a href="http://plugins.jedit.org/plugins/?Code2HTML">Code2HTML</a> plugin which does a good job of translating the buffer being edited in jedit into html markup, preserving pretty much everything that appear on the jedit text area. This takes advantage of jedit mode files which offers a great deal of flexibility, including nested languages, such as javascript/php, or <a href="/index.php?post/2008/12/31/Edit-Sweave-files-with-the-workbench">R and Sweave</a> if you have the right mode files. 
<br>

So I had a look into the code of the <a href="http://plugins.jedit.org/plugins/?Code2HTML">Code2HTML</a> plugin which is simple enough, and have basically done a big <code>s/html/latex/g</code> to support latex output (I realize this is not the best option and I should probably abstract things out so that it would be easier to add new formats: ansi, svg, ...) but it does the trick for now. 

Here is a screenshot of an example file edited in jedit: 

<img src="/public/posts/code2html/ScreenshotJedit.png" alt="ScreenshotJedit.png" style="margin: 0 auto; display: block;" title="ScreenshotJedit.png, janv. 2009">

And a screenshot of the pdf file 

<img src="/public/posts/code2html/ScreenshotPdf.png" alt="ScreenshotPdf.png" style="margin: 0 auto; display: block;" title="ScreenshotPdf.png, janv. 2009">


Here are the relevant files if you want to try it out: 
<ul>
<li>The modified source of <a href="/public/posts/code2html/Code2HTML.tar.gz">Code2HTML</a>
</li>
<li>The actual <a href="/public/posts/code2html/Code2HTML.jar">jar</a> file</li>
<li>An example <a href="/public/posts/code2html/example.R">R file</a>
</li>
<li>... once translated into <a href="/public/posts/code2html/Code2HTML.jar">latex markup</a>
</li>
<li>... once compile with <a href="/public/posts/code2html/Code2HTML.jar">pdflatex</a>
</li>
</ul>

Next steps: 
<ul>
<li>do something about the gutter</li>
<li>figure out how to invoke that from the command line</li>
<li>write a sweave driver that would call it so that R code appears formatted in sweave documents</li>
</ul>
</div>
