---
title:   using ImageJ from R- the RImageJ package
author: "Romain François"
date:  2009-06-22
slug:  using-ImageJ-from-R--the-RImageJ-package
tags:  [ "imagej", "java", "R" ]
---
<div class="post-content">
<style>
pre{
font-size: x-small !important; 
border: 1px solid black; 
}
</style>
<p>I've pushed to CRAN the initial version of the RImageJ package. <a href="http://rsbweb.nih.gov/ij/">ImageJ</a> is a java based image processing and analysis platform</p>

<p>This version of the package creates an instance of the <a href="http://midas.herts.ac.uk/helpsheets/api_docs/api/ij/IJ.html">IJ</a> class as the <code>IJ</code> object in R, so that many methods of this class can be called using the dollar expansion of rJava.</p>

<p>Here is a simple example that uses the package:</p>

<pre>
<font color="#000000"><font color="#ff0000">download.file</font><font color="#000000"><strong>(</strong></font> <font color="#ff00cc">"</font><font color="#ff00cc">http://www.google.fr/intl/en_en/images/logo.gif</font><font color="#ff00cc">"</font>, 
    dest <font color="#000000"><strong>=</strong></font> <font color="#ff00cc">"</font><font color="#ff00cc">google.gif</font><font color="#ff00cc">"</font> <font color="#000000"><strong>)</strong></font>

image <font color="#000000"><strong>=</strong></font> IJ<font color="#000000"><strong>$</strong></font><font color="#ff0000">openImage</font><font color="#000000"><strong>(</strong></font> <font color="#ff00cc">"</font><font color="#ff00cc">google.gif</font><font color="#ff00cc">"</font> <font color="#000000"><strong>)</strong></font>
image<font color="#000000"><strong>$</strong></font><font color="#ff0000">show</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>
IJ<font color="#000000"><strong>$</strong></font><font color="#ff0000">run</font><font color="#000000"><strong>(</strong></font> <font color="#ff00cc">"</font><font color="#ff00cc">8-bit</font><font color="#ff00cc">"</font> <font color="#000000"><strong>)</strong></font>
IJ<font color="#000000"><strong>$</strong></font><font color="#ff0000">run</font><font color="#000000"><strong>(</strong></font> <font color="#ff00cc">"</font><font color="#ff00cc">Invert</font><font color="#ff00cc">"</font> <font color="#000000"><strong>)</strong></font>
IJ<font color="#000000"><strong>$</strong></font><font color="#ff0000">save</font><font color="#000000"><strong>(</strong></font> <font color="#ff00cc">"</font><font color="#ff00cc">bw-google.gif</font><font color="#ff00cc">"</font> <font color="#000000"><strong>)</strong></font>
image<font color="#000000"><strong>$</strong></font><font color="#ff0000">close</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>

</font>
</pre>

<p>This downloads the google logo, convert it to black and white and inverts it</p>


<img src="http://www.google.fr/intl/en_en/images/logo.gif" alt="google logo" style="margin: 0 auto; display: block;" title="google original logo"><img src="/public/posts/rimagej/bw-google.gif" alt="bw-google.gif" style="margin: 0 auto; display: block;" title="bw-google.gif, juin 2009">


Future plans for this package contain: 
<ul>
<li>integration of imagej and javagd</li>
<li>integration of the imagej macro recorder so that it creates R code instead of code in the <a href="http://rsbweb.nih.gov/ij/developer/macro/macros.html">imagej macro language</a>
</li>
</ul>
</div>
