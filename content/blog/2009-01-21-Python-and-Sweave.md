---
title:   python code in sweave document
author: "Romain François"
date:  2009-01-21
slug:  Python-and-Sweave
tags:  [ "python", "R", "sweave" ]
---
<div class="post-content">It would be great if we could not only use R or S in sweave code chunks but also some other languages such as python for example. Why would you want that, well python has some additional graphics capabilities R does not have, some software is written in python but you still want to write your document in sweave, ...
Here is a first attempt, obviously not complete.
<br><h2>A custom sweave driver</h2>
The first trick is to write a custom sweave driver, based on the basic <a href="http://finzi.psych.upenn.edu/R/library/utils/html/RweaveLatex.html">RweaveLatex</a> driver which does something with the content of a chunk when the <strong>engine</strong> is set to python :<br><br><pre>driver <strong>&lt;- RweaveLatex</strong>() <br>runcode <strong>&lt;-</strong> driver$runcode<br>driver$runcode <strong>&lt;- function</strong>(object, chunk, <strong>options</strong>)<strong>{</strong><br><strong>if</strong>( <strong>options</strong>$engine <strong>==</strong> "python" )<strong>{</strong><br>    driver$writedoc( object, <strong>c</strong>("\\begin{python}", chunk, "\\end{python}") )<br><strong>} else{</strong><br>    runcode( object, chunk, <strong>options</strong> )<br><strong>}</strong><br><strong>}</strong><br><strong>Sweave</strong>( "python.Rnw", driver <strong>=</strong> driver ) </pre>
The only thing the driver does is convert python code chunks into a python environment, so that this in the <a href="/public/posts/sweave-python/python.Rnw">Rnw</a>  file:
<pre>&lt;&lt;hello,engine=python&gt;&gt;=<br><strong>print</strong> "hello"<br><strong>print</strong> "world"<br>@</pre>
becomes that in the <a href="/public/posts/sweave-python/python.tex">tex</a> file:
<pre><strong>\begin{python}</strong><br>print "hello"<br>print "world"<br><strong>\end{python}</strong></pre>
<h2>Process the python code</h2>
<br>
Then you need to install the <a href="http://www.imada.sdu.dk/%7Eehmsen/pythonlatex.php">python</a> package into your texmf tree and texhash (just google around if you don't know what it means). The python package defines the python environment so that when you compile the tex file, latex calls python and brings back the output of the python script. The catch is that you need to compile your tex file with the option <code>-shell-escape</code>. <br><pre>$ pdflatex -shell-escape python.tex</pre>
<h2>Beyond the simple trick</h2>
<br>
So we can get hello world from python, this needs more thinking to enable:<br><ul>
<li>production of graphics from python with a fig option, just like you do it in R, <a href="http://www.texample.net/weblog/2008/oct/24/embedding-python-latex/">see this for example</a>
</li>
<li>some way to share the data between R and python so that variables created in the R world could be used in the python world and vice-versa, I don't know the best way to do that at the moment, but from the  top of my head we could either use <a href="http://rpy.sourceforge.net/">rpy</a> for the communication or the database that gets generated by the <a href="http://cran.r-project.org/web/packages/cacheSweave/vignettes/cacheSweave.pdf">cacheSweave</a> package </li>
</ul>
<br>
</div>
