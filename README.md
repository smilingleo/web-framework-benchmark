# Web Framework Benchmark Test

The purpose of this test is to get a rough idea about the performance difference between web frameworks of different languages. In this test, the candidates are:

* Java ([dropwizard](https://github.com/dropwizard/dropwizard))
* Node ([express](https://www.npmjs.com/package/express) + [cluster](https://www.npmjs.com/package/express-cluster))
    Note: Because `node` is single-threaded, to have a reasonable comparison, I use `express-cluster` to have 4 workers.
* Rust ([actix-web](https://github.com/actix/actix-web))
* Go ([echo](https://github.com/labstack/echo))
* Python ([flask](https://github.com/pallets/flask/))

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
cd rust
cargo build --release
```

### Java

```bash
cd java
mvn clean package
```

### Node

```bash
cd node
npm install
```

### Go

```bash
cd go
go get -u github.com/labstack/echo/...
go build -o target/server
```

### Python

```bash
pip3 install -U Flask
```

## Run

```
./test.sh
```

## Report

I tuned the `threads` and `connections`, and picked up the highest throughput record for each language.

|Language|Threads|Connections|Requests/Sec|Transfer/Sec|CPU%|Mem|
|----|----|----|----|----|----|----|
|Node|4|100|32744.43|7.40MB|~400%|~240Mb|
|Java|8|60|46305.79|4.98MB|**~600%**|**~880Mb**|
|Rust|4|60|75168.54|9.53MB|~300%|~30Mb|
|Go|4|100|**86007.14**|12.55MB|~380%|~9Mb|
|Python|4|100|**512.77**|89.76Kb|~95%|~25Mb|

**TODO:** I run python with `flask run` which is not recommended in production, will use Nginx later.

From the above comparison, do you feel `Java` is so lame like I do? It consumed almost 30 times memory and 2 times CPU usage, and produced only **half** throughput comparing to `Rust`.
