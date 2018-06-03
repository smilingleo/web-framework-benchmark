#! /bin/bash
# wrk is required.
function perf {
    wrk -t$1 -c$2 -d60s --script=post.lua http://localhost:8080/json-data
}

function run {
    for thread in 4 8 ; do
        for conn in 20 60 100 ; do
            perf $thread $conn
            sleep 30
        done
    done
}

cd rust
echo "test Rust=============="
target/release/actix &
_pid=$!
cd ..
run
kill -9 $_pid
sleep 10

echo "run Node=============="
cd node
node index.js &
_pid=$!
cd ..
run
kill -9 $_pid
sleep 10

echo "run Java=============="
cd java
java -server -Xms1024m -Xmx1024m -jar target/benchmark-1.0-SNAPSHOT.jar server config.yml > /dev/null &
_pid=$!
cd ..
run
kill -9 $_pid

