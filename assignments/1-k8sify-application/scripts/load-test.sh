#!/bin/bash
set -e

# Default values
APP_URL=${1:-"http://localhost:3000"}
PRIMES=${2:-100000}
ITERATIONS=${3:-1000}
CONCURRENCY=${4:-20}

# Calculate iterations per worker
ITERATIONS_PER_WORKER=$((ITERATIONS / CONCURRENCY))
REMAINDER=$((ITERATIONS % CONCURRENCY))

echo "Starting load test with the following parameters:"
echo "Target URL: $APP_URL"
echo "Prime number to calculate: $PRIMES"
echo "Total iterations: $ITERATIONS"
echo "Concurrency level: $CONCURRENCY"
echo "Iterations per worker: $ITERATIONS_PER_WORKER"
echo "Remainder iterations: $REMAINDER"
echo ""

# Function to run a worker
run_worker() {
    local worker_id=$1
    local iterations=$2
    local start_time=$(date +%s)

    echo "Worker $worker_id started with $iterations iterations"

    for ((i=1; i<=iterations; i++)); do
        curl -s "$APP_URL/primes/$PRIMES" > /dev/null
        if ((i % 100 == 0)); then
            echo "Worker $worker_id completed $i/$iterations iterations"
        fi
    done

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    echo "Worker $worker_id completed all $iterations iterations in $duration seconds"
}

# Start workers
echo "Starting $CONCURRENCY workers..."
for ((i=1; i<=CONCURRENCY; i++)); do
    # Add one extra iteration to the first REMAINDER workers
    extra_iterations=0
    if ((i <= REMAINDER)); then
        extra_iterations=1
    fi

    run_worker $i $((ITERATIONS_PER_WORKER + extra_iterations)) &
    pids[${i}]=$!
done

# Wait for all workers to complete
echo "Waiting for all workers to complete..."
for pid in ${pids[*]}; do
    wait $pid
done

echo "Load test completed!"
