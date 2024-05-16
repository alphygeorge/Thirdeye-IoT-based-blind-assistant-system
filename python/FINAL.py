import firebase_admin
from firebase_admin import credentials, db
import subprocess
import time

cred = credentials.Certificate("credentials.json")
firebase_admin.initialize_app(cred, {
    "databaseURL": "https://thirdeye-7a6d6-default-rtdb.firebaseio.com"
})
req_ref = db.reference("/req")

# Flag to indicate whether object detection or navigation is running
running_process = None

# Define a function to handle object detection
def perform_object_detection():
    global running_process
    if running_process:
        running_process.kill()  # Stop the currently running process if any
    running_process = subprocess.Popen(["python", "object.py"])

# Define a function to handle navigation
def perform_navigation():
    global running_process
    if running_process:
        running_process.kill()  # Stop the currently running process if any
    running_process = subprocess.Popen(["python", "navigate.py"])

def perform_read():
    global running_process
    if running_process:
        running_process.kill()  # Stop the currently running process if any
    running_process = subprocess.Popen(["python", r"E:\extract text from video using python\SSS.py"])
def perform_stop():
    global running_process
    if running_process:
        running_process.kill()  # Stop the currently running process if any


# Function to handle changes in the Firebase database
def on_req_change(event):
    req = event.data
    print("Given Request", req)
    if req:
        if req == 'object':

            perform_object_detection()
        elif req == 'navigate':
            perform_navigation()
        elif req == 'read':
            perform_read()
        elif req == 'stop':
            perform_stop()
        else:
            print("Unknown request:", req)

# Listen for changes in the 'requests' node and trigger the on_req_change function
req_ref.listen(on_req_change)
