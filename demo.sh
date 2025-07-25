#!/bin/bash
cd ./noir-r1cs/noir-examples/poseidon-rounds && nargo compile && nargo check && cd ../../..
mkdir -p ./artifacts/poseidon-rounds-10

cargo build --release --bin co-spartan --bin noir-r1cs

echo "Compiling Noir proof scheme..."
./target/release/noir-r1cs prepare ./noir-r1cs/noir-examples/poseidon-rounds/target/basic.json -o ./artifacts/poseidon-rounds-10/noir_proof_scheme.json

echo "Generating keys..."
./target/release/co-spartan setup --r1cs-noir-scheme-path ./artifacts/poseidon-rounds-10/noir_proof_scheme.json --artifacts-dir ./artifacts/poseidon-rounds-10 \
    --log-num-workers-per-party 1 

echo "Running coordinator and workers..."
RUST_BACKTRACE=1 mpirun -np 7 ./target/release/co-spartan  work  --artifacts-dir ./artifacts/poseidon-rounds-10 \
    --r1cs-noir-scheme-path ./artifacts/poseidon-rounds-10/noir_proof_scheme.json --r1cs-input-path ./noir-r1cs/noir-examples/poseidon-rounds/Prover.toml \
    --log-num-workers-per-party 1
