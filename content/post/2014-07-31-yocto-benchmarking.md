---
title:  yocto benchmarking
author: "Romain François"
date:  2014-07-31

---

<div class="post-content">
<p>Let's start with a picture of a bench, as we're going to do some benchmarking.</p>

<p><img src="/web/20150304070926im_/http://blog.r-enthusiasts.com:80/content/images/2014/Jul/bench.jpg" alt=""></p>

<p>One of my take home message from useR was that we are going to have to do things in parallel. JJ set the motion with the <a href="https://web.archive.org/web/20150304070926/https://github.com/RcppCore/RcppParallel">RcppParallel</a> package. </p>

<p>The <a href="https://web.archive.org/web/20150304070926/http://gallery.rcpp.org/articles/parallel-vector-sum/">inceptive example</a> for <a href="https://web.archive.org/web/20150304070926/https://github.com/RcppCore/RcppParallel">RcppParallel</a> was about calculating the sum from a numeric vector. </p>

<p>The <a href="https://web.archive.org/web/20150304070926/http://gallery.rcpp.org/articles/parallel-vector-sum/">article</a> shows some nice global benchmark results. </p>

<p>As I'm going to be doing a lot of that kind of work, I've spent some time developping a few tools for finer grained benchmarking, hence the title of this post, the idea is that I want to know which thread is doing what and when. </p>

<p>Let's start with the serial version. In these graphs below, the height of rectangles is proportional to the mount of data a thread is dealing with. In the serial version obviously there is only one thread doing all the work, so we have a big old blue rectangle. The x axis is time in milliseconds. </p>

<p><img src="/web/20150304070926im_/http://blog.r-enthusiasts.com:80/content/images/2014/Jul/serial-1.png" alt=""></p>

<p>Then, some version using <code>parallelReduce</code> from <code>RcppParallel</code>. This was run on a machine that has 4 cores, so 8 threads with hyper threading. The first thing to notice is that it is faster, mission accomplished. We can also see the work of tbb scheduler, which has used many more than 8 threads, also within each thread (a line of variable height) we can see many rectangles. That is because tbb does not just split the data in chunks and hand them directly to the threads, it uses a advanced algorithm to schedule threads and hand small chunks to them. </p>

<p><img src="/web/20150304070926im_/http://blog.r-enthusiasts.com:80/content/images/2014/Jul/parallel_1-1.png" alt=""></p>

<p>The previous example use the default grain size (1) which might not be a good idea because we might end up with tasks running on very small chunks of data. Here's another shot using a grain size of <code>1,000,000</code>. Does not change much in that case in terms of total time, but we can see that there are less chunks. Finding the best grain size for a problem is not an exact science, but it is not that critical for such an obvious problem anyway. </p>

<p><img src="/web/20150304070926im_/http://blog.r-enthusiasts.com:80/content/images/2014/Jul/parallel_1000000.png" alt=""></p>

<p>Last example is about doing the splitting manually in 8 chunks and have one thread handling the whole chunk. </p>

<p><img src="/web/20150304070926im_/http://blog.r-enthusiasts.com:80/content/images/2014/Jul/manual_threads-1.png" alt=""></p>

<p>I'm working on another representation that might make it easier to compare the versions. the idea is to represent how much of the data has been processed at a given point in time. All the information is in the data, I just have to tidy it a bit as now the data is more or less organised to facilitate the previous graphs. </p>

<p>The code for these various versions is below. It uses current development version of <a href="https://web.archive.org/web/20150304070926/https://github.com/RcppCore/RcppParallel"><code>RcppParallel</code></a> and my little <a href="https://web.archive.org/web/20150304070926/https://github.com/romainfrancois/TimerPlot"><code>TimerPlot</code></a> package that does the graphs. </p>

<pre><code class="cpp">#include &lt;Rcpp.h&gt;
#include &lt;Rcpp/Benchmark/Timer.h&gt;
#include &lt;RcppParallel.h&gt;

// [[Rcpp::depends(RcppParallel)]]

using namespace Rcpp ;  
using namespace RcppParallel;

// [[Rcpp::export]]
List sum_serial( NumericVector x){  
    SingleTimer&lt;Timer&gt; timer ;
    timer.step("start") ;
    double res = std::accumulate( x.begin(), x.end(), 0.0 ) ;
    timer.step( "work" ) ;

    return List::create( (SEXP)timer, res ) ;
}

class Summer : public Worker {  
public:

    Summer( const NumericVector&amp; x ) : 
        data(x.begin()), 
        res(0.0)
    {}

    Summer( const Summer&amp; other, Split ) :
        data(other.data), 
        res(0.0)
    {}

    void operator()( std::size_t begin, std::size_t end){
        res += std::accumulate( data + begin, data + end, 0.0 ) ;    
    }

    void join(Summer&amp; rhs ){
        res += rhs.res ;    
    }

    double get() const {
        return res ;    
    }

private:

    const double* data ;
    double res ;

} ;

typedef TimersList&lt;Timer, tbb::mutex, tbb::mutex::scoped_lock &gt; Timers ;  
typedef TimedReducer&lt;Summer, Timer, tbb::mutex, tbb::mutex::scoped_lock, double &gt; TimedSummer ; 

// [[Rcpp::export]]
List sum_parallelReduce( NumericVector x, int grain_size = 1){  
    int n = x.size() ;
    Timers timers(n) ;
    Summer summer(x) ;
    TimedSummer worker( summer, timers ) ;
    parallelReduce(0, n, worker, grain_size) ;
    return worker.get() ;
}

template &lt;typename Work&gt;  
inline void process_thread( void* data ){  
    Work* work = reinterpret_cast&lt;Work*&gt;(data) ;
    work-&gt;process() ;    
}

struct SummerThread {  
public:  
    IndexRange range ;
    double&amp; res ;
    const double* data ;
    tbb::mutex&amp; m ;
    ProportionTimer&lt;Timer&gt;&amp; timer ;

    SummerThread( IndexRange range_, double&amp; res_, const NumericVector&amp; data_, tbb::mutex&amp; m_, ProportionTimer&lt;Timer&gt;&amp; timer_ ) :
        range(range_), res(res_), data(data_.begin()), m(m_), timer(timer_)
    {}

    void process(){
        timer.step("start") ;
        double d = std::accumulate( 
            data + range.begin(),
            data + range.end(),
            0.0 
            );
        timer.step("work") ;
        {
            tbb::mutex::scoped_lock lock(m) ;
            res += d ;
        }
        timer.step("join" ) ;

    }
};

// [[Rcpp::export]]
List summer_manual_threads(NumericVector x){  
    using namespace tthread;
    int n = x.size() ;  
    IndexRange inputRange(0, n);
    std::vector&lt;IndexRange&gt; ranges = splitInputRange(inputRange, 1);
    int nthreads = ranges.size() ;   
    FixedSizeTimers&lt;Timer&gt; timers(nthreads+1, n) ; 
    timers[0].n = n ;

    std::vector&lt;SummerThread*&gt; workers ;
    std::vector&lt;thread*&gt; threads ;
    double result = 0.0 ;
    tbb::mutex m ;

    for( int i=0; i&lt;nthreads; i++){ 
        timers[i+1].n = ranges[i].size() ;    
        SummerThread* w = new SummerThread( ranges[i], result, x, m, timers[i+1] ) ;
        workers.push_back( w );
        threads.push_back( new thread( process_thread&lt;SummerThread&gt;, w )) ;
    }

    for( int i=0; i&lt;nthreads; i++){
        threads[i]-&gt;join() ;     
        delete threads[i] ;
        delete workers[i] ;
    }
    return List::create( (SEXP)timers, result ) ;

}


/*** R

    library("TimerPlot")

    x &lt;- rnorm(1e8)

    data_serial          &lt;- sum_serial(x)[[1]]
    data_parallel_1      &lt;- sum_parallelReduce(x, 1L)[[1]]
    data_parallel_1000000 &lt;- sum_parallelReduce(x, 1000000L )[[1]]
    data_threads         &lt;- summer_manual_threads(x)[[1]]

    xmax &lt;- max( unlist(list(data_serial, data_parallel_1, data_parallel_1000000, data_threads ))) / 1e6

    png( "serial.png", width = 800, height = 400 )
    plot(data_serial, xmax = xmax)
    dev.off()

    png( "parallel_1.png", width = 800, height = 400 )
    plot(data_parallel_1, xmax = xmax)
    dev.off()

    png( "parallel_1000000.png", width = 800, height = 400 )
    plot(data_parallel_1000000, xmax = xmax)
    dev.off()

    png( "manual_threads.png", width = 800, height = 400 )
    plot(data_threads, xmax = xmax)
    dev.off()



*/
</code></pre>
</div>
