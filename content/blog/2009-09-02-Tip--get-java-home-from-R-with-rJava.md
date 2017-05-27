---
title:   Tip- get java home from R with rJava
author: "Romain François"
date:  2009-09-02
slug:  Tip--get-java-home-from-R-with-rJava
tags:  [ "java", "R" ]
---
<div class="post-content">
<p>Assuming rJava is installed and works, it is possible to take advantage of its magic to get the path where java is installed:</p>

<pre>
$ Rscript --default-packages="methods,rJava" -e ".jinit(); .jcall( 'java/lang/System', 'S', 'getProperty', 'java.home' ) "
[1] "/opt/jdk/jre"
</pre>

<p>This is useful when you develop scripts that need to call a java program without assuming that java is on the path, or the JAVA_HOME environment variable is set, etc ...</p>
</div>
