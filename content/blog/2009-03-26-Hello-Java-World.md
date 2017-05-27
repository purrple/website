---
title:   Build java software with "R CMD build" and ant
author: "Romain François"
date:  2009-03-26
slug:  Hello-Java-World
tags:  [ "ant", "java", "R" ]
---
<div class="post-content">
<style>
pre{
 border: 1px solid black; 
 font-size: xx-small !important;
}
</style>
<p>The <a href="http://cran.r-project.org/web/packages/helloJavaWorld/index.html">helloJavaWorld</a> is a simple R package that shows how to distribute java software with an R package and communicate with it by means of the <a href="http://rosuda.org/rJava/">rJava</a> package. helloJavaWorld has a <a href="http://cran.r-project.org/web/packages/helloJavaWorld/vignettes/helloJavaWorld.pdf">vignette</a> showing the different steps involved in making such a package. </p>

<p>Basically, helloJavaWorld uses the <em>inst</em> directory of an <a href="http://cran.r-project.org/doc/manuals/R-exts.html#Package-structure">R package structure</a> to ship the jar file in which the java software is packaged.</p>

<p>This post goes a bit further and shows how we can distribute the <b>source</b> of the java software and make R compile it when we run <code>R CMD build</code>. For that we are naturally going to use the <em>src</em> part of the R package, leading to this structure: </p>

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
|       `-- hellojavaworld.jar
|-- man
|   `-- helloJavaWorld.Rd
`-- src
    |-- Makevars
    |-- build.xml
    `-- src
        `-- HelloJavaWorld.java

7 directories, 12 files
</pre>

<p>Only the <em>src</em> directory differs from the version of helloJavaWorld that is on cran. Let's have a look at the files that are in <em>src</em>: </p>

<p>helloJavaWorld.java is the same as the code we can read in helloJavaWorld's <a href="http://cran.r-project.org/web/packages/helloJavaWorld/vignettes/helloJavaWorld.pdf">vignette</a> </p>

<pre><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   1 </font></span><font color="#006699"><strong>public</strong></font> <font color="#33cc00"><strong>class</strong></font> HelloJavaWorld <font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   2 </font></span>   
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   3 </font></span>  <font color="#006699"><strong>public</strong></font> String <font color="#ff0000">sayHello</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   4 </font></span>    String result <font color="#000000"><strong>=</strong></font> <font color="#006699"><strong>new</strong></font> <font color="#ff0000">String</font><font color="#000000"><strong>(</strong></font><font color="#ff00cc">"</font><font color="#ff00cc">Hello</font><font color="#ff00cc"> </font><font color="#ff00cc">Java</font><font color="#ff00cc"> </font><font color="#ff00cc">World!</font><font color="#ff00cc">"</font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">   5 </font></span>    <font color="#006699"><strong>return</strong></font> result;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   6 </font></span>  <font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   7 </font></span>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   8 </font></span>  <font color="#006699"><strong>public</strong></font> <font color="#006699"><strong>static</strong></font> <font color="#33cc00"><strong>void</strong></font> <font color="#ff0000">main</font><font color="#000000"><strong>(</strong></font>String[] args<font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   9 </font></span>  <font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">  10 </font></span>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  11 </font></span><font color="#000000"><strong>}</strong></font> 
</font></pre>

<p>build.xml is a simple <a href="http://ant.apache.org/">ant</a> script. Ant is typically used to build java software. This build script is very simple. It defines the following targets: </p>

<ul>
<li>clean: removes the bin directory we use to store compiled class files</li>
<li>compile: compiles all java classes found in src into bin</li>
<li>build: package the java classes into the hellojavaworld.jar file, that we store in the inst/java directory to comply with the initial package structure</li>
</ul>
<pre><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   1 </font></span><font color="#0000ff">&lt;</font><font color="#0000ff">project</font><font color="#0000ff"> </font><font color="#0000ff">name</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">Hello</font><font color="#ff00cc"> </font><font color="#ff00cc">Java</font><font color="#ff00cc"> </font><font color="#ff00cc">World</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">basedir</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">.</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">default</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">build</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   2 </font></span>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   3 </font></span>  <font color="#0000ff">&lt;</font><font color="#0000ff">property</font><font color="#0000ff"> </font><font color="#0000ff">name</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">target.dir</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">value</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">../inst/java</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   4 </font></span>  
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">   5 </font></span>  <font color="#0000ff">&lt;</font><font color="#0000ff">target</font><font color="#0000ff"> </font><font color="#0000ff">name</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">clean</font><font color="#ff00cc">"</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   6 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">delete</font><font color="#0000ff"> </font><font color="#0000ff">dir</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">bin</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   7 </font></span>  <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">target</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   8 </font></span>  
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   9 </font></span>  <font color="#0000ff">&lt;</font><font color="#0000ff">target</font><font color="#0000ff"> </font><font color="#0000ff">name</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">compile</font><font color="#ff00cc">"</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">  10 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">mkdir</font><font color="#0000ff"> </font><font color="#0000ff">dir</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">bin</font><font color="#ff00cc">"</font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  11 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">javac</font><font color="#0000ff"> </font><font color="#0000ff">srcdir</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">src</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">destdir</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">bin</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  12 </font></span>  <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">target</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  13 </font></span>  
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  14 </font></span>  <font color="#0000ff">&lt;</font><font color="#0000ff">target</font><font color="#0000ff"> </font><font color="#0000ff">name</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">build</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">depends</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">compile</font><font color="#ff00cc">"</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">  15 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">jar</font><font color="#0000ff"> </font><font color="#0000ff">jarfile</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">${target.dir}/hellojavaworld.jar</font><font color="#ff00cc">"</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  16 </font></span>      <font color="#0000ff">&lt;</font><font color="#0000ff">fileset</font><font color="#0000ff"> </font><font color="#0000ff">dir</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">bin</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  17 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">jar</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  18 </font></span>  <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">target</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  19 </font></span>  
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">  20 </font></span>  
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  21 </font></span><font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">project</font><font color="#0000ff">&gt;</font>
</font></pre>

<p>Next, is the Makevars file. When an R package is built, R looks into the src directory for a Makevars file, which would typically be used to indicate how to compile the source code that is in the package. We simply use the Makevars file to launch the building and cleaning with ant, so we have a simple Makevars file: </p>

<pre><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   1 </font></span>.PHONY: all
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   2 </font></span>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   3 </font></span><font color="#02b902">clean</font><font color="#02b902">:</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   4 </font></span>    ant clean
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">   5 </font></span>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   6 </font></span><font color="#02b902">all</font><font color="#02b902">:</font> clean
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   7 </font></span>    ant build
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   8 </font></span>
</font></pre>

<p>See <a href="http://cran.r-project.org/doc/manuals/R-exts.html#Using-Makevars">Writing R extensions</a> for details on the Makevars file</p>

<p>And now we can <em>R CMD build</em> the package:</p>

<pre>
$ R CMD build helloJavaWorld
* checking for file 'helloJavaWorld/DESCRIPTION' ... OK
* preparing 'helloJavaWorld':                          
* checking DESCRIPTION meta-information ... OK         
* cleaning src                                         
ant clean                                              
Buildfile: build.xml                                   

clean:

BUILD SUCCESSFUL
Total time: 0 seconds
* installing the package to re-build vignettes
* Installing *source* package ‘helloJavaWorld’ ...
** libs                                           
ant clean                                         
Buildfile: build.xml

clean:

BUILD SUCCESSFUL
Total time: 0 seconds
ant build
Buildfile: build.xml

compile:
    [mkdir] Created dir: /home/romain/svn/helloJavaWorld/src/bin
    [javac] Compiling 1 source file to /home/romain/svn/helloJavaWorld/src/bin

build:
      [jar] Building jar: /home/romain/svn/helloJavaWorld/inst/java/hellojavaworld.jar

BUILD SUCCESSFUL
Total time: 1 second
** R
** inst
** preparing package for lazy loading
** help
*** installing help indices
 &gt;&gt;&gt; Building/Updating help pages for package 'helloJavaWorld'
     Formats: text html latex example
  helloJavaWorld                    text    html    latex   example
** building package indices ...
* DONE (helloJavaWorld)
* creating vignettes ... OK
* cleaning src
ant clean
Buildfile: build.xml

clean:
   [delete] Deleting directory /home/romain/svn/helloJavaWorld/src/bin

BUILD SUCCESSFUL
Total time: 0 seconds
* removing junk files
* checking for LF line-endings in source and make files
* checking for empty or unneeded directories
* building 'helloJavaWorld_0.0-7.tar.gz'
</pre>

<p>Download this version of helloJavaWorld: <a href="/public/posts/hellojavaworld/helloJavaWorld_0.0-7.tar.gz">helloJavaWorld_0.0-7.tar.gz</a></p>

<p>This approach relies on ant being available, which we can specify in the SystemRequirements in the DESCRIPTION file</p>

<pre>
SystemRequirements: Java (&gt;= 5.0), ant
</pre>

<p>Next time, we will see how to trick the documentation system so that it builds javadoc files</p>
</div>
