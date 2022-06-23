import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../constans/text.dart';
import '../constans/user.dart';
import 'addparty_widget.dart';
import 'likebuttoninside.dart';
import 'likedbutton.dart';
import 'profileindex_widget.dart';
import 'saved_widget.dart';

class Partydetailwidget extends StatefulWidget {
  final String docID;
  final String title;
  final int numppl;
  final int donedate;
  final String createdby;
  final String detail;
  final int createdat;
  final int numjoined;
  final String userID;
  final int numliked;
  final int numcomment;
  final bool editdetail;
  final int editmaindetailtime;
  final bool completed;
  final String category;
  const Partydetailwidget(
      {Key? key,
      required this.docID,
      required this.title,
      required this.numppl,
      required this.donedate,
      required this.createdby,
      required this.detail,
      required this.createdat,
      required this.numjoined,
      required this.userID,
      required this.numliked,
      required this.numcomment,
      required this.editdetail,
      required this.editmaindetailtime,
      required this.completed,
      required this.category})
      : super(key: key);

  @override
  State<Partydetailwidget> createState() => _PartydetailwidgetState();
}

class _PartydetailwidgetState extends State<Partydetailwidget> {
  int picIndex = 0;
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('user');
  final CollectionReference _partyCollection =
      FirebaseFirestore.instance.collection('party');
  final CollectionReference _joinedCollection =
      FirebaseFirestore.instance.collection('joined');
  TextEditingController commentIndex = TextEditingController();
  TextEditingController editcommentIndex = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
          elevation: 1.5,
          title: const TextBwidget(name: ' ปาร์ตี้ ', size: 16),
          actions: [
            Center(
                child: widget.completed
                    ? widget.createdby == widget.userID
                        ? completebutton(context)
                        : const SizedBox()
                    : widget.createdby == widget.userID
                        ? const SizedBox()
                        : joinbutton(widget.docID))
          ],
        ),
        body: Column(children: [
          Expanded(
            child: ListView(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: picture(widget.docID),
                  ),
                  if (widget.createdby == widget.userID) editpartydetailbox(),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: detailbox(),
                  )
                ],
              ),
              if (widget.numcomment >= 1)
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    TextBwidget(
                        // ignore: prefer_interpolation_to_compose_strings
                        name: ' ' +
                            widget.numcomment.toString() +
                            ' แสดงความคิดเห็น ',
                        size: 10),
                    commentbox(),
                  ],
                )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 15),
            child: TextFormField(
              maxLength: 250,
              maxLines: 4, minLines: 1,
              // expands: true,
              controller: commentIndex,
              // onChanged: (value) {
              //   setState(() {
              //     commentIndex.text = value;
              //   });
              // },
              decoration: InputDecoration(
                counterText: '',
                suffixIcon: GestureDetector(
                  child: const Icon(
                    Icons.send,
                    color: Colors.deepOrange,
                  ),
                  onTap: () async {
                    if (commentIndex.text.isEmpty) {
                    } else {
                      await _partyCollection
                          .doc(widget.docID)
                          .collection('comment')
                          .add({
                        'type': 1,
                        'createdby': widget.userID,
                        'createdat': DateTime.now().millisecondsSinceEpoch,
                        'comment': commentIndex.text,
                        'editmessage': false,
                        'recenteditdate': 0,
                        'numliked': 0,
                        'totalcomment': 0,
                      });
                      await _partyCollection
                          .doc(widget.docID)
                          .update({'numcomment': FieldValue.increment(1)});
                      commentIndex.clear();
                      // ignore: use_build_context_synchronously

                    }
                  },
                ),
                contentPadding: const EdgeInsets.all(6),
                isDense: true,

                hintText: ' แสดงความคิดเห็น....',
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  gapPadding: 0,
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(131, 255, 86, 34),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  gapPadding: 0,
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(
                    color: Colors.deepOrange,
                  ),
                ),

                // focusedBorder: InputBorder.none,
                // enabledBorder: InputBorder.none,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget completebutton(context) => GestureDetector(
        child: const TextBcolorwidget(
          name: ' ยืนยันปาร์ตี้สมบูรณ์  ',
          size: 14,
          color: Colors.deepOrange,
        ),
        onTap: () async {
          await _partyCollection.doc(widget.docID).update({
            'completed': true,
            'completeddate': DateTime.now().millisecondsSinceEpoch
          });
          Navigator.of(context).pop();
        },
      );

  Widget commentbox() => StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('party')
          .doc(widget.docID)
          .collection('comment')
          .orderBy('createdat', descending: false)

          // .where('uid', isEqualTo: auth.currentUser!.uid)
          //https://petercoding.com/firebase/2020/04/04/using-cloud-firestore-in-flutter/ //
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container(
          decoration: const BoxDecoration(
              color: Color.fromARGB(161, 223, 108, 41),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              )),
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  String comment = snapshot.data!.docs[index]['comment'];
                  String createdby = snapshot.data!.docs[index]['createdby'];
                  int timeago = snapshot.data!.docs[index]['createdat'];
                  String insidedocID = snapshot.data!.docs[index].id;
                  int numlikeinside = snapshot.data!.docs[index]['numliked'];
                  bool editcommentinside =
                      snapshot.data!.docs[index]['editmessage'];
                  int editinsidedate =
                      snapshot.data!.docs[index]['recenteditdate'];
                  return Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("user")
                              .where(FieldPath.documentId, isEqualTo: createdby)
                              //https://petercoding.com/firebase/2020/04/04/using-cloud-firestore-in-flutter/ //
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> snapshot1) {
                            if (!snapshot1.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            String profilename =
                                snapshot1.data!.docs.first.get('username');

                            return Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(160, 255, 253, 253),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextBwidget(
                                            // ignore: prefer_interpolation_to_compose_strings
                                            name: profilename + '   ',
                                            size: 14),
                                        Expanded(
                                            child: TextSwidget(
                                                name: comment, size: 12))
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4, left: 8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Likebuttoninside(
                                            docID: widget.docID,
                                            userID: widget.userID,
                                            docinsideID: insidedocID,
                                          ),
                                          if (numlikeinside >= 1)
                                            TextSwidget(
                                                // ignore: prefer_interpolation_to_compose_strings
                                                name: '  ' +
                                                    numlikeinside.toString() +
                                                    ' ถูกใจ ',
                                                size: 9),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2),
                                            child: TextSwidget(
                                                // ignore: prefer_interpolation_to_compose_strings
                                                name: editcommentinside == true
                                                    // ignore: prefer_interpolation_to_compose_strings
                                                    ? ' แก้ไขข้อความเมื่อ ' +
                                                        TimeAgo
                                                            .timeAgoSinceDate(
                                                                editinsidedate)
                                                    // ignore: prefer_interpolation_to_compose_strings
                                                    : ' แสดงความคิดเห็นเมื่อ ' +
                                                        TimeAgo
                                                            .timeAgoSinceDate(
                                                                timeago),
                                                size: 9),
                                          ),
                                          if (createdby == widget.userID)
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    snapshot1.data!.docs.first
                                                        .reference
                                                        .delete();
                                                  },
                                                  child: const TextBwidget(
                                                      name:
                                                          '  ลบข้อความคิดเห็นนี้ ',
                                                      size: 8),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                        backgroundColor: Colors
                                                            .grey
                                                            .withOpacity(0),
                                                        isScrollControlled:
                                                            true,
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Container(
                                                              decoration:
                                                                  const BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            20)),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.5,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        20.0),
                                                                child: SingleChildScrollView(
                                                                    child: Form(
                                                                        key: formKey,
                                                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 5),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: const TextBwidget(name: ' ยกเลิก ', size: 14),
                                                                                ),
                                                                                const TextBwidget(name: ' แก้ไขความคิดเห็น ', size: 16),
                                                                                GestureDetector(
                                                                                  child: const TextBcolorwidget(
                                                                                    name: ' แก้ไข ',
                                                                                    size: 14,
                                                                                    color: Colors.deepOrange,
                                                                                  ),
                                                                                  onTap: () async {
                                                                                    if (formKey.currentState!.validate()) {
                                                                                      formKey.currentState!.save();
                                                                                      _partyCollection.doc(widget.docID).collection('comment').doc(insidedocID).update({
                                                                                        'comment': editcommentIndex.text,
                                                                                        'editmessage': true,
                                                                                        'recenteditdate': DateTime.now().millisecondsSinceEpoch
                                                                                      });
                                                                                      formKey.currentState!.reset();
                                                                                      // ignore: use_build_context_synchronously
                                                                                      Navigator.of(context).pop();
                                                                                    }
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          TextFormField(
                                                                              initialValue: comment,
                                                                              maxLength: 50,
                                                                              textAlign: TextAlign.start,
                                                                              decoration: const InputDecoration(
                                                                                counterText: '',
                                                                                label: TextBwidget(name: ' ข้อความ ', size: 14),
                                                                                border: InputBorder.none,
                                                                              ),
                                                                              onSaved: (valueEditcomment) {
                                                                                editcommentIndex.text = valueEditcomment.toString();
                                                                              },
                                                                              validator: RequiredValidator(errorText: "กรุณากรอก")),
                                                                          const Divider(
                                                                            height:
                                                                                2,
                                                                          )
                                                                        ]))),
                                                              ));
                                                        });
                                                  },
                                                  child: const TextBwidget(
                                                      name: '   แก้ไข ',
                                                      size: 8),
                                                ),
                                              ],
                                            )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }));
                }),
          ),
        );
      });
  Widget editpartydetailbox() => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
                backgroundColor: Colors.grey.withOpacity(0),
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Colors.white,
                      ),
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Addpartywidget(
                        type: 2,
                        docID: widget.docID,
                        title: widget.title,
                        donedate: widget.donedate,
                        detail: widget.detail,
                        userID: widget.userID,
                        numppl: widget.numppl,
                      ));
                });
          },
          child: const TextBcolorwidget(
            name: ' แก้ไขรายละเอียดปาร์ตี้  ',
            size: 12,
            color: Colors.deepOrange,
          ),
        ),
      );
  Widget detailbox() => Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(222, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 0.5,
            spreadRadius: 0.5,
            color: Colors.black26,
          ),
        ],
      ),
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const TextBwidget(name: ' ปาร์ตี้สร้างโดย :  ', size: 12),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => Profileindexwidget(
                                  userIDindex: widget.createdby))));
                        },
                        child: Profilename(uid: widget.createdby, size: 14)),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: followicon(),
                    ),
                  ],
                ),
                SizedBox(
                  width: 130,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (widget.editdetail)
                        TextSwidget(
                            // ignore: prefer_interpolation_to_compose_strings
                            name: ' แก้ไขเมื่อ ' +
                                TimeAgo.timeAgoSinceDate(
                                    widget.editmaindetailtime),
                            size: 12),
                      TextSwidget(
                          // ignore: prefer_interpolation_to_compose_strings
                          name: ' สร้างเมื่อ ' +
                              TimeAgo.timeAgoSinceDate(widget.createdat),
                          size: 12),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
// ignore: prefer_interpolation_to_compose_strings
            TextBwidget(name: ' หัวข้อ : ' + widget.title, size: 14),
            const SizedBox(
              height: 10,
            ),

            const TextBwidget(name: ' รายละเอียด : ', size: 12),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextSwidget(name: widget.detail, size: 14),
            ),
            const SizedBox(
              height: 10,
              // ignore: prefer_interpolation_to_compose_strings
            ),
            // ignore: prefer_interpolation_to_compose_strings

            Row(
              children: [
                TextSwidget(
                    // ignore: prefer_interpolation_to_compose_strings
                    name: ' ต้องการจำนวนคน ' +
                        widget.numjoined.toString() +
                        ' / ' +
                        widget.numppl.toString(),
                    // ignore: prefer_interpolation_to_compose_strings
                    size: 12),
                const SizedBox(
                  width: 15,
                ),
                // ignore: prefer_interpolation_to_compose_strings
                TextSwidget(name: ' ประเภท : ' + widget.category, size: 12),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const TextSwidget(name: ' ผู้เข้าร่วมปัจจุบัน :', size: 12),
            const SizedBox(
              height: 5,
            ),
            joinednamebox(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Likebutton(
                        docID: widget.docID,
                        userID: widget.userID,
                      ),
                      if (widget.numliked >= 1)
                        TextSwidget(
                            // ignore: prefer_interpolation_to_compose_strings
                            name: '  ' + widget.numliked.toString(),
                            size: 10),
                      if (widget.numliked >= 1)
                        const TextSwidget(name: '  ถูกใจ ', size: 10),
                    ],
                  ),
                  Savedwidget(
                      type: 2, docpartyID: widget.docID, userID: widget.userID)
                ],
              ),
            ),
          ])));
  Widget joinednamebox() => StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('joined')
          .where('refdocid', isEqualTo: widget.docID)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot1) {
        if (!snapshot1.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return GridView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot1.data!.docs.length,
            itemBuilder: (context, index) {
              final data1 = snapshot1.data!.docs;
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('joined')
                      .where(FieldPath.documentId,
                          isEqualTo: widget.docID + data1[index]['createdby'])
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: TextSwidget(
                              name: ' ไม่มีผู้เข้าร่วม ', size: 12));
                    }
                    var total = snapshot.data!.docs;
                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: total.length,
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: ((context) => Profileindexwidget(
                                          userIDindex: total[index]
                                              ['createdby']))));
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          216, 255, 86, 34),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 2, 4, 2),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            widget.createdby == widget.userID
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.center,
                                        children: [
                                          Profilename(
                                              uid: total[index]['createdby'],
                                              size: 10),
                                          if (widget.createdby == widget.userID)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15),
                                              child: GestureDetector(
                                                  child: const Icon(
                                                      Icons.cancel_outlined,
                                                      color: Colors.white,
                                                      size: 16),
                                                  onTap: () async {
                                                    await total[index]
                                                        .reference
                                                        .delete();
                                                    await _partyCollection
                                                        .doc(widget.docID)
                                                        .update({
                                                      'numjoined':
                                                          FieldValue.increment(
                                                              -1)
                                                    });
                                                    await _userCollection
                                                        .doc(widget.userID)
                                                        .update({
                                                      'numjoined':
                                                          FieldValue.increment(
                                                              -1)
                                                    });
                                                  }),
                                            ),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1, childAspectRatio: (4 / 1)));
                  });
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, childAspectRatio: (1 / 1)));
      });
  Widget followicon() => StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(widget.userID)
          .collection('follow')
          .where(FieldPath.documentId, isEqualTo: widget.createdby)
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
                  .doc(widget.userID)
                  .collection('follow')
                  .doc(widget.createdby)
                  .set({
                'uid': widget.createdby,
                'createdat': DateTime.now().millisecondsSinceEpoch
              });
              await _userCollection
                  .doc(widget.userID)
                  .update({'numfollow': FieldValue.increment(1)});
              await _userCollection
                  .doc(widget.createdby)
                  .collection('follower')
                  .doc(widget.userID)
                  .set({
                'uid': widget.userID,
                'createdat': DateTime.now().millisecondsSinceEpoch
              });
              await _userCollection
                  .doc(widget.createdby)
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
                        fontSize: 10,
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
                    .doc(widget.userID)
                    .update({'numfollow': FieldValue.increment(-1)});
                await _userCollection
                    .doc(widget.createdby)
                    .collection('follower')
                    .doc(widget.userID)
                    .delete();
                await _userCollection
                    .doc(widget.createdby)
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
                          fontSize: 10,
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

  Widget picture(docIDInput) => StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('party')
          .doc(docIDInput)
          .collection('partypic')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: [
            CarouselSlider.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index, realIndex) {
                  return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            snapshot.data!.docs[index]['url'],
                            fit: BoxFit.fill,
                          )));
                },
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.4,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      picIndex = index;
                    });
                  },
                )),
            const SizedBox(
              height: 5,
            ),
            snapshot.data!.docs.isEmpty == true
                ? const Center(child: Text('No Photo'))
                : AnimatedSmoothIndicator(
                    activeIndex: picIndex,
                    count: snapshot.data!.docs.length,
                    effect: snapshot.data!.docs.length == 1
                        ? const SlideEffect(dotHeight: 0, dotWidth: 0)
                        : SlideEffect(
                            dotHeight: 5,
                            dotWidth: 5,
                            activeDotColor: Colors.deepOrange,
                            dotColor: Colors.grey.shade300))
          ],
        );
      });
  Widget joinbutton(docIDInput) => StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('joined')
          .where(FieldPath.documentId, isEqualTo: widget.docID + widget.userID)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // final CollectionReference _testlistCollection =
        //     FirebaseFirestore.instance.collection("pp");
        // int picIndex = 0;
        // final pp = snapshot.data!.docs.where(containsSearchText).toList();
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data!.docs.isEmpty) {
          return GestureDetector(
              onTap: () async {
                await _joinedCollection.doc(widget.docID + widget.userID).set({
                  'refdocid': widget.docID,
                  'createdby': widget.userID,
                  'createdat': DateTime.now().millisecondsSinceEpoch
                });
                await _userCollection
                    .doc(widget.userID)
                    .update({'numjoined': FieldValue.increment(1)});
                // await _partyCollection
                //     .doc(widget.docID)
                //     .collection('joined')
                //     .doc(widget.userID)
                //     .set({
                //   'uid': widget.userID,
                //   'createdat': DateTime.now().millisecondsSinceEpoch
                // });
                await _partyCollection
                    .doc(widget.docID)
                    .update({'numjoined': FieldValue.increment(1)});
              },
              child: const TextBcolorwidget(
                name: ' เข้าร่วม  ',
                size: 16,
                color: Colors.deepOrange,
              ));
        }
        return GestureDetector(
            onTap: () async {
              await _joinedCollection
                  .doc(snapshot.data!.docs.first.id)
                  .delete();
              // await _partyCollection
              //     .doc(widget.docID)
              //     .collection('joined')
              //     .doc(widget.userID)
              //     .delete();
              await _partyCollection
                  .doc(widget.docID)
                  .update({'numjoined': FieldValue.increment(-1)});
              await _userCollection
                  .doc(widget.userID)
                  .update({'numjoined': FieldValue.increment(-1)});
            },
            child: const TextBcolorwidget(
              name: ' ยกเลิก  ',
              size: 16,
              color: Colors.deepOrange,
            ));
      });
}
