---
title:   R wrapper in open turns
author: "Romain François"
date:  2009-01-23
slug:  R-wrapper-in-open-turns
tags:  [ "openturns", "python", "R" ]
---
<div class="post-content">This is an attempt to create a wrapper for <a href="http://trac.openturns.org/">openturns</a> using R. This is based on the wrapper template called <code>wrapper_calling_shell_command</code> available with openturns and somewhat inspired from <a href="http://trac.openturns.org/wiki/ExampleWrapperScilab">the scilab example</a>. Wrappers allow you to call an external program as the function through which you propagate uncertainty with openturns, so that you can write you function in the language you are familiar with (R here) but still take advantage of open turns. This was done in fedora with R and open turns installed (see <a href="/index.php?post/2009/01/19/Install-open-turns-on-fedora-10">this post</a> for how to install open turns on a fedora 10 machine).
<br>
The first thing we need to do is to grab the template from the installed open turns. 

<pre>
$ mkdir ~/opwrappers
$ cp -fr /usr/local/share/openturns/WrapperTemplates/wrapper_calling_shell_command ~/opwrappers/rwrapper
$ cd ~/opwrappers/rwrapper/
$ ll
total 300
-rw-r--r-- 1 romain romain     27 2009-01-23 11:54 AUTHORS
-rwxr-xr-x 1 romain romain   1304 2009-01-23 11:54 bootstrap
-rw-r--r-- 1 romain romain 199260 2009-01-23 11:54 ChangeLog
-rw-r--r-- 1 romain romain    216 2009-01-23 11:54 code_C1.data
-rw-rw-r-- 1 romain romain   1594 2009-01-23 12:42 configure.ac
-rw-r--r-- 1 romain romain  18002 2009-01-23 11:54 COPYING
-rwxr-xr-x 1 romain romain   1794 2009-01-23 11:54 customize
-rw-r--r-- 1 romain romain   9498 2009-01-23 11:54 INSTALL
drwxr-xr-x 2 romain romain   4096 2009-01-23 11:54 m4
-rw-rw-r-- 1 romain romain    571 2009-01-23 12:42 Makefile.am
-rw-r--r-- 1 romain romain    447 2009-01-23 11:54 myCFunction.c
-rw-r--r-- 1 romain romain    455 2009-01-23 11:54 myCFunction.h
-rw-r--r-- 1 romain romain      0 2009-01-23 11:54 NEWS
-rw-r--r-- 1 romain romain    925 2009-01-23 11:54 README
-rwxrwxr-x 1 romain romain    435 2009-01-23 12:03 rwrapper.R
-rw-rw-r-- 1 romain romain   3722 2009-01-23 12:42 rwrapper.xml.in
-rw-rw-r-- 1 romain romain   1442 2009-01-23 12:42 test.py
-rw-rw-r-- 1 romain romain   9349 2009-01-23 12:42 wrapper.c
-rw-r--r-- 1 romain romain     27 2009-01-23 11:54 AUTHORS
</pre>

The first thing to do is to <code>customize</code> the wrapper so that it is called <code>rwrapper</code> instead of the default <code>wcode</code>. This is achieved by the <code>customize</code> script: 

<pre>
$ ./customize rwrapper
</pre>

The files <code>myCFunction.*</code> are useless and you can remove them at that point, we won't need the <code>code_C1.c</code> file either since we are going to write an R script instead. 

<pre>
$ rm myCFunction.* 
$ rm code_C1.c
$ ll
total 288
-rw-r--r-- 1 romain romain     27 2009-01-23 11:54 AUTHORS
-rwxr-xr-x 1 romain romain   1304 2009-01-23 11:54 bootstrap
-rw-r--r-- 1 romain romain 199260 2009-01-23 11:54 ChangeLog
-rw-r--r-- 1 romain romain    216 2009-01-23 11:54 code_C1.data
-rw-rw-r-- 1 romain romain   1594 2009-01-23 12:42 configure.ac
-rw-r--r-- 1 romain romain  18002 2009-01-23 11:54 COPYING
-rwxr-xr-x 1 romain romain   1794 2009-01-23 11:54 customize
-rw-r--r-- 1 romain romain   9498 2009-01-23 11:54 INSTALL
drwxr-xr-x 2 romain romain   4096 2009-01-23 11:54 m4
-rw-rw-r-- 1 romain romain    571 2009-01-23 12:42 Makefile.am
-rw-r--r-- 1 romain romain      0 2009-01-23 11:54 NEWS
-rw-r--r-- 1 romain romain    925 2009-01-23 11:54 README
-rwxrwxr-x 1 romain romain    435 2009-01-23 12:03 rwrapper.R
-rw-rw-r-- 1 romain romain   3722 2009-01-23 12:42 rwrapper.xml.in
-rw-rw-r-- 1 romain romain   1442 2009-01-23 12:42 test.py
-rw-rw-r-- 1 romain romain   9349 2009-01-23 12:42 wrapper.c
</pre>

Next, we need to write the R script that does the actual work, it needs to grab input file and output file, read data from the input file and write data to the output file. Something like <a href="/public/posts/openturnsrwrapper/rwrapper.R">that</a> : 

<pre><font color="#000000"><font color="#cc0000">#</font><font color="#cc0000">!/usr/bin/env</font><font color="#cc0000"> </font><font color="#cc0000">Rscript</font>

<font color="#cc0000">#</font><font color="#cc0000"> </font><font color="#cc0000">grab</font><font color="#cc0000"> </font><font color="#cc0000">arguments</font>
argv <font color="#000000"><strong>&lt;-</strong></font> <font color="#009966"><strong>commandArgs</strong></font>( <font color="#006699"><strong>TRUE</strong></font> )
datafile <font color="#000000"><strong>&lt;-</strong></font> <font color="#9900cc">argv</font>[<font color="#ff0000">1</font>]
outfile  <font color="#000000"><strong>&lt;-</strong></font> <font color="#9900cc">argv</font>[<font color="#ff0000">2</font>] 

<font color="#cc0000">#</font><font color="#cc0000"> </font><font color="#cc0000">read</font><font color="#cc0000"> </font><font color="#cc0000">data</font><font color="#cc0000"> </font><font color="#cc0000">from</font><font color="#cc0000"> </font><font color="#cc0000">data</font><font color="#cc0000"> </font><font color="#cc0000">file</font><font color="#cc0000"> </font>
rl <font color="#000000"><strong>&lt;-</strong></font> <font color="#009966"><strong>readLines</strong></font>( datafile )
extract <font color="#000000"><strong>&lt;-</strong></font> <font color="#006699"><strong>function</strong></font>( index <font color="#000000"><strong>=</strong></font> <font color="#ff0000">1</font> )<font color="#000000"><strong>{</strong></font>
  rx <font color="#000000"><strong>&lt;-</strong></font> <font color="#009966"><strong>sprintf</strong></font>( <font color="#ff00cc">"</font><font color="#ff00cc">^(I%d</font><font color="#ff00cc"> </font><font color="#ff00cc">*=</font><font color="#ff00cc"> </font><font color="#ff00cc">*)(.*)$</font><font color="#ff00cc">"</font>, index )
  <font color="#009966"><strong>as.numeric</strong></font>( <font color="#009966"><strong>gsub</strong></font>( rx, <font color="#ff00cc">"</font><font color="#ff00cc">\\2</font><font color="#ff00cc">"</font>, <font color="#009966"><strong>grep</strong></font>(rx, rl, value <font color="#000000"><strong>=</strong></font> <font color="#006699"><strong>TRUE</strong></font> ) ) ) 
<font color="#000000"><strong>}</strong></font>
x1 <font color="#000000"><strong>&lt;-</strong></font> extract( <font color="#ff0000">1</font> )
x2 <font color="#000000"><strong>&lt;-</strong></font> extract( <font color="#ff0000">2</font> )
x3 <font color="#000000"><strong>&lt;-</strong></font> extract( <font color="#ff0000">3</font> )

out <font color="#000000"><strong>&lt;-</strong></font> x1 <font color="#000000"><strong>+</strong></font> x2 <font color="#000000"><strong>+</strong></font> x3
<font color="#009966"><strong>cat</strong></font>( <font color="#ff00cc">"</font><font color="#ff00cc">O1</font><font color="#ff00cc"> </font><font color="#ff00cc">=</font><font color="#ff00cc"> </font><font color="#ff00cc">"</font>, out, <font color="#009966"><strong>sep</strong></font> <font color="#000000"><strong>=</strong></font> <font color="#ff00cc">"</font><font color="#ff00cc">"</font>, <font color="#009966"><strong>file</strong></font> <font color="#000000"><strong>=</strong></font> outfile )

</font></pre>

Next, we need to modify the Makefile.am file so that the <code>make install</code> step copies the rwrapper.R file into the <code>wrappers/bin</code> directory later. 

<pre>
ACLOCAL_AMFLAGS = -I m4

wrapperdir          = $(prefix)/wrappers

wrapper_LTLIBRARIES = rwrapper.la
wcode_la_SOURCES    = wrapper.c
wcode_la_CPPFLAGS   = $(OPENTURNS_WRAPPER_CPPFLAGS)
wcode_la_LDFLAGS    = -module -no-undefined -version-info 0:0:0
wcode_la_LDFLAGS   += $(OPENTURNS_WRAPPER_LDFLAGS)
wcode_la_LIBADD     = $(OPENTURNS_WRAPPER_LIBS)

XMLWRAPPERFILE      = rwrapper.xml
wrapper_DATA        = $(XMLWRAPPERFILE)
EXTRA_DIST          = $(XMLWRAPPERFILE).in test.py code_C1.data

execbindir          = $(prefix)/bin
execbin_DATA        = rwrapper.R
</pre>

Then, we need to make a few changes to the <code>rwrapper.xml.in</code> file. Here is the definition of the output variable: 

<pre><font color="#000000">        <font color="#0000ff">&lt;</font><font color="#0000ff">variable</font><font color="#0000ff"> </font><font color="#0000ff">id</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">O1</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">type</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">out</font><font color="#ff00cc">"</font><font color="#0000ff">&gt;</font>
          <font color="#0000ff">&lt;</font><font color="#0000ff">comment</font><font color="#0000ff">&gt;</font>Output 1<font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">comment</font><font color="#0000ff">&gt;</font>
          <font color="#0000ff">&lt;</font><font color="#0000ff">unit</font><font color="#0000ff">&gt;</font>none<font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">unit</font><font color="#0000ff">&gt;</font>
          <font color="#0000ff">&lt;</font><font color="#0000ff">regexp</font><font color="#0000ff">&gt;</font>O1\S*=\S*(\R)<font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">regexp</font><font color="#0000ff">&gt;</font>
        <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">variable</font><font color="#0000ff">&gt;</font>

</font></pre>

You also need to add the <code>subst</code> tag in the output file definition (at least with this version of openturns) : 

<pre><font color="#000000">      <font color="#cc0000">&lt;!--</font><font color="#cc0000"> </font><font color="#cc0000">An</font><font color="#cc0000"> </font><font color="#cc0000">output</font><font color="#cc0000"> </font><font color="#cc0000">file</font><font color="#cc0000"> </font><font color="#cc0000">--&gt;</font>
      <font color="#0000ff">&lt;</font><font color="#0000ff">file</font><font color="#0000ff"> </font><font color="#0000ff">id</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">result</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">type</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">out</font><font color="#ff00cc">"</font><font color="#0000ff">&gt;</font>
        <font color="#0000ff">&lt;</font><font color="#0000ff">name</font><font color="#0000ff">&gt;</font>The output result file<font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">name</font><font color="#0000ff">&gt;</font>
        <font color="#0000ff">&lt;</font><font color="#0000ff">path</font><font color="#0000ff">&gt;</font>code_C1.result<font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">path</font><font color="#0000ff">&gt;</font>
        <font color="#0000ff">&lt;</font><font color="#0000ff">subst</font><font color="#0000ff">&gt;</font>O1<font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">subst</font><font color="#0000ff">&gt;</font>
      <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">file</font><font color="#0000ff">&gt;</font>
 
</font></pre>

and then change the command that invokes the script as follows: 

<pre><font color="#000000">    <font color="#0000ff">&lt;</font><font color="#0000ff">command</font><font color="#0000ff">&gt;</font>Rscript @prefix@/bin/rwrapper.R code_C1.data code_C1.result<font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">command</font><font color="#0000ff">&gt;</font>

</font></pre>

Download the full <a href="/public/posts/openturnsrwrapper/rwrapper.xml.in">rwrapper.xml.in file</a>

Once this is done (you can grab a <a href="/public/posts/openturnsrwrapper/rwrapper.tar.gz"> tar.gz</a> of the wrapper at that stage) , you can compile the wrapper by following these steps: 

<pre>
$ ./bootstrap
$ ./configure --prefix=/home/romain/openturns --with-openturns=/usr/local
$ make 
$ make install
</pre>

If all goes well, you should have a <code>rwrapper.R</code> file in the <code>~/openturns/bin</code> directory and a file <code>rwrapper.xml</code> in the <code>~/openturns/wrappers</code> directory

<br>
Before trying the wrapper, we need to copy the input file in the directory where we are going to run openturns (say <code>/tmp</code>)

<pre>
$ cp code_C1.data /tmp
$ cd /tmp
</pre>

Now we are good to go and can start using the wrapper from open turns: 

<pre>
$ python
&gt;&gt;&gt; from openturns import *
&gt;&gt;&gt; p = NumericalPoint( (1,2,3))
&gt;&gt;&gt; f = NumericalMathFunction( "rwrapper" )
&gt;&gt;&gt; print f(p )
class=NumericalPoint name=Unnamed dimension=1 implementation=class=NumericalPointImplementation name=Unnamed dimension=1 values=[6]
&gt;&gt;&gt; 1+2+3
6
</pre>

The drawback of this approach is that each time the function needs to be evaluated, a new R session will be launched by Rscript, depending on the number of iterations we want to do this can affect seriously the run time of the study. A way to get around this is to use a single R session and let the wrapper communicate with it. I can see at least two ways to do it: 
<ul>
<li>by writing the function in python and let python communicate with R (using <a href="http://rpy.sourceforge.net/">rpy</a> for instance)</li>
<li>by writing a c wrapper that would initialize a connection to an R server when the function is created, and call it whenever the function needs to be called</li>
</ul>
I'll try to tell these stories in another post</div>
