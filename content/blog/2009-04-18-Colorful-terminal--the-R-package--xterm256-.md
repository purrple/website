---
title:   Colorful terminal- the R package "xterm256"
author: "Romain François"
date:  2009-04-18
slug:  Colorful-terminal--the-R-package--xterm256-
tags:  [ "R" ]
---
<div class="post-content">
<p>One of the goal of my forthcoming <a href="http://r-forge.r-project.org/projects/highlight/">highlight</a> package for R is to provide syntax highlighting based on evidence gathered from the output of the R parser directly into the R console (more on this later)</p>

<p>While writing the renderer targetting the console, I realized that support for colored text in the console is something that might be useful outside of the highlighter, and then decided to make it an independent package : <a href="http://r-forge.r-project.org/plugins/scmsvn/viewcvs.php/pkg/xterm256/?root=highlight">xterm256</a></p>

<p>The idea is to use the <a href="http://frexx.de/xterm-256-notes/">The 256 color mode of xterm</a> to wrap some text between escape sequences so that when it is cat to the console, the text appears with a background and/or a foreground color. Here is a screenshot from my console: 

<a href="/public/posts/xterm256/lef-2.png"><img src="/public/posts/xterm256/.lef-2_m.jpg" alt="lef-2.png" style="margin: 0 auto; display: block;" title="lef-2.png, avr. 2009"></a>

</p>
<p>The package exposes only one function with three arguments: the <code>style</code> function with arguments :
</p>
<ul>
<li>
<code>x</code>: the text we want to style</li>
<li>
<code>bg</code>: the background color we want to use</li>
<li>
<code>fg</code>: the foreground color we want to use</li>
</ul>
<p>so if you want to print hello world in yellow with a black background, you can do: </p>

<pre>
cat( style( "hello world", bg = "black", fg = "yellow"), "\n" )
</pre>
</div>
