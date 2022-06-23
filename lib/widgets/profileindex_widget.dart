import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../constans/text.dart';
import 'partybox_widget.dart';
import 'partyboxlist_widget.dart';
import 'tapuserlist_widget.dart';

// ignore: must_be_immutable
class Profileindexwidget extends StatelessWidget {
  final String userIDindex;
  Profileindexwidget({Key? key, required this.userIDindex}) : super(key: key);
  String userID = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection("user");
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("user")
            .where(FieldPath.documentId, isEqualTo: userIDindex)
            //https://petercoding.com/firebase/2020/04/04/using-cloud-firestore-in-flutter/ //
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          String profilename = snapshot.data!.docs.first.get('username');
          int numjoined = snapshot.data!.docs.first.get('numjoined');
          int numfollowing = snapshot.data!.docs.first.get('numfollow');
          int numfollower = snapshot.data!.docs.first.get('numfollower');

          int phonenumber = snapshot.data!.docs.first.get('phonenumber');
          return Scaffold(
            appBar: AppBar(
              actions: [
                if (userIDindex != userID)
                  Padding(
                    padding: const EdgeInsets.only(top: 0, right: 5),
                    child: followicon(userIDindex),
                  )
              ],
              elevation: 1.5,
              title: const TextBwhitewidget(
                name: ' ข้อมูลบัญชีผู้ใช้ ',
                size: 18,
              ),
            ),
            body: DefaultTabController(
              length: 3,
              child: NestedScrollView(
                headerSliverBuilder: (context, _) {
                  return [
                    SliverToBoxAdapter(
                      child: profilebox(profilename, numjoined, numfollowing,
                          numfollower, phonenumber, context),
                    ),
                  ];
                },
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: RectangularIndicator(
                          color: const Color.fromARGB(73, 206, 72, 23),
                          bottomLeftRadius: 10,
                          bottomRightRadius: 10,
                          topLeftRadius: 10,
                          topRightRadius: 10,
                          paintingStyle: PaintingStyle.fill,
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white,
                        tabs: [
                          Tab(
                            height: MediaQuery.of(context).size.height * 0.023,
                            child: const TextBcolorwidget(
                              name: '  เจ้าของ  ',
                              size: 13,
                              color: Colors.deepOrange,
                            ),
                          ),
                          Tab(
                            height: MediaQuery.of(context).size.height * 0.025,
                            child: const TextBcolorwidget(
                              name: '  เข้าร่วม  ',
                              size: 13,
                              color: Colors.deepOrange,
                            ),
                          ),
                          Tab(
                            height: MediaQuery.of(context).size.height * 0.022,
                            child: const TextBcolorwidget(
                              name: '   ติดตาม   ',
                              size: 13,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Partyboxlistwidget(
                            userID: userID,
                            type: 3,
                            inputdocID: '',
                            typeuser: 2,
                            userIDindex: userIDindex,
                          ),
                          pulldata(2),
                          pulldata(3)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget pulldata(type) {
    var stream = type == 2
        ? FirebaseFirestore.instance
            .collection('joined')
            .where('createdby', isEqualTo: userIDindex)
            .snapshots()
        : type == 3
            ? FirebaseFirestore.instance
                .collection('user')
                .doc(userIDindex)
                .collection('follow')
                .snapshots()
            : type == 4
                ? FirebaseFirestore.instance
                    .collection('user')
                    .doc(userIDindex)
                    .collection('saved')
                    .snapshots()
                : type == 5
                    ? FirebaseFirestore.instance
                        .collection('party')
                        .where('createdby', isEqualTo: userIDindex)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('party')
                        .snapshots();
    //type 1 = partylisscreen type 2= profile->joined // type 3= profile->following //type 4 ==profile ->saved//type5

    return StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot1) {
          if (!snapshot1.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot1.data!.docs.isEmpty) {
            return const Center(
                child: Padding(
              padding: EdgeInsets.all(18.0),
              child: TextBwidget(name: ' ไม่มีรายการ ', size: 16),
            ));
          }
          return GridView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot1.data!.docs.length,
              itemBuilder: (context, index) {
                final data1 = snapshot1.data!.docs;
                var stream2 = type == 3
                    ? FirebaseFirestore.instance
                        .collection('party')
                        .where('createdby', isEqualTo: data1[index].id)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('party')
                        .where(FieldPath.documentId,
                            isEqualTo: data1[index]['refdocid'])
                        .snapshots();
                return StreamBuilder(
                    stream: stream2,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          String createdby =
                              snapshot.data!.docs[index]['createdby'];
                          String title = snapshot.data!.docs[index]['title'];
                          int numppl = snapshot.data!.docs[index]['numppl'];
                          int donedate = snapshot.data!.docs[index]['donedate'];
                          String docID = snapshot.data!.docs[index].id;
                          String detail = snapshot.data!.docs[index]['detail'];
                          int createdat =
                              snapshot.data!.docs[index]['createdat'];
                          int numjoined =
                              snapshot.data!.docs[index]['numjoined'];
                          int numliked = snapshot.data!.docs[index]['numliked'];
                          int numcomment =
                              snapshot.data!.docs[index]['numcomment'];
                          bool editdetail = snapshot.data!.docs[index]['edit'];
                          int editdetailtime =
                              snapshot.data!.docs[index]['editdated'];
                          bool completed =
                              snapshot.data!.docs[index]['completed'];
                          String category =
                              snapshot.data!.docs[index]['category'];
                          return Partybox(
                            docID: docID,
                            title: title,
                            numppl: numppl,
                            donedate: donedate,
                            createdby: createdby,
                            detail: detail,
                            createdat: createdat,
                            userID: userID,
                            numjoined: numjoined,
                            numliked: numliked,
                            numcomment: numcomment,
                            editdetail: editdetail,
                            editdetailtime: editdetailtime,
                            completed: completed,
                            category: category,
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: type == 3 ? 2 : 1,
                            childAspectRatio: (1 / 1.32)),
                      );
                    });
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: type == 3 ? 1 : 2,
                  childAspectRatio: (1 / 1.35)));
        });
  }

  Widget profilebox(profilename, numjoined, numfollowing, numfollower,
          phonenumber, context) =>
      Container(
        color: Colors.white,
        height: 60,
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 50,
              child: Center(
                child: TextBwidget(
                  name: profilename,
                  size: 24,
                ),
              ),
            ),
            SizedBox(
              width: 80,
              height: 50,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextBwidget(name: numjoined.toString(), size: 16),
                    const TextSwidget(name: ' เข้าร่วม ', size: 16)
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Tapuserlistwidget(
                      uidIndex: userIDindex,
                      tapcontrl: 0,
                      usernameIndex: profilename,
                      userID: userID);
                }));
              },
              child: SizedBox(
                width: 100,
                height: 50,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextBwidget(name: numfollowing.toString(), size: 16),
                      const TextSwidget(name: ' ติดตามผู้อื่น ', size: 16)
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Tapuserlistwidget(
                      uidIndex: userIDindex,
                      tapcontrl: 1,
                      usernameIndex: profilename,
                      userID: userID);
                }));
              },
              child: SizedBox(
                width: 80,
                height: 50,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextBwidget(name: numfollower.toString(), size: 16),
                      const TextSwidget(name: ' ผู้ติดตาม ', size: 16)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  Widget followicon(userIDindex) => StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(userID)
          .collection('follow')
          .where(FieldPath.documentId, isEqualTo: userIDindex)
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
                  .doc(userIDindex)
                  .set({
                'uid': userIDindex,
                'createdat': DateTime.now().millisecondsSinceEpoch
              });
              await _userCollection
                  .doc(userID)
                  .update({'numfollow': FieldValue.increment(1)});
              await _userCollection
                  .doc(userIDindex)
                  .collection('follower')
                  .doc(userID)
                  .set({
                'uid': userID,
                'createdat': DateTime.now().millisecondsSinceEpoch
              });
              await _userCollection
                  .doc(userIDindex)
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
                        color: Colors.white,
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
          return Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
                children: snapshot.data!.docs.map((document1) {
              // var nameid = document1.id;
              return GestureDetector(
                onTap: () async {
                  await document1.reference.delete();
                  await _userCollection
                      .doc(userID)
                      .update({'numfollow': FieldValue.increment(-1)});
                  await _userCollection
                      .doc(userIDindex)
                      .collection('follower')
                      .doc(userID)
                      .delete();
                  await _userCollection
                      .doc(userIDindex)
                      .update({'numfollower': FieldValue.increment(-1)});
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(
                        child: Text(
                          " เลิกติดตาม ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList()),
          );
        }
      });
}
