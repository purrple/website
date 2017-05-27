---
title:   RProtoBuf- protocol buffers for R
author: "Romain François"
date:  2010-02-04
slug:  RProtoBuf--protocol-buffers-meet-R
tags:  [ "CRAN", "package", "protobuf", "R", "RProtoBuf" ]
---
<div class="post-content">
<p>We (<a href="http://dirk.eddelbuettel.com/">Dirk</a> and I) released the initial version of our package <code>RProtoBuf</code> to CRAN this week. This packages brings google's <a href="http://code.google.com/p/protobuf/">protocol buffers</a> to R</p>

<p>I invite you to check out the <a href="http://code.google.com/p/protobuf/">main page for protobuf</a> to find the language definition for protocol buffers as well as tutorial for officially (i.e. by google) supported languages (python, c++ and java) as well as the <a href="http://code.google.com/p/protobuf/wiki/ThirdPartyAddOns">third party support</a> page that lists language bindings offered by others (including our <code>RProtoBuf</code> package.</p>

<p>Protocol buffers are a language agnostic data interchange format, based on a using a <a href="http://code.google.com/apis/protocolbuffers/docs/proto.html">simple and well defined language</a>. Here comes the classic example that google uses for C++, java and python tutorials. </p>

<p>First, the proto file defines the format of the message.</p>

<iframe src="/public/packages/RProtoBuf/ab.proto.txt" width="500" height="350" frameborder="1"></iframe>

<p>Then you need to teach this particular message to R, which is simply done by the <code>readProtoFiles</code> function. </p>

<pre>
&gt; readProtoFiles( "addressbook.proto" )
</pre>

<p>Now we can start creating messages : </p>

<pre>
&gt; person 

<p>And then access, modify fields of the message using a syntax extremely close to R lists</p>

<pre>
&gt; person$email  person$name 

<p>In R, protobuf messages are stored as simple S4 objects of class "Message" that contain an external pointer to the underlying C++ object. The Message class also defines methods that can be accessed using the dollar operator</p>

<pre>
&gt; # write a debug version of message
&gt; # this is not how it is serialized
&gt; writeLines( person$toString() )
name: "Romain Francois"
id: 1234
email: "francoisromain@free.fr"

&gt; # serialize the message to a file
&gt; person$serialize( "somefile" )
</pre>

<p>The package already has tons of features, detailed in the vignette</p>

<pre>
&gt; vignette( "RProtoBuf" )
</pre>

<p>.. and there is more to come</p></pre></pre>
</div>
