# Web Framework Benchmark Test

The purpose of this test is to get a rough idea about the performance difference between web frameworks of different languages. In this test, the candidates are:

* Java (dropwizard)
* Node (express + cluster)
    Note: Because `node` is single-threaded, to have a reasonable comparison, I use `express-cluster` to have 4 workers.
* Rust (actix-web)

The test case is really simple, implement the following API with each framework.

```bash
curl -i -X POST \
    -H "content-type: application/json" \
    localhost:8080/json-data \
    -d '{ "name": "leo", "number": 1}'

# expect it returns the same JSON object:
{ "name": "leo", "number": 1}
```

No database access, no network I/O, just the simple JSON serialization/deserialization.

## Tools

* [wrk](https://github.com/wg/wrk)

Note: Apache Benchmark, aka, `ab`, is not a good choice, because 1) default to use `HTTP/1.0`, 2) [only use one thread regardless the concurrency](https://en.wikipedia.org/wiki/ApacheBench) which itself will become a bottleneck.

## Environment

MacBook Pro: 3.1G i7 Processor, 16G 2133 MHZ Memory.

## Build

### rust

```bash
cargo build --release
```

### Java

```bash
mvn clean package
```

### Node

```bash
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
|Node|4|200|33,030.43|7.47MB|~400%|~240Mb|
|Java|8|60|38,787.85|4.92MB|**~600%**|**~880Mb**|
|Rust|8|60|**74,511.95**|9.45MB|~300%|~30Mb|

From the above comparison, do you feel `Java` is so lame like I do? It consumed almost 30 times memory and 2 times CPU usage, and produced only **half** throughput comparing to `Rust`.
