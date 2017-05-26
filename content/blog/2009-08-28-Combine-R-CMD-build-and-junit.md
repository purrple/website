---
title:   Combine R CMD build and junit
author: "Romain François"
date:  2009-08-28
slug:  Combine-R-CMD-build-and-junit
tags:  [ "ant", "java", "junit", "R" ]
---
<div class="post-content">
<p>This is a post in the series <em>Mixing R CMD build and ant</em>. Previous posts have shown how to <a href="/index.php?post/2009/03/26/Hello-Java-World">compile the java code that lives in the src directory of a package</a> and how to <a href="/index.php?post/2009/03/27/Document-java-software-with-%22R-CMD-build%22%2C-ant%2C-and-javadoc">document this code using javadoc</a>. </p>

<p>This post tackles the problem of unit testing of the java functionality that is shipped as part of an R package. Java has several unit test platforms, we will use <a href="http://www.junit.org/">junit</a> here, but similar things could be done with other systems such as testng, ...</p>

<p>The helloJavaWorld package now looks like this :</p>

<pre>
.
|-- DESCRIPTION
|-- NAMESPACE
|-- R
|   |-- helloJavaWorld.R
|   `-- onLoad.R
|-- inst
|   |-- doc
|   |   |-- helloJavaWorld.Rnw
|   |   |-- helloJavaWorld.pdf
|   |   `-- helloJavaWorld.tex
|   `-- java
|       |-- hellojavaworld-tests.jar
|       `-- hellojavaworld.jar
|-- man
|   `-- helloJavaWorld.Rd
`-- src
    |-- Makevars
    |-- build.xml
    |-- junit
    |   `-- HelloJavaWorld_Test.java
    |-- lib
    |   `-- junit-4.7.jar
    `-- src
        `-- HelloJavaWorld.java

9 directories, 15 files
</pre>

<p>We have added the src/lib directory that contains the junit library and the HelloJavaWorld_Test.java that contain a simple class with a unit test</p>

<iframe src="/public/posts/hellojavaworld/hellojavaworld.html" frameborder="1" width="500" height="250"></iframe>

<p>And the ant build file has been changed in order to </p>
<ul>
<li> build the junit test cases, see the <strong>build-testcases</strong> target</li>
<li> run the unit tests, see the <strong>test</strong> target</li>
<li> create nice html reports, see the <strong>report</strong> target</li>
</ul>
<iframe src="/public/posts/hellojavaworld/build.html" frameborder="1" width="500" height="500"></iframe>

<p>The package can be downloaded <a href="/public/posts/hellojavaworld/helloJavaWorld_0.0-9.tar.gz">here</a> </p>

<p>Coming next, handling of dependencies between java code that lives in different R packages</p>
</div>
