

import 'package:flutter/material.dart';
import 'package:thirdeyeapp/pages/loginpage.dart';
import 'package:thirdeyeapp/pages/logout.dart';
import 'package:thirdeyeapp/pages/settings.dart';
import 'package:thirdeyeapp/pages/spects.dart';

class ProfilePage extends StatelessWidget {
  final String email;
  final String deviceId;

  ProfilePage({required this.email, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          if (email.isNotEmpty) // Check if email is not empty (logged in)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogoutPage()),
                );
              },
            ),
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          if (email.isEmpty) // Check if email is empty (not logged in)
            IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (email.isNotEmpty) // Check if email is not empty (logged in)
              Center(
                child: Icon(Icons.person, size: 50),
              ),
            SizedBox(height: 20),
            if (email.isNotEmpty) // Check if email is not empty (logged in)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'Email: $email',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            SizedBox(height: 20),
            if (email.isNotEmpty) // Check if email is not empty (logged in)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.device_hub, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'Device ID: $deviceId',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            if (email.isEmpty) // Check if email is empty (not logged in)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Please log in to view your profile.',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    IconButton(
                      icon: Icon(Icons.person_add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      iconSize: 40, // Adjust icon size as needed
                      color: Colors.black, // Change icon color
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
