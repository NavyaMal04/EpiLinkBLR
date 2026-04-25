$ErrorActionPreference = "Stop"

Write-Host "=== EpiLink BLR Phase 2 ==="

Write-Host "--- Task 1: GCP Setup ---"
.\setup_gcp.ps1

Write-Host "--- Task 2: Create BQ Tables ---"
python create_bq_tables.py

Write-Host "--- Task 3: Fetch Weather ---"
python fetch_weather.py

Write-Host "--- Task 4: Generate Synthetic Data ---"
python generate_synthetic_data.py

Write-Host "--- Task 5: Setup Firebase ---"
python setup_firebase.py

Write-Host "--- Task 6: Verification ---"
python verify_phase2.py

Write-Host "All tasks completed successfully."
