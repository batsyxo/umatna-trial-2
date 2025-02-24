import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:umatna_trial_2/components/nav_bar.dart';

class HomePage extends StatelessWidget{
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  //sign user out method
  void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        //backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      drawer: NavBar(email: user.email!),
      body: Center(
          child: Text(
        "LOGGED IN AS: ${user.email!}",
        style: const TextStyle(fontSize: 20),
      )),
    );
  }
}