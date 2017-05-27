---
title:   Better completion popups
author: "Romain François"
date:  2009-06-02
slug:  Completion-popups
tags:  [ "jedit", "R" ]
---
<div class="post-content">
<p>I've now updated the <a href="/index.php?post/2009/01/09/Code-Completion-for-R-scripts">completion popups</a> used in the advanced editor plugin to get a better display of the available information</p>

<p>For completion items that are related to functions with a help page, we now get this popup</p>

<a href="/public/posts/post3_completion/completion-helppage.png">
<img src="/public/posts/post3_completion/completion-helppage_m.jpg" alt="completion-argument.png" style="margin: 0 auto; display: block;" title="completion-argument.png, juin 2009"></a>

<p>When completing arguments of functions, the text of the argument is grabbed from the help page (if available), and displayed as such: </p>

<a href="/public/posts/post3_completion/completion-argument.png">
<img src="/public/posts/post3_completion/completion-argument_m.jpg" alt="completion-argument.png" style="margin: 0 auto; display: block;" title="completion-argument.png, juin 2009"></a>

<p>For functions that do not have help page, such as functions in the global environment, a <a href="http://finzi.psych.upenn.edu/R/library/base/html/deparse.html">deparse</a> of the function is displayed</p>

<a href="/public/posts/post3_completion/completion-local.png">
<img src="/public/posts/post3_completion/completion-local_m.jpg" alt="completion-argument.png" style="margin: 0 auto; display: block;" title="completion-argument.png, juin 2009"></a>

<p>It is probably better to build the plugin from source, but otherwise I have posted a build <a href="http://addictedtor.free.fr/software/workbench/editor/dist/Editor.zip">here</a></p>

<p>I am currently working on ways to bring this completion mechanism to the console as well</p>
</div>
