import 'package:flutter/material.dart';
import 'package:flutterchat/screens/chat_screen.dart';
import 'package:flutterchat/screens/profile_screen.dart';
import 'package:flutterchat/screens/settings_screen.dart';
import 'package:flutterchat/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.chat)),
              Tab(icon: Icon(Icons.contacts)),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            ChatScreen(),
            ContactsScreen(),
            SettingsScreen(),
          ],
        ),
      ),
    );
  }
}

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: usersCollection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }

        List<Widget> userWidgets = [];
        snapshot.data?.docs.forEach((doc) {
          userWidgets.add(ListTile(
            title: Text(doc['name']),
            subtitle: Text(doc['email']),
          ));
        });

        return ListView(
          children: userWidgets,
        );
      },
    );
  }
}
