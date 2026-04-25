import os
import shutil
import json
from datetime import datetime

def main():
    os.makedirs('./flutter_assets/assets/models', exist_ok=True)
    
    tflite_path = './models/mrdt_classifier.tflite'
    dest_path = './flutter_assets/assets/models/mrdt_classifier.tflite'
    
    if os.path.exists(tflite_path):
        shutil.copy2(tflite_path, dest_path)
    else:
        print(f"Error: {tflite_path} not found.")
        return
        
    val_acc = "0.0"
    if os.path.exists('val_accuracy.json'):
        with open('val_accuracy.json', 'r') as f:
            data = json.load(f)
            val_acc = f"{data.get('val_accuracy', 0.0):.4f}"
            
    metadata = {
        "model_name": "mrdt_classifier",
        "version": "1.0.0",
        "input_shape": [1, 224, 224, 3],
        "output_classes": ["negative", "positive"],
        "threshold": 0.35,
        "quantized": True,
        "trained_on": datetime.now().strftime("%Y-%m-%d"),
        "val_accuracy": val_acc
    }
    
    metadata_path = './flutter_assets/assets/models/model_metadata.json'
    with open(metadata_path, 'w') as f:
        json.dump(metadata, f, indent=2)
        
    print("\n--- Flutter Assets Prepared Successfully ---")
    print(f"Files saved to: {os.path.dirname(dest_path)}")
    print("\nPlease add the following lines to your Flutter pubspec.yaml file:")
    print("----------------------------------------------------------------")
    print("flutter:")
    print("  assets:")
    print("    - assets/models/mrdt_classifier.tflite")
    print("    - assets/models/model_metadata.json")
    print("----------------------------------------------------------------")

if __name__ == "__main__":
    main()
