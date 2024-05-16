import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class UserForm extends StatefulWidget {
  final Function(String, String, String, String) onSubmit;

  const UserForm({required this.onSubmit});

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _phone = '';
  String _address = '';

  final databaseReference = FirebaseDatabase.instance.reference();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone'),
                onSaved: (value) => _phone = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                onSaved: (value) => _address = value!,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Store user information in Firebase Realtime Database
                    databaseReference.child("users").push().set({
                      'name': _name,
                      'email': _email,
                      'phone': _phone,
                      'address': _address,
                    }).then((_) {
                      print('Transaction  committed.');
                    });

                    // Invoke the callback function to pass the details
                    widget.onSubmit(_name, _email, _phone, _address);
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
