---
title:   a "hello world" miner for the biocep workbench
author: "Romain François"
date:  2009-02-07
slug:  a-hello-world-visual-miner-for-the-biocep-workbench
---
<div class="post-content">
<p><q><em>JGraph X is the next generation of Java Swing Diagramming Library, factoring in 7 years of architectural improvements into a clean, concise design...</em></q> See the rest of the quote in <a href="http://www.jgraph.com/jgraphx.html">jgraphx</a> homepage</p>

<p>This is an example on using jgraphx as a plugin to the <a href="">biocep workbench</a>, we are just going to integrate the hello world example from jgraphx as a view of the workbench. I am hoping people will find this useful and more ideas will come later. Here is a screenshot: </p>

<img src="/public/posts/jgraphx/Screenshot_m.jpg" alt="Screenshot.png" style="margin: 0 auto; display: block;" title="Screenshot.png, fév. 2009"><p>As you might guess from the screenshot, this is not really useful and does not do anything apart from being able to move things around. jgraphx has more examples, and apparently you can use any swing component as a renderer to a graph vertex, so there is no limit to what can be achieved ... </p>

<p>The project looks like this: </p>

<pre>
.
|-- build.properties
|-- build.xml
|-- descriptor.xml
|-- lib
|   |-- dt.jar
|   |-- jaxx-runtime.jar
|   |-- jaxx-swing.jar
|   |-- jaxxc.jar
|   `-- jgraphx.jar
`-- src
    `-- com
        `-- addictedtor
            `-- workbench
                `-- plugin
                    `-- jgraphx
                        `-- HelloWorld.java

7 directories, 9 files
</pre>

<p>and the <code>build.*</code> files looks pretty much the same as in this <a href="/index.php?post/2009/02/04/Tutorial%3A-A-simple-biocep-plugin-using-JAXX">previous tutorial</a>, except this time we won't use jaxx for the user interface because the swing is not a pain when it comes to hello world. The <code>HelloWorld.java</code> file looks like this: </p>. 


<pre><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   1 </font></span><font color="#009966"><strong>package</strong></font> com.addictedtor.workbench.plugin.jgraphx ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   2 </font></span>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   3 </font></span><font color="#009966"><strong>import</strong></font> com.mxgraph.swing.mxGraphComponent;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   4 </font></span><font color="#009966"><strong>import</strong></font> com.mxgraph.view.mxGraph;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">   5 </font></span>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   6 </font></span><font color="#009966"><strong>import</strong></font> org.kchine.r.workbench.RGui;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   7 </font></span><font color="#009966"><strong>import</strong></font> java.awt.BorderLayout ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   8 </font></span><font color="#009966"><strong>import</strong></font> javax.swing.JPanel ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   9 </font></span>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">  10 </font></span><font color="#006699"><strong>public</strong></font> <font color="#0099ff"><strong>class</strong></font> HelloWorld <font color="#006699"><strong>extends</strong></font> JPanel <font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  11 </font></span>  
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  12 </font></span>  <font color="#006699"><strong>private</strong></font> RGui rgui ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  13 </font></span>  
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  14 </font></span>  <font color="#006699"><strong>public</strong></font> <font color="#ff0033">HelloWorld</font><font color="#000000"><strong>(</strong></font>RGui rgui<font color="#000000"><strong>)</strong></font><font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">  15 </font></span>    <font color="#cc00cc">super</font><font color="#000000"><strong>(</strong></font> <font color="#006699"><strong>new</strong></font> <font color="#ff0033">BorderLayout</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>)</strong></font> ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  16 </font></span>    <font color="#cc00cc">this</font>.rgui <font color="#000000"><strong>=</strong></font> rgui ;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  17 </font></span>    
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  18 </font></span>    mxGraph graph <font color="#000000"><strong>=</strong></font> <font color="#006699"><strong>new</strong></font> <font color="#ff0033">mxGraph</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  19 </font></span>    Object parent <font color="#000000"><strong>=</strong></font> graph.<font color="#ff0033">getDefaultParent</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">  20 </font></span>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  21 </font></span>    graph.<font color="#ff0033">getModel</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>.<font color="#ff0033">beginUpdate</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  22 </font></span>    <font color="#006699"><strong>try</strong></font> <font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  23 </font></span>       Object v1 <font color="#000000"><strong>=</strong></font> graph.<font color="#ff0033">insertVertex</font><font color="#000000"><strong>(</strong></font>parent, <font color="#cc00cc">null</font>, <font color="#ff00cc">"</font><font color="#ff00cc">Hello</font><font color="#ff00cc">"</font>, 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  24 </font></span>         <font color="#ff0000">20</font>, <font color="#ff0000">20</font>, <font color="#ff0000">80</font>, <font color="#ff0000">30</font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">  25 </font></span>       Object v2 <font color="#000000"><strong>=</strong></font> graph.<font color="#ff0033">insertVertex</font><font color="#000000"><strong>(</strong></font>parent, <font color="#cc00cc">null</font>, <font color="#ff00cc">"</font><font color="#ff00cc">World!</font><font color="#ff00cc">"</font>,
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  26 </font></span>         <font color="#ff0000">240</font>, <font color="#ff0000">150</font>, <font color="#ff0000">80</font>, <font color="#ff0000">30</font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  27 </font></span>       graph.<font color="#ff0033">insertEdge</font><font color="#000000"><strong>(</strong></font>parent, <font color="#cc00cc">null</font>, <font color="#ff00cc">"</font><font color="#ff00cc">Edge</font><font color="#ff00cc">"</font>, v1, v2<font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  28 </font></span>    <font color="#000000"><strong>}</strong></font> <font color="#006699"><strong>finally</strong></font> <font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  29 </font></span>       graph.<font color="#ff0033">getModel</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>.<font color="#ff0033">endUpdate</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">  30 </font></span>    <font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  31 </font></span>    
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  32 </font></span>    <font color="#ff0033">add</font><font color="#000000"><strong>(</strong></font><font color="#006699"><strong>new</strong></font> <font color="#ff0033">mxGraphComponent</font><font color="#000000"><strong>(</strong></font>graph<font color="#000000"><strong>)</strong></font>, BorderLayout.CENTER <font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  33 </font></span>  <font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  34 </font></span>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">  35 </font></span><font color="#000000"><strong>}</strong></font>
</font></pre>


<p>Here is the <a href="/public/posts/jgraphx/biocep-jgraphx.tar.gz">source of the plugin</a> and a <a href="/public/posts/jgraphx/jgx.zip">zip</a> you can deploy in your <code>RWorkbench</code> directory to start dragging around. </p>
</div>
