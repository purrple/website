---
title:   A better jedit edit mode for R
author: "Romain François"
date:  2009-03-16
slug:  A-better-jedit-edit-mode-for-R
tags:  [ "jedit", "R" ]
---
<div class="post-content">
<p>I have spend a bit of time over the week end working with the jedit edit mode file for R code. That is the file that guides jedit on how to syntax highlight R code. The previous one I was using was based on the idea <em>"let's put all the names of all the functions in standard R packages as keywords"</em>, although "it works", it is not a very good idea since it makes the edit mode huge and consequently must have some effect on jedit's performance when painting R code</p>

<p>The new mode file can be found <a href="http://r-forge.r-project.org/plugins/scmsvn/viewcvs.php/data/org.gjt.sp.jedit/jeditsettings/modes/?root=biocep-editor">on the biocep-editor</a> project on r-forge</p>

<p>Here are some of the choices I have made</p>

<ul>
<li>function calls are highlighted with type <em>FUNCTION</em>. A function call is a name followed by a round bracket</li>
<li>Core language constructs are highlighted with type <em>KEYWORD1</em>: (for, function, if, else, ifelse, in, repeat, return, switch, while, break, next) I have also added these to that list: (expression, quote, parse, deparse, substitute, get, getAnywhere, assign, exists, expression, bquote, typeof, mode, eval, evalq, with). </li>
<li>Debugging related functions are highlighted with type <em>KEYWORD2</em>: browser, debug, trace, traceback, recover, undebug, isdebugged, bp, mtrace</li>
<li>Error handling functions are highlighted using <em>KEYWORD3</em>: try, tryCatch, withRestarts, withCallingHandlers, stop, stopifnot, geterrmessage, warning, signalCondition, simpleCondition, simpleError, simpleWarning, simpleMessage, conditionCall, conditionMessage, computeRestarts, findRestart, invokeRestart, invokeRestartInteractively, isRestart, restartDescription, restartFormals, .signalSimpleWarning, .handleSimpleError
</li>
<li>Object Oriented related functions (S3 and S4) are using type <em>KEYWORD4</em>: class, inherits, setClass, representation, structure, methods, setIs, slot, new, setMethod, validObject, setValidity, getValidity, initialize, setOldClass, callNextMethod, NextMethod, UseMethod, getS3method</li>
<li>Constants are using type <em>LITERAL2</em>: NULL, Inf, NULL, NA, NaN, T, TRUE, F, FALSE, pi, NA_character_, NA_complex_, NA_integer_, NA_real_</li>
<li>Apply functions are using <em>LITERAL4</em>: lapply, sapply, by, mapply, tapply, apply, replicate, aggregate. I have also added some functions from the packages reshape and plyr to that list</li>
<li>Support for R4X by delegating to the R4X mode (mainly XML) between strings "'##((xml" and "'##xml))"</li>
<li>Support for Roxygen comment, inspired from the way javadoc comments are treated in the java mode</li>
</ul>
</div>
