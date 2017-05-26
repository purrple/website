---
title:   R capable version of ant
author: "Romain François"
date:  2009-09-02
slug:  R-capable-version-of-ant
tags:  [ "ant", "java", "R" ]
---
<div class="post-content">
<p><a href="http://ant.apache.org/">ant</a> is an amazing build tool. I have been using ant for some time to build the java code that lives inside the src directories of my R packages, see <a href="/index.php?post/2009/03/26/Hello-Java-World">this post</a> for example. </p>

<p>The drawbacks of this approach are : </p>
<ul>
<li>that it assumes ant is available on the system that builds the package</li>
<li>You cannot use R code within the ant build script</li>
</ul>
<p>The ant package for R is developed to solve these two issues. The package is source-controlled in r-forge as part of the <a href="http://r-forge.r-project.org/projects/orchestra/">orchestra project</a></p>

<p>Once installed, you find an <code>ant.R</code> script in the <code>exec</code> directory of the package. This script is pretty similar to the usual shell script that starts ant, but it sets it so that it can use R with the following additional tasks </p>

<ul>
<li>
<strong>&lt;r-run&gt;</strong> : to run arbitrary R code</li>
<li>
<strong>&lt;r-set&gt;</strong> : to set a property of the current project with the result of an R expression</li>
</ul>
<p>Here is an example build file that demonstrate how to use these tasks</p>

<iframe src="/public/posts/ant/ant-build.html" width="500" height="300" frameborder="1"></iframe>

<p>Here is what happens when we call the R special version of ant with this build script </p>

<pre>
$ `Rscript -e "cat( system.file( 'exec', 'ant.R', package = 'ant') )"`
Buildfile: build.xml

test:
     [echo] 
     [echo]   	R home        : /usr/local/lib/R
     [echo]   	R version     : R version 2.10.0 Under development (unstable) (2009-08-05 r49067)
     [echo]   	rJava home    : /usr/local/lib/R/library/rJava
     [echo]   	rJava version : 0.7-1
     [echo]  

BUILD SUCCESSFUL
Total time: 1 second
</pre>
</div>
