import 'package:eye/firebase_options.dart';
import 'package:eye/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:eye/pages/loginpage.dart';
import 'package:eye/pages/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbRef = FirebaseDatabase.instance.reference();
  bool isConnected = false;
  String name = '';
  String dir = '';
  String read = '';
  String reqData = '';
  FlutterTts flutterTts = FlutterTts();
  stt.SpeechToText _speech = stt.SpeechToText();
  String _recognizedText = '';

  @override
  void initState() {
    super.initState();
    checkSpeechPermissions(); // Check and request speech recognition permissions
    getData();
    flutterTts.setErrorHandler((msg) {
      print("An error occurred in the text-to-speech engine: $msg");
    });
  }

  Future<void> checkSpeechPermissions() async {
    PermissionStatus permissionStatus = await Permission.speech.status;
    if (permissionStatus != PermissionStatus.granted) {
      await Permission.speech.request();
    }
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(
        onResult: (result) {
          setState(() {
            _recognizedText = result.recognizedWords;
            // Automatically update data to Firebase when new speech input is recognized
            updateDataToFirebase();
          });
        },
      );
    } else {
      print('The user has denied access to speech recognition.');
    }
  }

  void getData() {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

    // Listen for changes on the "conn" node
    databaseReference.child('conn').onValue.listen((event) {
      final value = event.snapshot.value;
      if (value is bool) {
        setState(() {
          isConnected = value;
          if (isConnected) {
            retrieveNameAndDir();
          }
        });
        print('Connection status : $isConnected');
      } else {
        print('The received data is not a boolean value.');
      }
    });
  }

  void retrieveNameAndDir() {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

    // Listen for changes on the "name" node
    databaseReference.child('name').onValue.listen((event) {
      final value = event.snapshot.value;
      if (value is String) {
        setState(() {
          name = value;
        });
        print('Name from database: $name');

        // Speak the name automatically when it changes
        speak(name);
      } else {
        print('The received data is not a string value.');
      }
    });

    // Listen for changes on the "dir" node
    databaseReference.child('dir').onValue.listen((event) {
      final value = event.snapshot.value;
      if (value is String) {
        setState(() {
          dir = value;
        });
        print('Dir from database: $dir');

        // Speak the dir automatically when it changes
        speak(dir);
      } else {
        print('The received data is not a string value.');
      }
    });

        // Listen for changes on the "raed" node
    databaseReference.child('read').onValue.listen((event) {
      final value = event.snapshot.value;
      if (value is String) {
        setState(() {
          read = value;
        });
        print('Read from database: $read');

        // Speak the dir automatically when it changes
        speak(read);
      } else {
        print('The received data is not a string value.');
      }
    });
  }

  Future<void> speak(String text) async {
    // Check if text is empty or null
    if (text == null || text.isEmpty) {
      print("Text-to-speech failed: Empty or null text provided.");
      return;
    }

    // Check if text-to-speech engine is available
    if (!await flutterTts.isLanguageAvailable("en-US")) {
      print("Text-to-speech engine is not available.");
      return;
    }

    // Speak the text
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    var result = await flutterTts.speak(text);
    if (result == 1) {
      print("Text-to-speech is successful");
    } else {
      print("Text-to-speech failed");
    }
  }

  void updateDataToFirebase() {
    if (_recognizedText.isNotEmpty && isConnected) {
      // Update only if isConnected is true
      dbRef.child('req').set(_recognizedText); // Update the value in "req" node
      _recognizedText = ''; // Clear the speech input after updating Firebase
    } else {
      print(
          'Please ensure connection is established and speech input is recognized.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HOME',
          style: TextStyle(
            color: Color.fromARGB(255, 2, 2, 2),
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFA8A7A5),
        leading: IconButton(
          onPressed: () {
            // Handle back button press here
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 6, 6, 6),
            size: 35,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings), // create new account
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SettingsPage()), // Navigate to sign up page
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _startListening, // Call _startListening method when tapped anywhere on the screen
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("lib/images/device.png"),
              SizedBox(height: 20),
              Text(
                isConnected
                    ? 'Connected'
                    : 'Disconnected', // Display connection status
                style: TextStyle(
                  fontSize: 20,
                  color: isConnected
                      ? Colors.green
                      : Colors.red, // Change color based on status
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text('$_recognizedText'),
              SizedBox(height: 20),
              TextButton(
                onPressed: _startListening,
                child: Text('Tap anywhere to start listening'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
