import tensorflow as tf
import os
import numpy as np

def main():
    keras_model_path = './models/mrdt_classifier.keras'
    tflite_model_path = './models/mrdt_classifier.tflite'
    
    if not os.path.exists(keras_model_path):
        print(f"Error: {keras_model_path} not found. Please train the model first.")
        return
        
    print("Loading keras model...")
    model = tf.keras.models.load_model(keras_model_path)
    
    converter = tf.lite.TFLiteConverter.from_keras_model(model)
    
    # Dynamic range quantization
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    tflite_model = converter.convert()
    
    with open(tflite_model_path, 'wb') as f:
        f.write(tflite_model)
        
    original_size = os.path.getsize(keras_model_path) / 1024
    tflite_size = os.path.getsize(tflite_model_path) / 1024
    print(f"Keras model size: {original_size:.2f} KB")
    print(f"TFLite model size: {tflite_size:.2f} KB")
    
    # Sanity check
    print("\nRunning TFLite Sanity Check...")
    interpreter = tf.lite.Interpreter(model_path=tflite_model_path)
    interpreter.allocate_tensors()
    
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    
    def run_inference(image_path):
        if not os.path.exists(image_path):
            print(f"Test image not found: {image_path}")
            return
        img = tf.keras.preprocessing.image.load_img(image_path, target_size=(224, 224))
        img_array = tf.keras.preprocessing.image.img_to_array(img)
        img_array = np.expand_dims(img_array, axis=0) / 255.0
        
        interpreter.set_tensor(input_details[0]['index'], img_array)
        interpreter.invoke()
        output_data = interpreter.get_tensor(output_details[0]['index'])
        score = output_data[0][0]
        label = "positive" if score > 0.35 else "negative"
        print(f"Inference on {os.path.basename(image_path)}: Predicted Label={label}, Confidence={score:.4f}")

    # Pick test images
    import glob
    pos_imgs = glob.glob('./dataset/positive/*.*')
    neg_imgs = glob.glob('./dataset/negative/*.*')
    
    if pos_imgs:
        run_inference(pos_imgs[0])
    if neg_imgs:
        run_inference(neg_imgs[0])
        
    print("TFLite Conversion and sanity check completed successfully.")

if __name__ == "__main__":
    main()
