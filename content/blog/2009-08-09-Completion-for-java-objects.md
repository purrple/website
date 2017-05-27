---
title:   Completion for java objects
author: "Romain François"
date:  2009-08-09
slug:  Completion-for-java-objects
tags:  [ "completion", "java", "R" ]
---
<div class="post-content">
<p>As indicated in this <a href="http://tr.im/vQi9">thread</a>, completion after the dollar operator can be customized by defining a custom <code>names</code> method. Here I am showing how to take advantage of this to display fields and methods of java references (jobjRef objects from the rJava package)</p>

<iframe src="/public/snippets/completion.html" frameborder="1" height="450" width="500"></iframe>

<p>Here it is in action (I hit tab twice after the dollar sign)</p>

<iframe src="/public/snippets/completion-session.html" frameborder="1" height="150" width="500"></iframe>
</div>
