import cv2
import pytesseract
import time
import firebase_admin
from firebase_admin import db, credentials

# Set the path to the Tesseract executable
pytesseract.pytesseract.tesseract_cmd = r'C:/Program Files/Tesseract-OCR/tesseract.exe'
# ESP32 URL
URL = "http://192.168.128.82"

# Firebase initialization
cred = credentials.Certificate("credentials.json")
firebase_admin.initialize_app(cred, {
    "databaseURL": "https://thirdeye-7a6d6-default-rtdb.firebaseio.com"
})

def extract_and_print_unique_text_from_webcam():
    try:
        # Open the webcam
        #cap = cv2.VideoCapture(0)  # 0 corresponds to the default camera
        cap = cv2.VideoCapture(URL + ":81/stream")

        # Check if the webcam is opened successfully
        if not cap.isOpened():
            print("Error: Unable to open the webcam.")
            return

        # Initialize variables to store text from the previous frame
        previous_text = ""
        last_printed_text = ""
        last_print_time = time.time()
        while True:
            # Read a frame from the webcam
            ret, frame = cap.read()
            if not ret:
                print("Error: Unable to read frame from the webcam.")
                break

            # Convert the frame to grayscale for better OCR performance
            gray_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

            # Extract text using Tesseract OCR
            text = pytesseract.image_to_string(gray_frame)
            text2 = text.strip().lower()

            # Compare text with the previous frame
            if text2 != previous_text:
                # Print the text if it is different from the last printed text
                if text2 != last_printed_text:
                    current_time = time.time()
                    # Check if 5 seconds have passed since the last print
                    if current_time - last_print_time >= 5:
                        print(f'Text: {text2}')
                        db.reference("/").update({"read": text2})


                        # Save the frame as an image when text is detected
                        cv2.imwrite("captured_image.jpg", frame)

                        # Read text from the captured image
                        captured_image = cv2.imread("captured_image.jpg")
                        captured_text = pytesseract.image_to_string(cv2.cvtColor(captured_image, cv2.COLOR_BGR2GRAY))
                        captured_text2 = captured_text.lower()
                        print(f'Text from captured image: {captured_text2}')

                        # Update last_printed_text and last_print_time
                        last_printed_text = text2
                        last_print_time = current_time

            # Update previous_text for the next iteration
            previous_text = text.strip()

            # Display the frame
            cv2.imshow("Webcam", frame)

            # Check for the 'q' key to exit the loop
            if cv2.waitKey(1) & 0xFF == ord('q'):
                print("Exiting...")
                break

            # Delay for smoother execution
            time.sleep(0.1)

        # Release the webcam and close all windows
        cap.release()
        cv2.destroyAllWindows()

    except Exception as e:
        print(f'Error: {e}')

# Call the function to start webcam processing
extract_and_print_unique_text_from_webcam()
