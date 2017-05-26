---
title:   jaxx mode for jedit
author: "Romain François"
date:  2009-01-30
slug:  jaxx-mode-for-jedit
tags:  [ "jaxx", "jedit" ]
---
<div class="post-content">
<a href="http://www.jaxxframework.org/wiki/Main_Page">jaxx</a> lets you write Swing user interfaces using XML tags instead of raw java code. 
I've written a quick <a href="/public/modes/jaxx.xml">jedit mode file for jaxx</a> so that it is a bit nicer to write jaxx code in jedit. Basically, it write paint code inside <code>script</code> tags as java code and code inside <code>style</code> tags as CSS. It would need a bit of work to deal with data binding and the special jaxx css, but it's a start.

<pre style="border:1px solid black">
<font color="#000000"><font color="#0099ff"><strong>&lt;?</strong></font><font color="#0099ff"><strong>xml</strong></font><font color="#0099ff"><strong> </strong></font><font color="#0099ff"><strong>version="1.0"?</strong></font><font color="#0099ff"><strong>&gt;</strong></font>
<font color="#009966"><strong>&lt;!</strong></font><font color="#009966"><strong>DOCTYPE</strong></font><font color="#009966"><strong> </strong></font><font color="#009966"><strong>MODE</strong></font><font color="#009966"><strong> </strong></font><font color="#009966"><strong>SYSTEM</strong></font><font color="#009966"><strong> </strong></font><font color="#ff00cc">"</font><font color="#ff00cc">xmode.dtd</font><font color="#ff00cc">"</font><font color="#009966"><strong>&gt;</strong></font>

<font color="#0000ff">&lt;</font><font color="#0000ff">MODE</font><font color="#0000ff">&gt;</font>
  <font color="#0000ff">&lt;</font><font color="#0000ff">RULES</font><font color="#0000ff"> </font><font color="#0000ff">IGNORE_CASE</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">FALSE</font><font color="#ff00cc">"</font><font color="#0000ff">&gt;</font>
        
    <font color="#0000ff">&lt;</font><font color="#0000ff">SPAN_REGEXP</font><font color="#0000ff"> </font><font color="#0000ff">MATCH_TYPE</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">MARKUP</font><font color="#ff00cc">"</font><font color="#0000ff"> </font>
<font color="#0000ff">  </font><font color="#0000ff">  </font><font color="#0000ff">  </font><font color="#0000ff">DELEGATE</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">java::MAIN</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">HASH_CHAR</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">&amp;lt;</font><font color="#ff00cc">"</font><font color="#0000ff">&gt;</font>
      <font color="#0000ff">&lt;</font><font color="#0000ff">BEGIN</font><font color="#0000ff">&gt;</font><font color="#cc00cc">&amp;</font><font color="#cc00cc">lt</font><font color="#cc00cc">;</font>script<font color="#cc00cc">&amp;</font><font color="#cc00cc">gt</font><font color="#cc00cc">;</font><font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">BEGIN</font><font color="#0000ff">&gt;</font>
      <font color="#0000ff">&lt;</font><font color="#0000ff">END</font><font color="#0000ff">&gt;</font><font color="#cc00cc">&amp;</font><font color="#cc00cc">lt</font><font color="#cc00cc">;</font>/script<font color="#cc00cc">&amp;</font><font color="#cc00cc">gt</font><font color="#cc00cc">;</font><font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">END</font><font color="#0000ff">&gt;</font>
    <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">SPAN_REGEXP</font><font color="#0000ff">&gt;</font>
    
    <font color="#0000ff">&lt;</font><font color="#0000ff">SPAN_REGEXP</font><font color="#0000ff"> </font><font color="#0000ff">MATCH_TYPE</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">MARKUP</font><font color="#ff00cc">"</font><font color="#0000ff"> </font>
<font color="#0000ff">  </font><font color="#0000ff">  </font><font color="#0000ff">  </font><font color="#0000ff">DELEGATE</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">css::MAIN</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">HASH_CHAR</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">&amp;lt;</font><font color="#ff00cc">"</font><font color="#0000ff">&gt;</font>
      <font color="#0000ff">&lt;</font><font color="#0000ff">BEGIN</font><font color="#0000ff">&gt;</font><font color="#cc00cc">&amp;</font><font color="#cc00cc">lt</font><font color="#cc00cc">;</font>style<font color="#cc00cc">&amp;</font><font color="#cc00cc">gt</font><font color="#cc00cc">;</font><font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">BEGIN</font><font color="#0000ff">&gt;</font>
      <font color="#0000ff">&lt;</font><font color="#0000ff">END</font><font color="#0000ff">&gt;</font><font color="#cc00cc">&amp;</font><font color="#cc00cc">lt</font><font color="#cc00cc">;</font>/style<font color="#cc00cc">&amp;</font><font color="#cc00cc">gt</font><font color="#cc00cc">;</font><font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">END</font><font color="#0000ff">&gt;</font>
    <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">SPAN_REGEXP</font><font color="#0000ff">&gt;</font>
    
    <font color="#0000ff">&lt;</font><font color="#0000ff">IMPORT</font><font color="#0000ff"> </font><font color="#0000ff">DELEGATE</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">xml::MAIN</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
  <font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">RULES</font><font color="#0000ff">&gt;</font>

<font color="#0000ff">&lt;</font><font color="#0000ff">/</font><font color="#0000ff">MODE</font><font color="#0000ff">&gt;</font>

</font></pre>

Don't forget to add this line to you catalog file: 

<pre style="border:1px solid black"><font color="#000000">  <font color="#0000ff">&lt;</font><font color="#0000ff">MODE</font><font color="#0000ff"> </font><font color="#0000ff">NAME</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">jaxx</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">  </font><font color="#0000ff">FILE</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">jaxx.xml</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff">FILE_NAME_GLOB</font><font color="#0000ff">=</font><font color="#ff00cc">"</font><font color="#ff00cc">*.jaxx</font><font color="#ff00cc">"</font><font color="#0000ff"> </font><font color="#0000ff"> </font><font color="#0000ff">/</font><font color="#0000ff">&gt;</font>
</font></pre>
</div>
