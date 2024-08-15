import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Create TextEditingControllers for each form field
  final TextEditingController _userTagController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // Get the current user from FirebaseAuth
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _userTagController.dispose();
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final userTag = _userTagController.text;
      final name = _nameController.text;
      final bio = _bioController.text;
      final email = user.email;

      // Save the data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(email).set({
        'userTag': userTag,
        'name': name,
        'email': email,
        'bio': bio,
      }, SetOptions(merge: true)); // merge: true will update existing fields

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile Saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _userTagController,
                decoration: const InputDecoration(labelText: 'User Tag'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a user tag';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              // Display the email in a Text widget
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Email: ${user.email!}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
