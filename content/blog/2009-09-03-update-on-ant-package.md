---
title:   update on the ant package
author: "Romain François"
date:  2009-09-03
slug:  update-on-ant-package
tags:  [ "ant", "java", "R" ]
---
<div class="post-content">
<p>I have updated the ant package I described <a href="/index.php?post/2009/09/02/R-capable-version-of-ant">yesterday</a> in this blog to add several things</p>

<p>
</p>
<ul>
<li>Now the R code related to <strong>&lt;r-set&gt;</strong> and <strong>&lt;r-run&gt;</strong> tasks can either be given as the <strong>code</strong> attribute or as the text inside the task</li>
<li>The R code has access to special variables to manipulate the current project (<strong>project</strong>) and the current task (<strong>self</strong>) which can be used to set properties, get properties, ...</li>
<li>The package contains ant <strong>ant</strong> function so that ant can be invoked using a simple Rscript call, see below</li>
</ul>
<p>The package now includes a demonstrative <strong>build.xml</strong> file in the <strong>examples</strong> directory</p>

<iframe src="/public/posts/ant/ant-build-2.html" frameborder="1" width="500" height="750"></iframe>

<p>Here is the result</p>

<iframe src="/public/posts/ant/ant-build-result.html" frmeborder="1" width="500" height="300"></iframe>
</div>
