---
title:   biocep's broken REPL
author: "Romain François"
date:  2009-05-29
slug:  biocep-s--broken--REPL
tags:  [ "java", "R" ]
---
<div class="post-content">
<p>The REPL (Read Eval Print Loop) is the mechanism that R uses to (roughly): </p>

<ul>
<li>get input from the console</li>
<li>send output to the console</li>
</ul>
<p><a href="http://www.rforge.net/rJava/">JRI</a> defines a mechanism for taking advantage of the REPL from java, through the <a href="http://www.rosuda.org/R/nightly/JavaDoc/org/rosuda/JRI/RMainLoopCallbacks.html">RMainLoopCallbacks</a> interface</p>

<p>biocep takes advantage of this infrastructure by implementing the interface within the <a href="https://r-forge.r-project.org/plugins/scmsvn/viewcvs.php/src_server/org/kchine/r/server/DirectJNI.java?rev=467&amp;root=biocep&amp;view=markup">DirectJNI</a> class</p>

<p>To circumvent the fact that the REPL is basically an endless loop, gui front-ends usually let the loop run in its own thread, and set this thread to sleep whenever the user does something else than feeding the REPL. This is not quite the way it is done in biocep's implementation. In biocep, when there is no command to run, the REPL thread would wait a short amount of time and then send an empty string <code>""</code> to the readConsole callback. </p>

<p>The reason why this is deficient is because R might not only use the REPL to ask for top-level command line commands, but also within the <a href="http://finzi.psych.upenn.edu/R/library/base/html/browser.html">environment</a> browser commonly used in R for debugging. Now feeding the browser prompt with an empty command has the effect of stepping out of it, making debugging impossible.</p>

<p>Here is <a href="/public/posts/repl/browsing.diff">patch</a> against biocep that is a first attempt at solving this issue by implementing the REPL with a sleeping thread, inspired from the way the REPL is implemented in <a href="http://jgr.markushelbig.org/JGR.html">JGR</a>. The patch has been made available to the author of biocep. </p>
</div>
