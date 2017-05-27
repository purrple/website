---
title:   Edit Sweave files with the workbench
author: "Romain François"
date:  2008-12-31
slug:  Edit-Sweave-files-with-the-workbench
tags:  [ "jedit", "R", "sweave" ]
---
<div class="post-content">
<h1>Edit Sweave Files with the Workbench</h1>
Sweave is a very useful combination of LaTeX and R together in one document. You can find more information about sweave by visiting its <a href="http://www.stat.uni-muenchen.de/%7Eleisch/Sweave/">homepage</a> or by simply typing ?Sweave at your R command line. <br>This post demonstrates some of the features of the <a href="http://r-forge.r-project.org/projects/biocep-editor/">Power Editor plugin</a> for the <a href="http://biocep-distrib.r-forge.r-project.org/">biocep workbench</a> when editing Sweave files, we will see other features in subsequent posts. <br><br>The <a href="http://plugins.jedit.org/plugins/?LaTeXTools">LaTeXTools</a> plugin for jedit gave a good starting point for Sweave integration as most of the parsing of LaTeX syntax is directly borrowed from it, however the plugin could not directly cope with the mixture of latex and R in the same document, so there is a small bit of coding around it to get things working. Also the sidekick tree for latex gives a too restrictive set of icons for the sections of the file, so some coding was needed to get a nice R icon to represent a sweave code chunk. <br><br>Here is a screenshot of the workbench when editing a sweave file, this example is the grid vignette, which you may find by typing : <br><pre>R&gt; vignette( "grid", package = "grid")$file</pre>
<a href="/public/editinggridvignette.png"><img title="editinggridvignette.png, déc. 2008" style="margin: 0 auto; display: block;" alt="" src="/public/editinggridvignette_m.jpg"></a><br>You can see the sidekick view on the right showing a browsable outline of the document. The editor and the sidekick view are synchronized so when you click on a node of the tree, the editor will scroll to the appropriate location and when you move to some other part of the document, the tree will update to show the location being edited. <br><ins><a href="/public/editinggridvignette-sidekick.png"><img title="editinggridvignette-sidekick.png, déc. 2008" style="margin: 0 auto; display: block;" alt="" src="/public/editinggridvignette-sidekick_m.jpg"></a><br><br></ins>The Power Editor plugin also allows to visually identify documentation and code parts of the document as you can see in the following screenshot where Sweave code chunks are being highlighted with a light blue background. <br><br><a href="/public/editinggridvignette-structuremarker.png"><img title="editinggridvignette-structuremarker.png, déc. 2008" style="margin: 0 auto; display: block;" alt="" src="/public/editinggridvignette-structuremarker_m.jpg"></a><br><h2>Requirements</h2>
To get the features documented here, you need both updated versions of biocep and the Power Editor Plugin (at least revision 194). I will do an other post about how to install these things.<br>You also need <a href="/public/modes/r.xml">R</a> and <a href="/public/modes/sweave.xml">Sweave</a> mode files (I still need to find a way to embed them in the plugin) saved in your jedit settings directory with the following lines in your catalog file : <br><br><pre>&lt;MODE NAME="R"    FILE="r.xml" <br>  FILE_NAME_GLOB="*.R" <br>  FIRST_LINE_GLOB="#!/*{R,Rscript}" /&gt;<br>&lt;MODE NAME="sweave"    <br>  FILE="sweave.xml" <br>  FILE_NAME_GLOB="*.{R,S}nw" /&gt;</pre>
<h2>Coming Next </h2>
It would be nice to :<br><ul>
<li>allow preview of graphics when <code>fig=TRUE</code> is set, I need to understand some of the packages providing cache feature for Sweave</li>
<li>
<del>have R completion when inside the code chunk </del>, see <a href="/index.php?post/2009/01/12/R-code-completion-in-sweave-chunks">this post</a>
</li>
<li>completion of the options used by the sweave driver</li>
<li>actions to weave and tangle the current file</li>
<li>jump between sweave code chunks</li>
<li>integrate <a href="http://www.cert.fr/dcsd/idco/perso/Magni/jedit/help.html">this</a> as a view</li>
<li>support the html flavour of sweave</li>
</ul>
</div>
