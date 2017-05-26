---
title:   new R package - ant
author: "Romain François"
date:  2009-09-08
slug:  new-R-package---ant
tags:  [ "ant", "CRAN", "java", "R" ]
---
<div class="post-content">
<p>The ant package has been released to CRAN yesterday. As discussed in previous posts in this blog (<a href="/index.php?post/2009/09/02/R-capable-version-of-ant">here</a> and <a href="/index.php?post/2009/09/03/update-on-ant-package">here</a>), the ant R package provides an R-aware version of the <a href="http://ant.apache.org/">ant</a> build tool from the apache project. </p>

<p>The package contains an R script that can be used to invoke ant with enough plumbing so that it can use R code during the build process. Calling the script is further simplified with the <code>ant</code> function included in the package. </p>

<pre>
$ Rscript -e "ant::ant()"
</pre>

<p>The simplest way to take advantage of this package is to add it to the Depends list of yours, include a java source tree somewhere in your package tree (most likely somewhere in the inst tree) with a build.xml file, and include a configure and configure.win script at the root of the package that contains something like this: </p>

<pre>
#!/bin/sh

cd inst/java_src
"${R_HOME}/bin/Rscript" -e "ant::ant()"
cd ../..
</pre>

<p>This will be further illustrated with the demo package <code>helloJavaWorld</code> in future posts</p>
</div>
