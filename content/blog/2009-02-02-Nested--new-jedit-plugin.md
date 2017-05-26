---
title:   Nested- support for editing multiple languages files in jedit
author: "Romain François"
date:  2009-02-02
slug:  Nested--new-jedit-plugin
tags:  [ "jedit", "nested" ]
---
<div class="post-content">
<p>jedit usually makes a good job of editing files with various languages in it, for example jsp files contain some java code, <a href="http://www.stat.uni-muenchen.de/~leisch/Sweave/">sweave</a> files contain some R code, <a href="http://www.rforge.net/brew/">brew</a> templates contain R code, R code might contain XML code (if you use the <a href="http://r-forge.r-project.org/projects/r4x/">R4X</a> package, but we'll get to this one some other time). Unfortunately, because jedit uses the same color styles for all languages, you don't get so much of a visual aid to tell you that you switched languages, enters <code>Nested</code></p>

<p><code>Nested</code> is a simple jedit plugin that paints the background of a code chunk differently if this code is not coming from the same mode as the mode of the buffer, and the color is left to the user's choice. Here is an example with some java code within a JSP file, the pink background around the java statement comes from the Nested plugin.</p>

<img src="/public/posts/nested/jspjava.png"><p>The colours are controlled by a file residing on the plugin directory that looks like this :</p> 

<pre style="border:1px solid gray">
html,css,#eeeeee
jaxx,java,#ccff99
jaxx,xml,#ffffff
jsp,java,#fff2ff
</pre>

<p>but you can also use the Nested dockable window to control things</p>

<div style="text-align:center"><img src="/public/posts/nested/nesteddock.png" alt="nesteddock.png" title="nesteddock.png, fév. 2009"></div>

<p>Java code will appear in pink inside a jsp file, java code will appear green inside jaxx files, ... and you can click on the colour if you want to change it to something else</p>

<p>When you open a file that contains sub-languages, an entry will automatically be inserted in the settings if it does not exist yet, in that case, the colour used is the same as the background color of the view, so that by default nothing changes.</p>
</div>
