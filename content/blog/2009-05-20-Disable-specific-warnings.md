---
title:   Disable specific warnings
author: "Romain François"
date:  2009-05-20
slug:  Disable-specific-warnings
tags:  [ "R" ]
---
<div class="post-content">
<p><span style="font-style:italic">[This post is inspired from this <a href="http://article.gmane.org/gmane.comp.lang.r.general/150437">thread</a> on R-help]</span></p>

<p>The <a href="http://finzi.psych.upenn.edu/R/library/base/html/warning.html">suppressWarnings</a> function allows to call a function and suppress whatever warning it might generate. This uses the <a href="http://finzi.psych.upenn.edu/R/library/base/html/conditions.html">calling handler and restart mechanism</a> of R to invoke the special "muffleWarning" restart when a warning is detected by the handler.</p>

<p>The downside is that it removes <span style="font-weight:bold">all</span> warnings, and this might not be what you want. Consider that simple function that gives two warnings: </p>

<pre>
f  f(5)
[1] 8
Warning messages:
1: In f(5) : bla bla
2: In f(5) : yada yada
&gt; suppressWarnings( f(5) )
[1] 8
</pre>

<p>What if I wanted to remove "bla bla" warnings and not "yada yada" warnings, because I know that "bla bla" warnings are expected and are more disturbing that useful. Currently, <code>suppressWarnings</code>
does not offer that possibility, but you can make you own calling handler that handles warnings the way you want: </p>

<pre>
&gt; h  withCallingHandlers( f(5), warning = h )
[1] 8
Warning message:
In f(5) : yada yada
</pre>
</div>
