---
title:   raster images and RImageJ
author: "Romain François"
date:  2010-02-18
slug:  raster-images-and-RImageJ
tags:  [ "imagej", "java", "R", "RImageJ" ]
---
<div class="post-content">
<p>The next version of R includes <a href="http://developer.r-project.org/Raster/raster-RFC.html">support for raster images</a> in standard and grid graphics. </p>

<p>The RImageJ package uses <a href="http://rsbweb.nih.gov/ij/">ImageJ</a> through <a href="http://www.rforge.net/rJava/index.html">rJava</a> to read and manipulate images from various formats</p>

<p><a href="http://www.stat.auckland.ac.nz/~paul/">Paul Murrell</a> closed the gap and contributed code that allows using images from the RImageJ package as raster objects. </p>

<iframe src="/public/packages/RImageJ/raster.html" width="500" height="180"></iframe>

<p>makes the graph :</p>

<img src="/public/packages/RImageJ/Rplot001.png" alt="Rplot001.png" style="margin: 0 auto; display: block;" title="Rplot001.png, fév. 2010"><p>This feature depends on R &gt;= 2.11.0, so will only get available when this version becomes current, in the meantime, you can get the package from its <a href="http://r-forge.r-project.org/projects/rimagej/">rforge project page</a></p>
</div>
