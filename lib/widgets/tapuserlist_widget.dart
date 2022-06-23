import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constans/text.dart';
import 'profileindex_widget.dart';

class Tapuserlistwidget extends StatelessWidget {
  final String usernameIndex;
  final String uidIndex;
  final int tapcontrl;
  final String userID;
  Tapuserlistwidget(
      {Key? key,
      required this.uidIndex,
      required this.tapcontrl,
      required this.usernameIndex,
      required this.userID})
      : super(key: key);

  final auth = FirebaseAuth.instance;
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection("user");

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: tapcontrl,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TextSwhitewidget(name: usernameIndex, size: 20),
          toolbarHeight: 30,
          elevation: 1,
          backgroundColor: Colors.deepOrange,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                height: 30,
                child: TextSwhitewidget(name: ' ติดตามผู้อื่น ', size: 13),
              ),
              Tab(
                height: 30,
                child: TextSwhitewidget(name: ' ผู้ติดตาม ', size: 13),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            followpage(),
            followerpage(),
          ],
        ),
      ),
    );
  }

  Widget followpage() => StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(uidIndex)
          .collection('follow')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data!.docs.map((document) {
            final String uidIndex = document['uid'];
            return profilewidget(uidIndex);
          }).toList(),
        );
      });

  Widget followerpage() => StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(uidIndex)
          .collection('follower')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data!.docs.map((document) {
            final String uidIndex = document['uid'];
            return profilewidget(uidIndex);
          }).toList(),
        );
      });
  Widget profilewidget(uidIndex) => StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .where('uid', isEqualTo: uidIndex)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: snapshot.data!.docs.map((document) {
            final String uidIndex = document['uid'];
            int numfollowing = snapshot.data!.docs.first.get('numfollow');
            int numfollower = snapshot.data!.docs.first.get('numfollower');

            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: InkWell(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return Profileindexwidget(userIDindex: uidIndex);
                })),
                child: Container(
                  height: 50,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextBwidget(
                          name: document['username'],
                          size: 16,
                        ),
                        SizedBox(
                          width: 80,
                          height: 40,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Tapuserlistwidget(
                                    uidIndex: uidIndex,
                                    tapcontrl: 1,
                                    usernameIndex: document['username'],
                                    userID: userID);
                              }));
                            },
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextBwidget(
                                      name: numfollower.toString(), size: 12),
                                  const TextSwidget(
                                      name: ' ผู้ติดตาม ', size: 12)
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          height: 40,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Tapuserlistwidget(
                                    uidIndex: uidIndex,
                                    tapcontrl: 0,
                                    usernameIndex: document['username'],
                                    userID: userID);
                              }));
                            },
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextBwidget(
                                      name: numfollowing.toString(), size: 12),
                                  const TextSwidget(
                                      name: ' ติดตามผู้อื่น ', size: 12)
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                followicon(uidIndex),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      });

  Widget followicon(uidIndex) => StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(userID)
          .collection('follow')
          .where(FieldPath.documentId, isEqualTo: uidIndex)
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
                  .collection('follow')
                  .doc(uidIndex)
                  .set({
                'uid': uidIndex,
                'createdat': DateTime.now().millisecondsSinceEpoch
              });
              await _userCollection
                  .doc(userID)
                  .update({'numfollow': FieldValue.increment(1)});
              await _userCollection
                  .doc(uidIndex)
                  .collection('follower')
                  .doc(userID)
                  .set({
                'uid': userID,
                'createdat': DateTime.now().millisecondsSinceEpoch
              });
              await _userCollection
                  .doc(uidIndex)
                  .update({'numfollower': FieldValue.increment(1)});
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.5,
                  color: Colors.deepOrange,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Text(
                      " ติดตาม ",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Column(
              children: snapshot.data!.docs.map((document1) {
            // var nameid = document1.id;
            return GestureDetector(
              onTap: () async {
                await document1.reference.delete();
                await _userCollection
                    .doc(userID)
                    .update({'numfollow': FieldValue.increment(-1)});
                await _userCollection
                    .doc(uidIndex)
                    .collection('follower')
                    .doc(userID)
                    .delete();
                await _userCollection
                    .doc(uidIndex)
                    .update({'numfollower': FieldValue.increment(-1)});
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.5,
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: Text(
                        " เลิกติดตาม ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }).toList());
        }
      });
}
