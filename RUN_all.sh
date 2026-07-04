#!/usr/bin/bash
cd src && make clean && make && cd ../util/root_tree && make clean && make && cd ../..

infile_dir="infiles"

jobs=8   # number of parallel processes (adjust as needed)

count=0

for file in "$infile_dir"/*.inp; do
    # skip if no files match
    [ -e "$file" ] || continue

    base=$(basename "$file" .inp)

    echo "Running MC for: $base"

    ./run_mc_single_arm_tree "$base" &

    ((count++))

    # throttle number of background jobs
    if (( count % jobs == 0 )); then
        wait
    fi
done

wait

echo "All MC jobs complete."
