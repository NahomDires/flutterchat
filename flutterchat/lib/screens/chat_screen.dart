import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterchat/models/message.dart';
import 'package:flutterchat/services/auth_service.dart';
import 'package:flutterchat/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String userId = _auth.getCurrentUserUid()!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _firestore.getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List<Message> messages = snapshot.data!;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      Message message = messages[index];
                      return ListTile(
                        title: message.text != null ? Text(message.text) : null,
                        subtitle: Text('Sent by: ${message.senderId}'),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter message',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    String text = _textController.text.trim();
                    if (text.isNotEmpty) {
                      await _firestore.addMessage(
                        Message(
                          text: text,
                          senderId: userId,
                          receiverId: '',
                          timestamp: Timestamp.fromMillisecondsSinceEpoch(
                              DateTime.now().millisecondsSinceEpoch),
                        ),
                      );
                      _textController.clear();
                    }
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
