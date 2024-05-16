import 'package:flutter/material.dart';
import 'package:thirdeyeapp/pages/logout.dart';
import 'package:thirdeyeapp/pages/userform.dart';

void main() {
  runApp(SettingsPage());
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Theme',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SwitchListTile(
                title: Text('Dark Mode'),
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                'Account Info',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              ListTile(
                title: Text('Edit Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserForm(
                        onSubmit: (name, email, phone, address) {
                          // This callback function does nothing
                        },
                      ),
                    ),
                  );
                },
              ),
            
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  // Navigate to logout page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogoutPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
