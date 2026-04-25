Write-Host "Starting EpiLink BLR Phase 1..."

Write-Host "[1/5] Extracting images from docx files..."
python extract_images.py --positive "PositivemRDT.docx" --negative "test strips negavtive.docx"
if ($LASTEXITCODE -ne 0) { Write-Error "ERROR: Phase 1 pipeline failed at step 1"; exit $LASTEXITCODE }

Write-Host "[2/5] Augmenting dataset..."
python augment_dataset.py
if ($LASTEXITCODE -ne 0) { Write-Error "ERROR: Phase 1 pipeline failed at step 2"; exit $LASTEXITCODE }

Write-Host "[3/5] Training model..."
python train_model.py
if ($LASTEXITCODE -ne 0) { Write-Error "ERROR: Phase 1 pipeline failed at step 3"; exit $LASTEXITCODE }

Write-Host "[4/5] Converting model to TFLite..."
python convert_to_tflite.py
if ($LASTEXITCODE -ne 0) { Write-Error "ERROR: Phase 1 pipeline failed at step 4"; exit $LASTEXITCODE }

Write-Host "[5/5] Preparing Flutter assets..."
python prepare_flutter_assets.py
if ($LASTEXITCODE -ne 0) { Write-Error "ERROR: Phase 1 pipeline failed at step 5"; exit $LASTEXITCODE }

Write-Host "Done! Phase 1 completed successfully."
