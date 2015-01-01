#!/bin/bash
echo "======= start repo sync ======="
repo --trace --time --always-track-progress sync -c -j10
while [ $? == 1 ]; do
    echo "====== sync failed! re-sync again ====="
    sleep 3
    repo --trace --time --always-track-progress sync -c -j10
done
