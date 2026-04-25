#!/bin/bash
set -e

trap 'echo "Task failed: Last executed command exited with non-zero code."; exit 1' ERR

echo "=== EpiLink BLR Phase 2 ==="

echo "--- Task 1: GCP Setup ---"
bash setup_gcp.sh

echo "--- Task 2: Create BQ Tables ---"
python create_bq_tables.py

echo "--- Task 3: Fetch Weather ---"
python fetch_weather.py

echo "--- Task 4: Generate Synthetic Data ---"
python generate_synthetic_data.py

echo "--- Task 5: Setup Firebase ---"
python setup_firebase.py

echo "--- Task 6: Verification ---"
python verify_phase2.py

echo "All tasks completed successfully."
