---
title:   Playing with QtJambi and Jedit
author: "Romain François"
date:  2009-02-08
slug:  Playing-with-QtJambi-and-Jedit
tags:  [ "jambi", "jedit", "qt" ]
---
<div class="post-content">
<style>
pre{
  border: 1px solid black ;
  font-size: x-small !important ;
}
</style>
<h3>Qt Jambi</h3>

<p>I've been looking at excuses to learn <a href="http://www.qtsoftware.com/products">Qt</a> for some time now, but could not really justify to myself going back to C++, but now with jambi, you can write Qt programs in java. More importantly, with the <a href="http://labs.trolltech.com/page/Projects/QtJambi/QtJambiAwtBridge">Qt Jambi to Awt</a> bridge, you can melt swing components in Qt windows and Qt widgets in swing components. Here is a picture of some swing components in a QWidget</p>

<img src="/public/posts/jambijedit/awtinqt.png" alt="awtinqt.png" style="margin: 0 auto; display: block;" title="awtinqt.png, fév. 2009"><p>and another one with some Qt components in a swing frame</p>

<img src="/public/posts/jambijedit/qtinawt.png" alt="qtinawt.png" style="margin: 0 auto; display: block;" title="qtinawt.png, fév. 2009">

See this code snippet for how it is easy to do: 

<pre><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">12 </font></span>        QGridLayout layout <font color="#000000"><strong>=</strong></font> <font color="#006699"><strong>new</strong></font> <font color="#ff0033">QGridLayout</font><font color="#000000"><strong>(</strong></font><font color="#cc00cc">this</font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">13 </font></span>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">14 </font></span>        <font color="#ff8400">//</font><font color="#ff8400"> </font><font color="#ff8400">A</font><font color="#ff8400"> </font><font color="#ff8400">few</font><font color="#ff8400"> </font><font color="#ff8400">Qt</font><font color="#ff8400"> </font><font color="#ff8400">widgets</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">15 </font></span>        layout.<font color="#ff0033">addWidget</font><font color="#000000"><strong>(</strong></font><font color="#006699"><strong>new</strong></font> <font color="#ff0033">QLabel</font><font color="#000000"><strong>(</strong></font><font color="#ff00cc">"</font><font color="#ff00cc">First</font><font color="#ff00cc"> </font><font color="#ff00cc">name:</font><font color="#ff00cc">"</font><font color="#000000"><strong>)</strong></font>, <font color="#ff0000">0</font>, <font color="#ff0000">0</font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">16 </font></span>        layout.<font color="#ff0033">addWidget</font><font color="#000000"><strong>(</strong></font><font color="#006699"><strong>new</strong></font> <font color="#ff0033">QLineEdit</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>, <font color="#ff0000">0</font>, <font color="#ff0000">1</font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">17 </font></span>        layout.<font color="#ff0033">addWidget</font><font color="#000000"><strong>(</strong></font><font color="#006699"><strong>new</strong></font> <font color="#ff0033">QLabel</font><font color="#000000"><strong>(</strong></font><font color="#ff00cc">"</font><font color="#ff00cc">Last</font><font color="#ff00cc"> </font><font color="#ff00cc">name:</font><font color="#ff00cc">"</font><font color="#000000"><strong>)</strong></font>, <font color="#ff0000">1</font>, <font color="#ff0000">0</font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">18 </font></span>        layout.<font color="#ff0033">addWidget</font><font color="#000000"><strong>(</strong></font><font color="#006699"><strong>new</strong></font> <font color="#ff0033">QLineEdit</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>, <font color="#ff0000">1</font>, <font color="#ff0000">1</font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">19 </font></span>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">20 </font></span>        <font color="#ff8400">//</font><font color="#ff8400"> </font><font color="#ff8400">The</font><font color="#ff8400"> </font><font color="#ff8400">AWT</font><font color="#ff8400"> </font><font color="#ff8400">part</font><font color="#ff8400"> </font><font color="#ff8400">of</font><font color="#ff8400"> </font><font color="#ff8400">the</font><font color="#ff8400"> </font><font color="#ff8400">GUI</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">21 </font></span>        <font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">22 </font></span>            JPanel panel <font color="#000000"><strong>=</strong></font> <font color="#006699"><strong>new</strong></font> <font color="#ff0033">JPanel</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">23 </font></span>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">24 </font></span>            panel.<font color="#ff0033">setLayout</font><font color="#000000"><strong>(</strong></font><font color="#006699"><strong>new</strong></font> <font color="#ff0033">GridLayout</font><font color="#000000"><strong>(</strong></font><font color="#ff0000">1</font>, <font color="#ff0000">2</font><font color="#000000"><strong>)</strong></font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">25 </font></span>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">26 </font></span>            panel.<font color="#ff0033">add</font><font color="#000000"><strong>(</strong></font><font color="#006699"><strong>new</strong></font> <font color="#ff0033">JLabel</font><font color="#000000"><strong>(</strong></font><font color="#ff00cc">"</font><font color="#ff00cc">Social</font><font color="#ff00cc"> </font><font color="#ff00cc">security</font><font color="#ff00cc"> </font><font color="#ff00cc">number:</font><font color="#ff00cc">"</font><font color="#000000"><strong>)</strong></font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">27 </font></span>            panel.<font color="#ff0033">add</font><font color="#000000"><strong>(</strong></font><font color="#006699"><strong>new</strong></font> <font color="#ff0033">JTextField</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">28 </font></span>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">29 </font></span>            <font color="#ff8400">//</font><font color="#ff8400"> </font><font color="#ff8400">Add</font><font color="#ff8400"> </font><font color="#ff8400">the</font><font color="#ff8400"> </font><font color="#ff8400">AWT</font><font color="#ff8400"> </font><font color="#ff8400">panel</font><font color="#ff8400"> </font><font color="#ff8400">to</font><font color="#ff8400"> </font><font color="#ff8400">Qt's</font><font color="#ff8400"> </font><font color="#ff8400">layout</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">30 </font></span>            layout.<font color="#ff0033">addWidget</font><font color="#000000"><strong>(</strong></font><font color="#006699"><strong>new</strong></font> <font color="#ff0033">QComponentHost</font><font color="#000000"><strong>(</strong></font>panel<font color="#000000"><strong>)</strong></font>, <font color="#ff0000">2</font>, <font color="#ff0000">0</font>, <font color="#ff0000">1</font>, <font color="#ff0000">2</font><font color="#000000"><strong>)</strong></font>;
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">31 </font></span>        <font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">32 </font></span>
</font></pre>

<h3>beyond hello world</h3>

<p>So I wanted to go beyond the hello world level, and try to integrate <a href="http://www.jedit.org/">jedit</a> in a Qt window. If it works, this could lead to interesting things such as distributing jedit dockable windows through Qt system QtDockWidget which should be easy based on the new abstract docking window manager service in jedit, or using Qt widgets to extend jedit, ...</p>

<p>I managed to embed jedit in a Qt window, although I had to trick jedit to not build a JFrame when a view is created, I've used the same trick as in biocep workbench, which is writing a small patch to the jEdit class so that the view (which is a JFrame) is never set to visible, and its content pane borrowed by some other component, in that case, a Qt component. Here is how everything looks like: </p>

<pre>
$ tree
.
|-- build.properties
|-- build.xml
|-- jambidocking
|   |-- data
|   |   |-- JambiDockingPlugin.props
|   |   |-- actions.xml
|   |   `-- services.xml
|   `-- src
|       `-- JambiDocking
|           |-- JambiDockingDockingLayout.java
|           |-- JambiDockingWindowManager.java
|           |-- Plugin.java
|           `-- Provider.java
|-- src
|   |-- com
|   |   `-- addictedtor
|   |       `-- jambijedit
|   |           `-- JambiJedit.java
|   `-- org
|       `-- gjt
|           `-- sp
|               `-- jedit
|                   `-- jEdit.java
`-- src_qtjambiawtbridge
    `-- com
        `-- trolltech
            `-- research
                `-- qtjambiawtbridge
                    |-- QComponentHost.java
                    |-- QWidgetHost.java
                    |-- QWidgetWrapper.java
                    |-- QtJambiAwtBridge.java
                    |-- RedirectContainer.java
                    |-- examples
                    |   |-- AwtInQt.java
                    |   `-- QtInAwt.java
                    `-- generated
                        |-- QComponentHostNative.java
                        |-- QWidgetHostNative.java
                        `-- QtJambi_LibraryInitializer.java

19 directories, 21 files
</pre>

<p>Apart from the code of the Qt Jambi to Awt bridge, there is the patched <code>jEdit.java</code>, the <code>JambiJedit.java</code> file which basically creates a Qt main window and sets jedit as its central widget, and the <code>jambidocking</code> directory which contains the start of an implementation of jedit's shiny new <a href="http://www.jedit.org/api/org/gjt/sp/jedit/gui/DockableWindowManager.html">DockableWindowManager</a> system (more on that later)</p>

<a href="/public/posts/jambijedit/jeditinjambi.png"><img src="/public/posts/jambijedit/jeditinjambi_m.jpg" alt="jeditinjambi.png" style="margin: 0 auto; display: block;" title="jeditinjambi.png, fév. 2009"></a>

<p>The good news is that it works, the bad news is that it <em>sort of</em> works</p>

<p>Bad things start to happen when I tried to implement the <a href="http://www.jedit.org/api/org/gjt/sp/jedit/gui/DockableWindowManager.html">DockableWindowManager</a> system, here is the kind of messages I get, I suppose the issue is that jedit uses threading quite a lot and Qt is not happy about it</p>

<pre>
     [java] Exception in thread "main" 7:25:23 PM [main] [error] main: QObject used from outside its own thread, object=com::trolltech::research::qtjambiawtbridge::QComponentHost(0xa305370) , objectThread=Thread[AWT-EventQueue-0,6,main], currentThread=Thread[main,5,main]
     [java] 7:25:23 PM [main] [error] main:  at com.trolltech.qt.GeneratorUtilities.threadCheck(GeneratorUtilities.java:56)
     [java] 7:25:23 PM [main] [error] main:  at com.trolltech.research.qtjambiawtbridge.generated.QComponentHostNative.event(QComponentHostNative.java:37)
     [java] 7:25:23 PM [main] [error] main:  at com.trolltech.research.qtjambiawtbridge.QComponentHost.event(QComponentHost.java:35)
     [java] 7:25:23 PM [main] [error] main:  at com.trolltech.qt.gui.QApplication.exec(Native Method)
     [java] 7:25:23 PM [main] [error] main:  at com.addictedtor.jambijedit.JambiJedit.main(Unknown Source)
     [java] QPixmap: It is not safe to use pixmaps outside the GUI thread
     [java] QPixmap: It is not safe to use pixmaps outside the GUI thread
     [java] QPixmap: It is not safe to use pixmaps outside the GUI thread
     [java] QPixmap: It is not safe to use pixmaps outside the GUI thread
     [java] QPixmap: It is not safe to use pixmaps outside the GUI thread
     [java] QPixmap: It is not safe to use pixmaps outside the GUI thread
</pre>

<p>Anyway, I zipped it up <a href="/public/posts/jambijedit/jambijedit.tar.gz">here</a> in case someone else wants to have a go. It is not quite there yet but at least now I have my excuse to learn Qt, which was the original point ... </p>
</div>
