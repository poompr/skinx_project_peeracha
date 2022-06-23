import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'text.dart';

class Detailusers {
  String? username;

  int? phonenumber;
  Detailusers({required this.username, required this.phonenumber});
}

class Profilename extends StatelessWidget {
  final String? uid;
  final double size;
  const Profilename({Key? key, required this.uid, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where('uid', isEqualTo: uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(child: TextBwidget(name: 'Empty', size: 12));
          }
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: snapshot.data!.docs.map((document) {
                return TextBwidget(name: document['username'], size: size);
              }).toList());
        });
  }
}
