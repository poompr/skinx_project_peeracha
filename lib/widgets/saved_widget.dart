import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Savedwidget extends StatelessWidget {
  final int type;
  final String docpartyID;

  final String userID;
  Savedwidget(
      {Key? key,
      required this.type,
      required this.docpartyID,
      required this.userID})
      : super(key: key);
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('user');
  final CollectionReference _partyCollection =
      FirebaseFirestore.instance.collection('party');
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(userID)
            .collection('saved')
            .where(FieldPath.documentId, isEqualTo: docpartyID)
            //https://petercoding.com/firebase/2020/04/04/using-cloud-firestore-in-flutter/ //
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return GestureDetector(
                onTap: () async {
                  await _userCollection
                      .doc(userID)
                      .collection('saved')
                      .doc(docpartyID)
                      .set({
                    'docpartyid': docpartyID,
                    'createdat': DateTime.now().millisecondsSinceEpoch
                  });
                  await _userCollection
                      .doc(userID)
                      .update({'numsaved': FieldValue.increment(1)});
                  await _partyCollection
                      .doc(docpartyID)
                      .collection('saved')
                      .doc(userID)
                      .set({
                    'uid': userID,
                    'createdat': DateTime.now().millisecondsSinceEpoch
                  });
                  await _partyCollection
                      .doc(docpartyID)
                      .update({'numfollower': FieldValue.increment(1)});
                },
                child: Icon(
                  Icons.bookmark_add_outlined,
                  size: type == 2 ? 22 : 16,
                  color: const Color.fromARGB(202, 0, 0, 0),
                ));
          } else {
            return Column(
                children: snapshot.data!.docs.map((document1) {
              // var nameid = document1.id;
              return GestureDetector(
                  onTap: () async {
                    await document1.reference.delete();
                    await _userCollection
                        .doc(userID)
                        .update({'numsaved': FieldValue.increment(-1)});
                    await _partyCollection
                        .doc(docpartyID)
                        .collection('saved')
                        .doc(userID)
                        .delete();
                    await _partyCollection
                        .doc(docpartyID)
                        .update({'numsaved': FieldValue.increment(-1)});
                  },
                  child: Icon(
                    Icons.bookmark,
                    size: type == 2 ? 22 : 16,
                  ));
            }).toList());
          }
        });
  }
}
