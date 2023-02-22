import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterchat/models/message.dart';
import 'package:flutterchat/models/user.dart';

class FirestoreService {
  final CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('messages');
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<List<Message>> getMessages() {
    return _messagesCollection.orderBy('timestamp').snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map(
              (doc) =>
                  Message.fromMap(doc.data() as Map<String, dynamic>, doc.id),
            )
            .toList();
      },
    );
  }

  Future<void> sendMessage(String text, String senderUid, String senderName) {
    return _messagesCollection.add({
      'text': text,
      'senderUid': senderUid,
      'senderName': senderName,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addMessage(Message message) async {
    await _messagesCollection.add(message.toMap());
  }

  Stream<List<User>> getUsers() {
    return _usersCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map(
              (doc) => User.fromMap(doc.data() as Map<String, dynamic>, doc.id),
            )
            .toList();
      },
    );
  }
}
