#!/bin/bash
set -e

error_handler() {
  echo "ERROR: Phase 1 pipeline failed! A script exited with a non-zero code. Check the logs above."
  exit 1
}

trap 'error_handler' ERR

echo "Starting EpiLink BLR Phase 1..."

echo "[1/5] Extracting images from docx files..."
python extract_images.py --positive "PositivemRDT.docx" --negative "test strips negavtive.docx"

echo "[2/5] Augmenting dataset..."
python augment_dataset.py

echo "[3/5] Training model..."
python train_model.py

echo "[4/5] Converting model to TFLite..."
python convert_to_tflite.py

echo "[5/5] Preparing Flutter assets..."
python prepare_flutter_assets.py

echo "Done! Phase 1 completed successfully."
