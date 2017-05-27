---
title:   LondonR slides
author: "Romain François"
date:  2009-11-09
slug:  LondonR-slides
tags:  [ "conference", "londonR", "R" ]
---
<div class="post-content">
<p>I was in london last week to present <a href="http://r-forge.r-project.org/projects/remoterengine/">RemoteREngine</a> at the <a href="http://www.londonr.org/">LondonR</a> user group sponsored by <a href="http://www.mango-solutions.com/">mango solutions</a>. </p>

<p>Apart from minor technical details and upsetting someone because I did not mention that he once presented a much simpler solution to a quite different problem, it went pretty good and people were interested in what the package can do</p>

<p>Essentially, <a href="http://r-forge.r-project.org/projects/remoterengine/">RemoteREngine</a> is an implementation of <a href="http://www.rforge.net/org/docs/index.html?org/rosuda/REngine/REngine.html">REngine</a> using <a href="http://java.sun.com/javase/technologies/core/basic/rmi/index.jsp">java rmi (remote method invocation)</a> for the data transport. </p>

<p>This allows a (or several) client java application to <em>embed</em> an R engine that lives in a different java virtual machine, perhaps on a different physical machine. In a way it is quite similar to the Rserve implementation of REngine, but rmi gives better control over the data transport and we get things Rserve does not currently do such as support for environments or references. </p>

<p>The slides are available <a href="/public/posts/londonR/remoterengine-londonR.pdf">here</a> and will probably also make their way to the <a href="http://www.londonr.org/">conference site</a> at some point</p>
</div>
