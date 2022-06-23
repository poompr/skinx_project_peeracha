import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Likebutton extends StatelessWidget {
  final String docID;
  final String userID;
  Likebutton({
    Key? key,
    required this.docID,
    required this.userID,
  }) : super(key: key);
  final CollectionReference _partyCollection =
      FirebaseFirestore.instance.collection('party');
  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance
        .collection('party')
        .doc(docID)
        .collection('liked')
        .where('uid', isEqualTo: userID)
        //https://petercoding.com/firebase/2020/04/04/using-cloud-firestore-in-flutter/ //
        .snapshots();

    return StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return GestureDetector(
                onTap: () async {
                  await _partyCollection
                      .doc(docID)
                      .collection('liked')
                      .doc(userID)
                      .set({
                    'uid': userID,
                    'createddate': DateTime.now().millisecondsSinceEpoch
                  });
                  await _partyCollection
                      .doc(docID)
                      .update({'numliked': FieldValue.increment(1)});
                },
                child: const Icon(
                  Icons.favorite_border,
                  size: 16,
                  color: Colors.deepOrange,
                ));
          } else {
            return Column(
                children: snapshot.data!.docs.map((document1) {
              // var nameid = document1.id;
              return GestureDetector(
                  onTap: () async {
                    await document1.reference.delete();
                    await _partyCollection
                        .doc(docID)
                        .update({'numliked': FieldValue.increment(-1)});
                  },
                  child: const Icon(
                    Icons.favorite,
                    size: 16,
                    // ignore: prefer_interpolation_to_compose_strings
                  ));
            }).toList());
          }
        });
  }
}
