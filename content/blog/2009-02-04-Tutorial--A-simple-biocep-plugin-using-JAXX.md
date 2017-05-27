---
title:   Tutorial- A simple biocep plugin using JAXX
author: "Romain François"
date:  2009-02-04
slug:  Tutorial--A-simple-biocep-plugin-using-JAXX
tags:  [ "jaxx" ]
---
<div class="post-content">
<style type="text/css">
pre{
  border: 1px solid black ;
  font-size: x-small !important ;
}
</style>
<h2>Background</h2>

<p>Although not being documented yet, making plugins for the <a href="http://biocep-distrib.r-forge.r-project.org/">biocep workbench</a> is easy (well if you are familiar with Swing). This tutorial presents the making of a really simple plugin, although not using swing directly for the user interface but using <a href="http://www.jaxxframework.org/wiki/Main_Page">jaxx</a> to generate the appropriate verbose swing code. JAXX is a way to make swing user interfaces using XML tags to describe the user interface structure. This <a href="http://today.java.net/pub/a/today/2006/03/30/introducing-jaxx.html">article</a> will get you started on the concept of jaxx. </p>

<h2>The application</h2>

<p>The application we are demonstrating here is really simple and may not be useful beyond getting started at making other plugins for biocep. It will add a single view into the workbench allowing to retrieve data from <a href="http://finance.yahoo.com/">yahoo finance</a> using the function <a href="http://finzi.psych.upenn.edu/R/library/tseries/html/get.hist.quote.html"><code>get.hist.quote</code></a> from the beginning of a year to today, and display the result in a graphical device. This will look something like that: </p>

<a href="/public/posts/workbenchplugin/Screenshot.png">
<img src="/public/posts/workbenchplugin/Screenshot_m.jpg" alt="Screenshot.png" style="margin: 0 auto; display: block;" title="Screenshot.png, fév. 2009"></a>

<h2>Structure of the plugin</h2>

<p>A workbench plugin is more or less just any java class that takes an <code>RGui</code> interface and does something with it. Here is how I've structured the plugin so that I can build and install using <code>ant</code>. 
                      
</p>
<pre>
$ tree
.
|-- build.properties
|-- build.xml
|-- descriptor.xml
|-- lib
|   |-- dt.jar
|   |-- jaxx-runtime.jar
|   |-- jaxx-swing.jar
|   `-- jaxxc.jar
`-- src
    `-- com
        `-- addictedtor
            `-- workbench
                `-- plugin
                    `-- simple
                        |-- SimplePlugin.jaxx
                        `-- SimplePlugin.jaxxscript
7 directories, 10 files
</pre>

<h3>build.properties</h3>

<p>The <code>build.properties</code> file contains some properties to describe to ant where the workbench is installed and where we should install the plugin. Here is how it looks on my system: </p>

<pre>
install.dir=/home/romain/RWorkbench/plugins
biocep.dir=/opt/biocep
biocep.jar=biocep.jar
</pre>

<h3>The build.xml file</h3>

<p>The <a href="/public/posts/workbenchplugin/build.xml">build.xml</a> 
is a standard ant build file with a set of targets to compile the plugin, 
create a zip for distribution and install the plugin in the installation directory 
(as indicated in the build.properties file). Let's take a look at the 
steps specifically involving jaxx. To compile jaxx files in ant, you need
to define an additional ant task </p>

<pre style="border: solid 1px black ; font-size:small;"><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">24 </font></span>  <font color="#0000ff">&lt;</font><font color="#0000ff">target</font><font color="#0000ff"> </font><font color="#0000ff">name</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">defineAntTask</font><font color="#ff00cc">"</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">25 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">taskdef</font><font color="#0000ff"> </font><font color="#0000ff">name</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">jaxxc</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">classname</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">jaxx.JaxxcAntTask</font><font color="#ff00cc">"</font><font color="#0000ff"> </font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">26 </font></span><font color="#0000ff">  </font><font color="#0000ff">  </font><font color="#0000ff">  </font><font color="#0000ff">classpath</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">lib/jaxxc.jar</font><font color="#ff00cc">"</font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">27 </font></span>  <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">target</font><font color="#0000ff">&gt;</font>
</font></pre>

<p>and then use this task to compile the jaxx files in your source tree, here we are 
compiling the <code>SimplePlugin.jaxx</code> file. After that, classes 
have been generated and you may compile the java files 
using the standard <code>javac</code> ant task.</p>

<pre style="border: solid 1px black ; font-size:small;"><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">31 </font></span>  <font color="#0000ff">&lt;</font><font color="#0000ff">target</font><font color="#0000ff"> </font><font color="#0000ff">name</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">compile</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">depends</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">clean,defineAntTask</font><font color="#ff00cc">"</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">32 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">mkdir</font><font color="#0000ff"> </font><font color="#0000ff">dir</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">build/classes</font><font color="#ff00cc">"</font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">33 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">jaxxc</font><font color="#0000ff"> </font><font color="#0000ff">srcdir</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">src</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">keepJavaFiles</font><font color="#0000ff">=</font><font color="#ff00cc">'</font><font color="#ff00cc">yes</font><font color="#ff00cc">'</font><font color="#0000ff"> </font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">34 </font></span><font color="#0000ff">  </font><font color="#0000ff">  </font><font color="#0000ff">  </font><font color="#0000ff">destdir</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">build/classes</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">classpath</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">${full.biocep.jar}</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">35 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">javac</font><font color="#0000ff"> </font><font color="#0000ff">srcdir</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">src</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">destdir</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">build/classes</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">source</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">1.5</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">target</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">1.5</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">&gt;</font> 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">36 </font></span>      <font color="#0000ff">&lt;</font><font color="#0000ff">classpath</font><font color="#0000ff"> </font><font color="#0000ff">refid</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">simple.class.path</font><font color="#ff00cc">"</font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">37 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">javac</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">38 </font></span>  <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">target</font><font color="#0000ff">&gt;</font>
</font></pre>

<p>Finally, we can make the jar file. I usually prefer 
one jar file per biocep plugin, so I unjar 
the content of the jaxx runtime classes to jar it 
back into a single jar file</p>

<pre style="border: solid 1px black ; font-size:small;"><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">42 </font></span>  <font color="#0000ff">&lt;</font><font color="#0000ff">target</font><font color="#0000ff"> </font><font color="#0000ff">name</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">build</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">depends</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">compile</font><font color="#ff00cc">"</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">43 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">mkdir</font><font color="#0000ff"> </font><font color="#0000ff">dir</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">build/lib</font><font color="#ff00cc">"</font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">44 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">unjar</font><font color="#0000ff"> </font><font color="#0000ff">src</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">lib/jaxx-runtime.jar</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">dest</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">build/classes</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">45 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">jar</font><font color="#0000ff"> </font><font color="#0000ff">jarfile</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">build/lib/simple.jar</font><font color="#ff00cc">"</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">46 </font></span>      <font color="#0000ff">&lt;</font><font color="#0000ff">fileset</font><font color="#0000ff"> </font><font color="#0000ff">dir</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">build/classes</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">47 </font></span>      <font color="#0000ff">&lt;</font><font color="#0000ff">fileset</font><font color="#0000ff"> </font><font color="#0000ff">dir</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">src</font><font color="#ff00cc">"</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">48 </font></span>        <font color="#0000ff">&lt;</font><font color="#0000ff">include</font><font color="#0000ff"> </font><font color="#0000ff">name</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">*.xml</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">49 </font></span>        <font color="#0000ff">&lt;</font><font color="#0000ff">include</font><font color="#0000ff"> </font><font color="#0000ff">name</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">**/*.props</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">50 </font></span>        <font color="#0000ff">&lt;</font><font color="#0000ff">include</font><font color="#0000ff"> </font><font color="#0000ff">name</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">**/*.properties</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">51 </font></span>        <font color="#0000ff">&lt;</font><font color="#0000ff">include</font><font color="#0000ff"> </font><font color="#0000ff">name</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">**/*.html</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">52 </font></span>        <font color="#0000ff">&lt;</font><font color="#0000ff">include</font><font color="#0000ff"> </font><font color="#0000ff">name</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">**/*.gif</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">53 </font></span>        <font color="#0000ff">&lt;</font><font color="#0000ff">include</font><font color="#0000ff"> </font><font color="#0000ff">name</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">**/*.png</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">54 </font></span>      <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">fileset</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">55 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">jar</font><font color="#0000ff">&gt;</font>  
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">56 </font></span>  <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">target</font><font color="#0000ff">&gt;</font>
</font></pre>

<h3>The descriptor.xml file</h3>

<p>The <code>descriptor.xml</code> file is used by the 
workbench to load the plugin, it identifies the 
plugin main class</p>

<pre style="border: solid 1px black ; font-size:small;"><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   1 </font></span><font color="#0000ff">&lt;</font><font color="#0000ff">plugin</font><font color="#0000ff">&gt;</font>  
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   2 </font></span>  <font color="#0000ff">&lt;</font><font color="#0000ff">view</font><font color="#0000ff"> </font><font color="#0000ff">name</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">Simple</font><font color="#ff00cc"> </font><font color="#ff00cc">Plugin</font><font color="#ff00cc">"</font><font color="#0000ff"> </font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   3 </font></span><font color="#0000ff">  </font><font color="#0000ff">  </font><font color="#0000ff">class</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">com.addictedtor.workbench.plugin.simple.SimplePlugin</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   4 </font></span><font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">plugin</font><font color="#0000ff">&gt;</font>
</font></pre>

<p>We are pointing the workbench to the class <code>com.addictedtor.workbench.plugin.simple.SimplePlugin</code>
and the workbench will instanciate one object of the 
class using the constructor that takes an <code>RGui</code>
interface, through which we will communicate with R.</p>

<h3>The SimplePlugin.* files</h3>

<p>The <code>SimplePlugin.jaxx</code> file contains the description
of the user interface using XML and the <code>SimplePlugin.jaxxscript</code> 
file contains java code to implement some of the logic of 
the application</p>

<p>If you are already familiar with Swing, it does not 
take too much effort to grab what is going on with this jaxx file</p>

<pre style="border: solid 1px black ; font-size:small;"><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   1 </font></span><font color="#0000ff">&lt;</font><font color="#0000ff">JPanel</font><font color="#0000ff"> </font><font color="#0000ff">layout</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">{new</font><font color="#ff00cc"> </font><font color="#ff00cc">BorderLayout()}</font><font color="#ff00cc">"</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   2 </font></span>    
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   3 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">script</font><font color="#0000ff"> </font><font color="#0000ff">source</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">SimplePlugin.jaxxscript</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   4 </font></span>    
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">   5 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">JPanel</font><font color="#0000ff"> </font><font color="#0000ff">constraints</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">BorderLayout.NORTH</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">id</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">toolbar</font><font color="#ff00cc">"</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   6 </font></span>        <font color="#0000ff">&lt;</font><font color="#0000ff">JComboBox</font><font color="#0000ff"> </font><font color="#0000ff">id</font><font color="#0000ff"> </font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">instruments</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   7 </font></span>            <font color="#0000ff">&lt;</font><font color="#0000ff">item</font><font color="#0000ff"> </font><font color="#0000ff">value</font><font color="#0000ff">=</font><font color="#ff00cc">'</font><font color="#ff00cc">{null}</font><font color="#ff00cc">'</font><font color="#0000ff"> </font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   8 </font></span><font color="#0000ff">    </font><font color="#0000ff">    </font><font color="#0000ff">    </font><font color="#0000ff">    </font><font color="#0000ff">label</font><font color="#0000ff">=</font><font color="#ff00cc">'</font><font color="#ff00cc">Select</font><font color="#ff00cc"> </font><font color="#ff00cc">an</font><font color="#ff00cc"> </font><font color="#ff00cc">instrument</font><font color="#ff00cc">'</font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   9 </font></span>            <font color="#0000ff">&lt;</font><font color="#0000ff">item</font><font color="#0000ff"> </font><font color="#0000ff">value</font><font color="#0000ff">=</font><font color="#ff00cc">'</font><font color="#ff00cc">Nasdaq</font><font color="#ff00cc">'</font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">  10 </font></span>            <font color="#0000ff">&lt;</font><font color="#0000ff">item</font><font color="#0000ff"> </font><font color="#0000ff">value</font><font color="#0000ff">=</font><font color="#ff00cc">'</font><font color="#ff00cc">Dow</font><font color="#ff00cc">'</font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  11 </font></span>            <font color="#0000ff">&lt;</font><font color="#0000ff">item</font><font color="#0000ff"> </font><font color="#0000ff">value</font><font color="#0000ff">=</font><font color="#ff00cc">'</font><font color="#ff00cc">SP</font><font color="#ff00cc"> </font><font color="#ff00cc">500</font><font color="#ff00cc">'</font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  12 </font></span>            <font color="#0000ff">&lt;</font><font color="#0000ff">item</font><font color="#0000ff"> </font><font color="#0000ff">value</font><font color="#0000ff">=</font><font color="#ff00cc">'</font><font color="#ff00cc">CAC</font><font color="#ff00cc"> </font><font color="#ff00cc">40</font><font color="#ff00cc">'</font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  13 </font></span>            <font color="#0000ff">&lt;</font><font color="#0000ff">item</font><font color="#0000ff"> </font><font color="#0000ff">value</font><font color="#0000ff">=</font><font color="#ff00cc">'</font><font color="#ff00cc">FTSE</font><font color="#ff00cc"> </font><font color="#ff00cc">100</font><font color="#ff00cc">'</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  14 </font></span>            <font color="#0000ff">&lt;</font><font color="#0000ff">item</font><font color="#0000ff"> </font><font color="#0000ff">value</font><font color="#0000ff">=</font><font color="#ff00cc">'</font><font color="#ff00cc">DAX</font><font color="#ff00cc">'</font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">  15 </font></span>        <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">JComboBox</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  16 </font></span>        <font color="#0000ff">&lt;</font><font color="#0000ff">JLabel</font><font color="#0000ff"> </font><font color="#0000ff">text</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">start</font><font color="#ff00cc"> </font><font color="#ff00cc">year</font><font color="#ff00cc"> </font><font color="#ff00cc">:</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  17 </font></span>        <font color="#0000ff">&lt;</font><font color="#0000ff">JTextField</font><font color="#0000ff"> </font><font color="#0000ff">id</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">startyear</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">text</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">2003</font><font color="#ff00cc">"</font><font color="#0000ff"> </font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  18 </font></span><font color="#0000ff">    </font><font color="#0000ff">    </font><font color="#0000ff">    </font><font color="#0000ff">onActionPerformed</font><font color="#0000ff">=</font><font color="#ff00cc">'</font><font color="#ff00cc">go()</font><font color="#ff00cc">'</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  19 </font></span>        <font color="#0000ff">&lt;</font><font color="#0000ff">JButton</font><font color="#0000ff"> </font><font color="#0000ff">id</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">submit</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">text</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">go</font><font color="#ff00cc">"</font><font color="#0000ff"> </font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">  20 </font></span><font color="#0000ff">    </font><font color="#0000ff">    </font><font color="#0000ff">    </font><font color="#0000ff">onActionPerformed</font><font color="#0000ff">=</font><font color="#ff00cc">'</font><font color="#ff00cc">go()</font><font color="#ff00cc">'</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  21 </font></span>        
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  22 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">JPanel</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  23 </font></span>    
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  24 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">JScrollPane</font><font color="#0000ff"> </font><font color="#0000ff">constraints</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">BorderLayout.CENTER</font><font color="#ff00cc">"</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">  25 </font></span>        <font color="#0000ff">&lt;</font><font color="#0000ff">org</font><font color="#0000ff">.</font><font color="#0000ff">kchine</font><font color="#0000ff">.</font><font color="#0000ff">r</font><font color="#0000ff">.</font><font color="#0000ff">workbench</font><font color="#0000ff">.</font><font color="#0000ff">views</font><font color="#0000ff">.</font><font color="#0000ff">PDFPanel</font><font color="#0000ff"> </font><font color="#0000ff">id</font><font color="#0000ff"> </font><font color="#0000ff">=</font><font color="#0000ff"> </font><font color="#ff00cc">"</font><font color="#ff00cc">pdf</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  26 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">JScrollPane</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  27 </font></span>    
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  28 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">JPanel</font><font color="#0000ff"> </font><font color="#0000ff">constraints</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">BorderLayout.SOUTH</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">id</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">statusbar</font><font color="#ff00cc">"</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  29 </font></span>      <font color="#0000ff">&lt;</font><font color="#0000ff">JLabel</font><font color="#0000ff"> </font><font color="#0000ff">id</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">info</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff">text</font><font color="#0000ff"> </font><font color="#0000ff">=</font><font color="#0000ff"> </font><font color="#ff00cc">"</font><font color="#ff00cc"> </font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">  30 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">JPanel</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  31 </font></span>    
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  32 </font></span><font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">JPanel</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  33 </font></span>
</font></pre>

<p>The <code>SimplePlugin.jaxx</code> file complements the jaxx code 
by implementing a set of java methods, including the constructor
for the class which needs to take an <code>RGui</code> interface
as its only parameter</p>
     
<pre style="border: solid 1px black ; font-size:small;"><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000"> 8 </font></span><font color="#006699"><strong>public</strong></font> <font color="#ff0033">SimplePlugin</font><font color="#000000"><strong>(</strong></font> RGui rgui<font color="#000000"><strong>)</strong></font><font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000"> 9 </font></span>    <font color="#cc00cc">this</font>.rgui <font color="#000000"><strong>=</strong></font> rgui ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">10 </font></span>    <font color="#ff0033">initMap</font><font color="#000000"><strong>(</strong></font> <font color="#000000"><strong>)</strong></font> ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">11 </font></span>    <font color="#ff0033">loadRPackage</font><font color="#000000"><strong>(</strong></font> <font color="#ff00cc">"</font><font color="#ff00cc">tseries</font><font color="#ff00cc">"</font> <font color="#000000"><strong>)</strong></font>; 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">12 </font></span><font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">13 </font></span>
</font></pre>

<p>... a simple utility method to load an R package. We can see 
here of of the main design decision about the RGui interface, the instance
of R that is running on the background may only do one 
thing at a time, which is why when you want to do something with it, you
need to <code>lock</code> it, do whatever, and then <code>unlock</code> it</p>

<pre style="border: solid 1px black ; font-size:small;"><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">14 </font></span><font color="#006699"><strong>public</strong></font> <font color="#0099ff"><strong>void</strong></font> <font color="#ff0033">loadRPackage</font><font color="#000000"><strong>(</strong></font> String pack <font color="#000000"><strong>)</strong></font><font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">15 </font></span>    <font color="#006699"><strong>try</strong></font><font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">16 </font></span>        rgui.<font color="#ff0033">getRLock</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>.<font color="#ff0033">lock</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font> ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">17 </font></span>        rgui.<font color="#ff0033">getR</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>.<font color="#ff0033">evaluate</font><font color="#000000"><strong>(</strong></font> <font color="#ff00cc">"</font><font color="#ff00cc">require(</font><font color="#ff00cc"> </font><font color="#ff00cc">'tseries'</font><font color="#ff00cc"> </font><font color="#ff00cc">)</font><font color="#ff00cc">"</font> <font color="#000000"><strong>)</strong></font> ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">18 </font></span>    <font color="#000000"><strong>}</strong></font> <font color="#006699"><strong>catch</strong></font><font color="#000000"><strong>(</strong></font>Exception e<font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">19 </font></span>        JOptionPane.<font color="#ff0033">showMessageDialog</font><font color="#000000"><strong>(</strong></font><font color="#cc00cc">this</font>, 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">20 </font></span>            <font color="#ff00cc">"</font><font color="#ff00cc">Please</font><font color="#ff00cc"> </font><font color="#ff00cc">install</font><font color="#ff00cc"> </font><font color="#ff00cc">the</font><font color="#ff00cc"> </font><font color="#ff00cc">tseries</font><font color="#ff00cc"> </font><font color="#ff00cc">package</font><font color="#ff00cc">"</font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">21 </font></span>    <font color="#000000"><strong>}</strong></font> <font color="#006699"><strong>finally</strong></font><font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">22 </font></span>        rgui.<font color="#ff0033">getRLock</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>.<font color="#ff0033">unlock</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font> ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">23 </font></span>    <font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">24 </font></span><font color="#000000"><strong>}</strong></font>
</font></pre>

<p>Finally, the <code>go</code> function does the actual work of 
retrieving data from yahoo about the chosen instrument since the 
start of the chosen year, and then plot the result in the PDF panel</p>

<pre style="border: solid 1px black ; font-size:small;"><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">36 </font></span><font color="#006699"><strong>public</strong></font> <font color="#0099ff"><strong>void</strong></font> <font color="#ff0033">go</font><font color="#000000"><strong>(</strong></font> <font color="#000000"><strong>)</strong></font><font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">37 </font></span>    Object instrument <font color="#000000"><strong>=</strong></font> instruments.<font color="#ff0033">getSelectedItem</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font> ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">38 </font></span>    <font color="#006699"><strong>if</strong></font><font color="#000000"><strong>(</strong></font> instrument <font color="#000000"><strong>=</strong></font><font color="#000000"><strong>=</strong></font> <font color="#cc00cc">null</font> <font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">39 </font></span>      JOptionPane.<font color="#ff0033">showMessageDialog</font><font color="#000000"><strong>(</strong></font><font color="#cc00cc">this</font>, <font color="#ff00cc">"</font><font color="#ff00cc">Please</font><font color="#ff00cc"> </font><font color="#ff00cc">select</font><font color="#ff00cc"> </font><font color="#ff00cc">an</font><font color="#ff00cc"> </font><font color="#ff00cc">instrument</font><font color="#ff00cc">"</font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">40 </font></span>      <font color="#006699"><strong>return</strong></font> ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">41 </font></span>    <font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">42 </font></span>  
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">43 </font></span>    <font color="#0099ff"><strong>int</strong></font> start <font color="#000000"><strong>=</strong></font> 2003 ; 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">44 </font></span>    <font color="#006699"><strong>try</strong></font><font color="#000000"><strong>{</strong></font> 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">45 </font></span>        start <font color="#000000"><strong>=</strong></font> Integer.<font color="#ff0033">parseInt</font><font color="#000000"><strong>(</strong></font> startyear.<font color="#ff0033">getText</font><font color="#000000"><strong>(</strong></font> <font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>)</strong></font> ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">46 </font></span>    <font color="#000000"><strong>}</strong></font> <font color="#006699"><strong>catch</strong></font><font color="#000000"><strong>(</strong></font> Exception e <font color="#000000"><strong>)</strong></font><font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">47 </font></span>        JOptionPane.<font color="#ff0033">showMessageDialog</font><font color="#000000"><strong>(</strong></font><font color="#cc00cc">this</font>, <font color="#ff00cc">"</font><font color="#ff00cc">Invalid</font><font color="#ff00cc"> </font><font color="#ff00cc">start</font><font color="#ff00cc"> </font><font color="#ff00cc">year</font><font color="#ff00cc">"</font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">48 </font></span>        <font color="#006699"><strong>return</strong></font> ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">49 </font></span>    <font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">50 </font></span>    String ins <font color="#000000"><strong>=</strong></font> <font color="#000000"><strong>(</strong></font>String<font color="#000000"><strong>)</strong></font>map.<font color="#ff0033">get</font><font color="#000000"><strong>(</strong></font>instrument<font color="#000000"><strong>)</strong></font> ; 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">51 </font></span>    String cmd <font color="#000000"><strong>=</strong></font> 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">52 </font></span>        <font color="#ff00cc">"</font><font color="#ff00cc">x</font><font color="#ff00cc"> </font><font color="#ff00cc">=</font><font color="#ff00cc"> </font><font color="#ff00cc">get.hist.quote(instrument</font><font color="#ff00cc"> </font><font color="#ff00cc">=</font><font color="#ff00cc"> </font><font color="#ff00cc">'^</font><font color="#ff00cc">"</font> <font color="#000000"><strong>+</strong></font>   ins <font color="#000000"><strong>+</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">53 </font></span>        <font color="#ff00cc">"</font><font color="#ff00cc">',</font><font color="#ff00cc"> </font><font color="#ff00cc">start</font><font color="#ff00cc"> </font><font color="#ff00cc">=</font><font color="#ff00cc"> </font><font color="#ff00cc">'</font><font color="#ff00cc">"</font> <font color="#000000"><strong>+</strong></font>  
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">54 </font></span>        start <font color="#000000"><strong>+</strong></font>  <font color="#ff00cc">"</font><font color="#ff00cc">-01-01',</font><font color="#ff00cc"> </font><font color="#ff00cc">quote</font><font color="#ff00cc"> </font><font color="#ff00cc">=</font><font color="#ff00cc"> </font><font color="#ff00cc">'Close'</font><font color="#ff00cc"> </font><font color="#ff00cc">)</font><font color="#ff00cc">"</font> ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">55 </font></span>    String plot <font color="#000000"><strong>=</strong></font> 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">56 </font></span>        <font color="#ff00cc">"</font><font color="#ff00cc">plot(</font><font color="#ff00cc"> </font><font color="#ff00cc">x,</font><font color="#ff00cc"> </font><font color="#ff00cc">ylab</font><font color="#ff00cc"> </font><font color="#ff00cc">=</font><font color="#ff00cc"> </font><font color="#ff00cc">'</font><font color="#ff00cc">"</font><font color="#000000"><strong>+</strong></font> instrument <font color="#000000"><strong>+</strong></font> <font color="#ff00cc">"</font><font color="#ff00cc">'</font><font color="#ff00cc"> </font><font color="#ff00cc">)</font><font color="#ff00cc">"</font> ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">57 </font></span>    <font color="#006699"><strong>try</strong></font><font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">58 </font></span>      rgui.<font color="#ff0033">getRLock</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>.<font color="#ff0033">lock</font><font color="#000000"><strong>(</strong></font> <font color="#000000"><strong>)</strong></font> ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">59 </font></span>      rgui.<font color="#ff0033">getR</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>.<font color="#ff0033">evaluate</font><font color="#000000"><strong>(</strong></font>cmd<font color="#000000"><strong>)</strong></font> ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">60 </font></span>      pdf.<font color="#ff0033">setPDFContent</font><font color="#000000"><strong>(</strong></font> rgui.<font color="#ff0033">getR</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>.<font color="#ff0033">getPdf</font><font color="#000000"><strong>(</strong></font> plot , 800, 400<font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">61 </font></span>    <font color="#000000"><strong>}</strong></font> <font color="#006699"><strong>catch</strong></font><font color="#000000"><strong>(</strong></font>Exception e<font color="#000000"><strong>)</strong></font><font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">62 </font></span>      e.<font color="#ff0033">printStackTrace</font><font color="#000000"><strong>(</strong></font> <font color="#000000"><strong>)</strong></font> ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">63 </font></span>    <font color="#000000"><strong>}</strong></font> <font color="#006699"><strong>finally</strong></font><font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">64 </font></span>      rgui.<font color="#ff0033">getRLock</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>.<font color="#ff0033">unlock</font><font color="#000000"><strong>(</strong></font> <font color="#000000"><strong>)</strong></font> ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">65 </font></span>    <font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">66 </font></span>  
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">67 </font></span><font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">68 </font></span>
</font></pre>

<h2>Perspectives</h2>

<h3>Extend JAXX to make it more R-friendly</h3>

<p>As opposed to other XML based user interfaces in java, 
Jaxx is not only restricted to swing tags and any other 
class might be included in a jaxx tree. Moreover, 
we can extend jaxx to define how to interpret 
a given tag, so with a bit of work we could 
embed R code in a gentle way into jaxx files, 
I am thinking something like that : 

</p>
<pre><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   1 </font></span><font color="#0000ff">&lt;</font><font color="#0000ff">JButton</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   2 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">action</font><font color="#0000ff"> </font><font color="#0000ff">language</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">R</font><font color="#ff00cc">"</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  3 </font></span>    <font color="#009966"><strong>cat</strong></font>( <font color="#ff00cc">"</font><font color="#ff00cc">hello</font><font color="#ff00cc"> </font><font color="#ff00cc">world</font><font color="#ff00cc">"</font> ) 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   4 </font></span>    <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">action</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">   5 </font></span><font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">JButton</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   6 </font></span>
</font></pre>

<h3>What about rgg</h3>

<p>There also is the <a href="http://www.statistik.uni-dortmund.de/useR-2008/slides/Visne+Vierlinger+Leisch+Kriegner.pdf">rgg</a>
package which has similar ideas except as far as I can see the 
nesting is done the other way, XML tags are 
embedded in R code within an <code>rgg</code> file.</p> 

<pre><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   1 </font></span><font color="#0000ff">&lt;</font><font color="#0000ff">rgg</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   2 </font></span>file = <font color="#0000ff">&lt;</font><font color="#0000ff">filechooser</font><font color="#0000ff"> </font><font color="#0000ff">label</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">CSV</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">description</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">Csv</font><font color="#ff00cc"> </font><font color="#ff00cc">Dateien</font><font color="#ff00cc">"</font><font color="#0000ff"> </font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   3 </font></span><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff">extensions</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">csv</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">fileselection-mode</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">files-only</font><font color="#ff00cc">"</font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   4 </font></span>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">   5 </font></span>myIris = read.table(file, header=<font color="#0000ff">&lt;</font><font color="#0000ff">checkbox</font><font color="#0000ff"> </font><font color="#0000ff">label</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">header</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">span</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">2</font><font color="#ff00cc">"</font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>, 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   6 </font></span>  sep=<font color="#0000ff">&lt;</font><font color="#0000ff">combobox</font><font color="#0000ff"> </font><font color="#0000ff">items</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">\t,;</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">label</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">Seperator</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">selected</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">T</font><font color="#ff00cc">"</font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>)
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   7 </font></span>summary(myIris)
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   8 </font></span><font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">rgg</font><font color="#0000ff">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   9 </font></span>
</font></pre>

<p>
the XML is processed and the script is 
transformed into an R script. One of the advantages of 
rgg though is that it defines a set of R related tags such as
<code>&lt;matrix&gt;</code> 
</p>

<h3>Files</h3>

Here is the source of the <a href="/public/posts/workbenchplugin/simple.tar.gz">plugin</a>plugin and the <a href="/public/posts/workbenchplugin/simple.zip">simple.zip</a> which you can simply unzip into your  <code>RWorkbench/plugins</code> directory.</div>
