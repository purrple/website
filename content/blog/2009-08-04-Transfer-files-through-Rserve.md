---
title:   Transfer files through Rserve
author: "Romain François"
date:  2009-08-04
slug:  Transfer-files-through-Rserve
---
<div class="post-content">
<style type="text/css">
pre{
	border: solid black 1px; 
        font-size: small !important; 
}
</style>
<p>This post is motivated by this <a href="http://thread.gmane.org/gmane.comp.lang.r.general/158345">question</a> on R-help. This is a simple java class that sends files through Rserve using the classes <a href="http://www.rforge.net/org/docs/org/rosuda/REngine/Rserve/RFileInputStream.html">RFileInputStream</a> and <a href="http://www.rforge.net/org/docs/org/rosuda/REngine/Rserve/RFileOutputStream.html">RFileOutputStream</a></p>

<iframe src="/public/posts/rservewire/RserveWire.html" scrolling="auto" frameborder="1" width="500" height="1200">
</iframe>

<p>Then we create a simple file on the client machine: </p>

<pre>
$ cat &gt; testfile.txt
bla bla
^C
</pre>

<p>And we are good to go: </p>

<pre>
$ javac -cp .:REngine.jar:Rserve.jar RserveWire.java
$ java -cp .:REngine.jar:Rserve.jar RserveWire testfile.txt serverfile.txt
/tmp/Rserv/conn6
writing the client file 'testfile.txt' to the server as 'serverfile.txt'
writing the server file 'file.txt' to the client as 'file.txt' 
</pre>

<p>Now in the directory <code>/tmp/Rserv/conn6</code> of the server, there are the files "serverfile.txt" and "file.txt"</p>

<pre>
$ cat serverfile.txt 
bla bla
$ cat file.txt
 [1] -1.16541741 -0.55857285  2.19752036 -0.78432188  1.40739981 -0.87252966
 [7] -0.11545651 -0.36735874 -2.75736666  0.29798096 -0.86836355 -0.03416198
[13] -0.44344089  0.88976360  0.58821334 -0.10354205 -0.88760475 -0.64608338
[19]  0.96552319 -1.57166441 -0.19010633 -1.42239696  0.49363257  0.06167547
[25]  0.34801546 -0.41211734 -0.20320050 -1.45370497  1.34383425 -0.89461504
</pre>

<p>and on the client there is also the "file.txt" </p>

<pre>
$ cat file.txt
 [1] -1.16541741 -0.55857285  2.19752036 -0.78432188  1.40739981 -0.87252966
 [7] -0.11545651 -0.36735874 -2.75736666  0.29798096 -0.86836355 -0.03416198
[13] -0.44344089  0.88976360  0.58821334 -0.10354205 -0.88760475 -0.64608338
[19]  0.96552319 -1.57166441 -0.19010633 -1.42239696  0.49363257  0.06167547
[25]  0.34801546 -0.41211734 -0.20320050 -1.45370497  1.34383425 -0.89461504
</pre>
</div>
