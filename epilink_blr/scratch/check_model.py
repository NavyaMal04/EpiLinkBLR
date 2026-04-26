import tensorflow as tf

interpreter = tf.lite.Interpreter(model_path='d:/EpiLinkBLR/epilink_blr/assets/models/mrdt_classifier.tflite')
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

print(f"Input details: {input_details}")
print(f"Output details: {output_details}")
