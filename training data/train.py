from ultralytics import YOLO

# Load a model
model = YOLO("yolov8l.yaml")  # build a new model from scratch

file_path = "C:/Users/Oluwatosin/py_projects/web_stream/train_model_and_predict/config.yaml"

# Use the model
results = model.train(data=file_path, epochs=300, imgsz=416)  # train the model