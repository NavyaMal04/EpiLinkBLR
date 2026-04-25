import os
import sys
import numpy as np
import tensorflow as tf
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import GlobalAveragePooling2D, Dense, Dropout
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint
from sklearn.metrics import confusion_matrix
from sklearn.utils.class_weight import compute_class_weight
import json

def main():
    dataset_dir = './dataset/'
    
    train_ds = tf.keras.utils.image_dataset_from_directory(
        dataset_dir,
        validation_split=0.2,
        subset="training",
        seed=123,
        image_size=(224, 224),
        batch_size=32,
        class_names=['negative', 'positive']
    )
    
    val_ds = tf.keras.utils.image_dataset_from_directory(
        dataset_dir,
        validation_split=0.2,
        subset="validation",
        seed=123,
        image_size=(224, 224),
        batch_size=32,
        class_names=['negative', 'positive']
    )
    
    normalization_layer = tf.keras.layers.Rescaling(1./255)
    train_ds = train_ds.map(lambda x, y: (normalization_layer(x), y))
    val_ds = val_ds.map(lambda x, y: (normalization_layer(x), y))
    
    # Compute class weights
    labels = []
    for _, batch_labels in train_ds:
        labels.extend(batch_labels.numpy())
    labels = np.array(labels)
    
    classes = np.unique(labels)
    class_weights_array = compute_class_weight(class_weight='balanced', classes=classes, y=labels)
    class_weights = {classes[i]: class_weights_array[i] for i in range(len(classes))}
    
    # Force positive class (1) to be weighted higher to penalize false negatives more
    class_weights[1] *= 1.1
    
    ratio = class_weights[1] / class_weights[0]
    print(f"\nComputed Class Weights: {class_weights}")
    print(f"Penalty Ratio (Positive/Negative): {ratio:.2f}")
    
    # Stage 1: Freeze base model
    base_model = MobileNetV2(input_shape=(224, 224, 3), include_top=False, weights='imagenet')
    base_model.trainable = False
    
    model = Sequential([
        base_model,
        GlobalAveragePooling2D(),
        Dense(128, activation='relu'),
        Dropout(0.3),
        Dense(1, activation='sigmoid')
    ])
    
    model.compile(optimizer=Adam(learning_rate=0.0001),
                  loss='binary_crossentropy',
                  metrics=['accuracy'])
                  
    os.makedirs('./models', exist_ok=True)
    best_model_path = './models/mrdt_classifier.keras'
    
    callbacks_stage1 = [
        EarlyStopping(patience=5, restore_best_weights=True),
        ModelCheckpoint(best_model_path, save_best_only=True, monitor='val_accuracy', mode='max')
    ]
    
    print("\n" + "="*50)
    print("STAGE 1: Training top layers (base frozen)")
    print("="*50)
    model.fit(train_ds, validation_data=val_ds, epochs=20, class_weight=class_weights, callbacks=callbacks_stage1)
    
    # Stage 2: Unfreeze last 30 layers
    print("\n" + "="*50)
    print("STAGE 2: Fine-tuning last 30 layers of MobileNetV2 base")
    print("="*50)
    
    base_model.trainable = True
    for layer in base_model.layers[:-30]:
        layer.trainable = False
        
    model.compile(optimizer=Adam(learning_rate=0.00001),
                  loss='binary_crossentropy',
                  metrics=['accuracy'])
                  
    callbacks_stage2 = [
        EarlyStopping(patience=3, restore_best_weights=True),
        ModelCheckpoint(best_model_path, save_best_only=True, monitor='val_accuracy', mode='max')
    ]
    
    model.fit(train_ds, validation_data=val_ds, epochs=10, class_weight=class_weights, callbacks=callbacks_stage2)
    
    # Evaluate
    val_loss, val_acc = model.evaluate(val_ds)
    print(f"\nFinal Validation Accuracy: {val_acc:.4f}")
    
    # Generate confusion matrix with 0.35 threshold
    y_true = []
    y_pred = []
    for images, batch_labels in val_ds:
        preds = model.predict(images, verbose=0)
        y_pred.extend([1 if p > 0.35 else 0 for p in preds])
        y_true.extend(batch_labels.numpy())
        
    cm = confusion_matrix(y_true, y_pred)
    print("\nConfusion Matrix (Threshold 0.35):")
    print(cm)
    
    tn, fp, fn, tp = cm.ravel()
    sensitivity = tp / (tp + fn) if (tp + fn) > 0 else 0
    print(f"Sensitivity (True Positive Rate): {sensitivity:.4f}")
    
    if sensitivity < 0.75:
        print("CRITICAL: Model sensitivity too low for medical use — do not deploy")
        sys.exit(1)

    # Save accuracy to a json for the prepare_flutter_assets script
    with open('val_accuracy.json', 'w') as f:
        json.dump({'val_accuracy': float(val_acc)}, f)

if __name__ == "__main__":
    main()
