---
title:   xterm256 support in biocep
author: "Romain François"
date:  2009-05-28
slug:  xterm256-support-in-biocep
tags:  [ "R" ]
---
<div class="post-content">
<p>On this <a href="/index.php?post/2009/04/18/Colorful-terminal%3A-the-R-package-%22xterm256%22">post</a>, I presented the <a href="http://cran.r-project.org/web/packages/xterm256/index.html">xterm256</a> package for R, allowing to have text in background and foreground color in the R console</p>

<p>The drawback of relying on xterm escape sequences is that the package needs to be used within a terminal that supports this escape sequence protocol (basically some linux consoles)</p>

<p>Here, I am proposing a patch to the <a href="http://cran.r-project.org/web/packages/xterm256/index.html">biocep workbench</a> that emulates support for these colors directly in the biocep R console, see the screenshot below: </p>

<a href="/public/posts/xterm256/xterm256-biocep.png"><img src="/public/posts/xterm256/.xterm256-biocep_m.jpg" alt="xterm256-biocep.png" style="margin: 0 auto; display: block;" title="xterm256-biocep.png, mai 2009"></a>

<p>Combined with the syntax highlighter I am working on, this allows syntax highlighting of R code (pretty close to the way R sees the code) directly in the code and is in my view both visually pleasing and very useful</p>

<p>The functionality requires minor modifications of the source code of biocep that I have written and I can send a patch to interested users, but I unfortunately cannot commit the modifications to the biocep project because it is read-only at the moment</p>
</div>
