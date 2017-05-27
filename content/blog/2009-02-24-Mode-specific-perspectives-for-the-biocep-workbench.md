---
title:   Mode specific perspectives for the biocep workbench
author: "Romain François"
date:  2009-02-24
slug:  Mode-specific-perspectives-for-the-biocep-workbench
tags:  [ "jedit" ]
---
<div class="post-content">
<p>Following on this <a href="/index.php?post/2009/02/22/Perspectives-for-the-biocep-workbench">previous</a> post, here is how to set up jedit in the power editor to use mode specific perspectives, so that when you leave a file of a given mode (say R), the current perspective is saved, and when you load a file of a given mode (say sweave), the recorded perspective is used (if it exists)</p>

<p>You first need to start the workbench, with a recent version of the power editor plugin (svn revision &gt;220)</p>

<a href="/public/posts/perspectives/startup.png"><img src="/public/posts/perspectives/startup_m.jpg" alt="startup.png" style="margin: 0 auto; display: block;" title="startup.png, fév. 2009"></a> 

<p>Then load the editor plugin. <em>Plugin &gt; Editor &gt; Power Editor</em></p>

<a href="/public/posts/perspectives/powereditorloaded.png"><img src="/public/posts/perspectives/powereditorloaded_m.jpg" alt="powereditorloaded.png" style="margin: 0 auto; display: block;" title="powereditorloaded.png, fév. 2009"></a>

<p>Finally, you need to tell jedit that you want it to manage saving and loading perspectives automatically based on the mode of the file being edited. You can do that using the jedit menu jEdit &gt; Utilities &gt; Global Options, ... The following dialog is displayed, click the two checkboxes on top. </p>

<a href="/public/posts/perspectives/dockingdialog.png"><img src="/public/posts/perspectives/dockingdialog_m.jpg" alt="dockingdialog.png" style="margin: 0 auto; display: block;" title="dockingdialog.png, fév. 2009"></a>

<p>That's it. You can also save a perspective by selecting <em>jEdit &gt; View &gt; Docking &gt; Save Docking Layout ... </em></p>
</div>
