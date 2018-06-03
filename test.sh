#! /bin/bash

LOG=output.log

# wrk is required.
function perf {
    wrk -t$1 -c$2 -d30s --script=post.lua http://localhost:8080/json-data
}

function run {
    for thread in 4 8 ; do
        for conn in 60 100 ; do
            #top -pid $_pid -l 1 -s 10 &
            echo "testing $test_lang" >> $LOG
            perf $thread $conn >> $LOG
            sleep 30
        done
    done
}

# remove previous report if exists
if [ -f $LOG ]; then
  rm -f $LOG
fi

cd rust
echo "============== testing Rust =============="
test_lang="Rust"
target/release/actix &
_pid=$!
cd ..
run
kill -9 $_pid
sleep 10

echo "============== testing Node =============="
test_lang="Node"
cd node
node index.js &
_pid=$!
cd ..
run
kill -9 $_pid
sleep 10

echo "============== testing Java =============="
test_lang="Java"
cd java
java -server -Xms1024m -Xmx1024m -jar target/benchmark-1.0-SNAPSHOT.jar server config.yml > /dev/null &
_pid=$!
# need to wait
sleep 10
cd ..
run
kill -9 $_pid
sleep 10

echo "============== testing Go =============="
test_lang="Go"
cd go
target/server &
_pid=$!
cd ..
run
kill -9 $_pid

echo "============== testing Python =============="
test_lang="Python"
cd python
flask run --port=8080 &
_pid=$!
cd ..
run
kill -9 $_pid

##
## Report in markdown format
##

a=($(cat $LOG | grep 'connections' | awk '{print $1","$4}'))
b=($(cat $LOG | grep 'Requests/sec' | awk '{print $2}'))
l=($(cat $LOG | grep 'testing' | awk '{print $2}'))

len_a=${#a[@]}
len_b=${#b[@]}

if [ $len_a -ne $len_b ]; then
    echo "misformatted report, error happened?"
    exit 1
fi

echo "Language | Threads | Connections | Throughput"
echo "---|---|---|---"
idx=0
while [ "$idx" != "$len_a" ]; do
    echo ${l[$idx]}","${a[$idx]}","${b[$idx]} | sed -e 's/,/|/g'
    let idx=$idx+1
done