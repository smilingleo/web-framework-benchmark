# Web Framework Benchmark Test

The purpose of this test is to get a rough idea about the performance difference between web frameworks of different languages. In this test, the candidates are:

* Java (dropwizard)
* Node (express + cluster)
    Note: Because `node` is single-threaded, to have a reasonable comparison, I use `express-cluster` to have 4 workers.
* Rust (actix-web)

## Tools

* [wrk](https://github.com/wg/wrk)

Note: `ab` is not a good choice, because 1) default to use `HTTP/1.0`, 2) [only use one thread regardless the concurrency](https://en.wikipedia.org/wiki/ApacheBench) which itself will become a bottleneck.

## Build

### rust

```
cargo build --release
```

### Java

```
mvn clean package
```

### Node

```
npm install
```

## Run

```
./test.sh > report.log
```

## Report

I tuned the `threads` and `connections`, and picked up the highest throughput record for each language.

|Language|Threads|Connections|Requests/Sec|Transfer/Sec|CPU%|Mem|
|----|----|----|----|----|----|----|
|Node|4|200|**33030.43**|7.47MB|~400%|~240Mb|
|Java|8|60|**38787.85**|4.92MB|~600%|~880Mb|
|Rust|8|60|**74511.95**|9.45MB|~300%|~30Mb|

From the above comparison, do you feel `Java` is so lame like me did? It consumed almost 30 times memory and 2 times CPU usage, and produced only **half** throughput comparing to `Rust`.
