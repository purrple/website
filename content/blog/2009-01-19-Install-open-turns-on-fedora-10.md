---
title:   Install open turns on fedora 10
author: "Romain François"
date:  2009-01-19
slug:  Install-open-turns-on-fedora-10
tags:  [ "fedora", "openturns", "python" ]
---
<div class="post-content">
<h2>Introduction</h2>


<p>After spending quite some time to install <a href="http://trac.openturns.org/">openturns</a> on my fedora box, I feel I should post about it to spare the time of other people. The <a href="http://trac.openturns.org/wiki/HowToInstall">install page</a> advertises for a forthcoming support for RPM packages available <strong>soon</strong> (we all know the real definition of <strong>soon</strong> don't we : it means "we don't need it for ourselves, so if you want it, do it", which is fair enough).</p>


<p>If I had more time, I would learn how to make rpms, and provide one for openturns, but this does not seem necessary for now as openturns installs fine from source, at least if you go round a few things. This post is absolutely not a replacement for the real <a href="http://trac.openturns.org/wiki/HowToInstall">install notes</a> but maybe guidelines on how to read these notes from a fedora perspective.</p>


<h2>Download</h2>


<p>Grab the <a href="http://sourceforge.net/project/showfiles.php?group_id=198476">tar.gz</a> from sourceforge and unzip it somewhere.</p>


<h2>Dependencies</h2>


<p>This is what the install notes say :</p>


<blockquote>
<p>Till 0.12.1 included:</p>
<p>
* GCC C, C++ and Fortran compilers (&gt;= 3.3.5 except 4.0.x series, tested with 3.4.5, 3.4.6, 4.1.1, 4.1.2 &amp; 4.2.2)
* Python interpreter (&gt;= 2.4.x)
* R statistical language (&gt;= 2.0)
* Xerces-C XML parser (&gt;= 2.6.0, tested with 2.7.0)
* BOOST C++ library (&gt;= 1.33.1)
* LAPACK Linear Algebra library (&gt;= 3.0)
* Qt (3.3.x)
* python-qt if you want to use the embedded image viewer ViewImage (TUI only)</p>
<p>
Since 0.12.2:</p>
<p>
* GCC C, C++ and Fortran compilers (&gt;= 3.3.5 except 4.0.x series, tested with 3.3.5, 3.3.6, 3.4.5, 3.4.6, 4.1.1, 4.1.2, 4.2.2 &amp; 4.3.1)
* Python interpreter (&gt;= 2.4.x)
* R statistical language (&gt;= 2.0)
* Libxml2 XML library (&gt;= 2.6.27)
* LAPACK Linear Algebra library (&gt;= 3.0)
* python-qt if you want to use the embedded image viewer ViewImage (TUI only)</p>
</blockquote>


<p>Here is what I have done on my fedora machine: python and gcc are already installed unless you really want them not to be, so nothing to do here, R is easy to compile from source, but you can get it with yum as well (<code>yum install R</code>)</p>


<p>For the other software, here is my list of yum calls :</p>

<pre>
# yum install -y xerces-c-devel
# yum install -y boost-devel
# yum install -y lapack-devel
# yum install -y qt3-devel
# yum install -y PyQt-devel
# yum install -y libxml2-devel
</pre>


<p>I also installed <a href="http://rpy.sourceforge.net/">rpy</a> and <a href="http://www.graphviz.org/">graphviz</a> to have optional features as well:</p>

<pre>
# yum install -y rpy
# yum install -y graphviz-devel
</pre>


<p>After that, the <code>./configure</code> call should be ok. Here is the <a href="/public/posts/post-openturns-install-fedora/summary.txt">summary I got</a> which sounds good enough.</p>


<h2>R Packages</h2>


<p>Now you can install the R package <strong>rotRPackage</strong> which comes with openturns as described in the <a href="http://trac.openturns.org/wiki/HowToInstall">install page</a></p>

<pre>
# R CMD INSTALL utils/rotRPackage_1.4.4.tar.gz
</pre>


<p>You also need the <a href="http://cran.r-project.org/web/packages/sensitivity/index.html">sensitivity</a> package, but at the time of writing the sensitivity package changed some of its API and openturns did not propagate, so you have to install <a href="http://cran.r-project.org/src/contrib/Archive/sensitivity/sensitivity_1.3-1.tar.gz">version 1.3-1</a> as opposed to the current version.</p>


<p>The other problem I ran into was that I am using a custom <code>~/.Rprofile</code> file which contains startup instructions such as <strong>require</strong>ing R packages, this caused the test cases of openturns to fail because the expected output was mixed with the standard error stream (which is where require writes its messages). So at least for running openturns tests, I have modified my <code>.Rprofile</code> file so that it does not load packages or write anything to the standard error stream.</p>


<h2>Installing openturns</h2>


<p>When this is ready, you can do :</p>

<pre>
$ make   # good opportunity to make some coffee while it compiles 
$ make check # everything should be ok
# make install
$ make installcheck # should be ok too
</pre>


<h2>Loading the python module</h2>


<p>Reading the <a href="http://trac.openturns.org/wiki/FAQ">FAQ</a> is a good way to save yourself some time, specifically when trying to load the <code>openturns</code> python module. I have added these two lines to my <code>.bash_profile</code> file :</p>

<pre>
PYTHONPATH=/usr/local/lib/python2.5/site-packages/openturns
export PYTHONPATH
</pre>


<p>Then, you can start python and start using openturns, which is another story ...</p>

<pre>
$ python
Python 2.5.2 (r252:60911, Sep 30 2008, 15:41:38)
[GCC 4.3.2 20080917 (Red Hat 4.3.2-4)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
&gt;&gt;&gt; from openturns import *
</pre>
</div>
