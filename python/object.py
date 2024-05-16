import cv2
import requests
from ultralytics import YOLO
import math
import time
import firebase_admin
from firebase_admin import db, credentials

# Load a model
model = YOLO('yolov8s.pt')

# Initialize Firebase
cred = credentials.Certificate("credentials.json")
firebase_admin.initialize_app(cred, {
    "databaseURL": "https://thirdeye-7a6d6-default-rtdb.firebaseio.com"
})

# Reference to the Firebase database node containing the 'conn' value
conn_ref = db.reference("/conn")

# Define object classes
classNames = ["person", "bicycle", "car", "motorbike", "aeroplane", "bus", "train", "truck", "boat",
              "traffic light", "fire hydrant", "stop sign", "parking meter", "bench", "bird", "cat",
              "dog", "horse", "sheep", "cow", "elephant", "bear", "zebra", "giraffe", "backpack", "umbrella",
              "handbag", "tie", "suitcase", "frisbee", "skis", "snowboard", "sports ball", "kite", "baseball bat",
              "baseball glove", "skateboard", "surfboard", "tennis racket", "bottle", "wine glass", "cup",
              "fork", "knife", "spoon", "bowl", "banana", "apple", "sandwich", "orange", "broccoli",
              "carrot", "hot dog", "pizza", "donut", "cake", "chair", "sofa", "pottedplant", "bed",
              "diningtable", "toilet", "tvmonitor", "laptop", "mouse", "remote", "keyboard", "cell phone",
              "microwave", "oven", "toaster", "sink", "refrigerator", "book", "clock", "vase", "scissors",
              "teddy bear", "hair drier", "toothbrush"
              ]

# Pixel-to-Centimeter Conversion Factor (hypothetical, adjust as needed)
pixel_to_cm = 0.1

def calculate_distance(point1, point2):
    # Calculate distance in pixels
    distance_pixels = math.sqrt((point1[0] - point2[0]) ** 2 + (point1[1] - point2[1]) ** 2)

    # Convert distance to centimeters
    distance_cm = distance_pixels * pixel_to_cm
    return distance_cm

# ESP32 URL
URL = "http://192.168.128.82"

# Camera set up
cap = cv2.VideoCapture(URL + ":81/stream")

# Set resolution and quality
try:
    requests.get(URL + "/control?var=framesize&val={}".format(8))
    requests.get(URL + "/control?var=quality&val={}".format(2))
except Exception as e:
    print("SET_RESOLUTION: Something went wrong:", e)

# Variable to store the previous label
prev_label = None

# Variable to store the timestamp of the last label
last_label_time = time.time()

while True:
    if cap.isOpened():
        conn_ref.set(True)
        ret, frame = cap.read()
        if ret:
            # Object detection
            results = model(frame, show=True, conf=0.65, verbose=False, save=False)

            # Process detected objects
            for r in results:
                boxes = r.boxes
                for box in boxes:
                    x1, y1, x2, y2 = box.xyxy[0]
                    x1, y1, x2, y2 = int(x1), int(y1), int(x2), int(y2)

                    conf = math.ceil((box.conf[0] * 100)) / 100

                    # Calculate distance
                    distance = calculate_distance((x1, y1), (x2, y2))

                    if distance >= 6.0 and conf > 0.65:  # Adjust the threshold as needed
                        cls = int(box.cls[0])
                        class_name = classNames[cls]
                        label = f'{class_name} '
                        label2 = f'{class_name} - {conf:.2f}, Distance: {distance:.2f} cm'

                        # Check if the label is different from the previous label
                        if label != prev_label:
                            # Check if 3 seconds have passed since the last label
                            if time.time() - last_label_time >= 2:
                                # Render the label on the frame
                               # cv2.putText(frame, label2, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)
                                print(label)
                                print(label2)

                                # Update the previous label and timestamp
                                prev_label = label
                                try:
                                    # Update Firebase
                                    ref = db.reference("/")
                                    db.reference("/").update({"name": label})
                                    last_label_time = time.time()
                                except firebase_admin.exceptions.FirebaseError as firebase_error:
                                    print(f"Firebase error: {firebase_error}")
                                except Exception as e:
                                    print(f"An unexpected error occurred: {e}")

                        #cv2.rectangle(frame, (x1, y1), (x2, y2), (255, 0, 255), 3)
                        #cv2.putText(frame, label, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 255), 2)

            # Display the frame
           # cv2.imshow('Object Detection', frame)
    else:
        print("Error: Failed to capture frame")
        break

    # Break the loop if 'q' key is pressed
    key = cv2.waitKey(1) & 0xFF
    if key == ord('q'):
        break

# Set 'conn' to False before exiting the loop
conn_ref.set(False)

# Release resources
cv2.destroyAllWindows()
cap.release()
