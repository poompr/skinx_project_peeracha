import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../constans/text.dart';
import '../widgets/partybox_widget.dart';
import '../widgets/partyboxlist_widget.dart';
import '../widgets/tapuserlist_widget.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({
    Key? key,
  }) : super(key: key);

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen>
    with AutomaticKeepAliveClientMixin<Profilescreen> {
  final formKey = GlobalKey<FormState>();
  String userID = FirebaseAuth.instance.currentUser!.uid;
  String editprofilename = '';
  int editphonenumber = 0;
  final CollectionReference _updateprofileCollection =
      FirebaseFirestore.instance.collection('user');
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("user")
            .where(FieldPath.documentId, isEqualTo: userID)
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
          // int numsaved = snapshot.data!.docs.first.get('numsaved');
          int phonenumber = snapshot.data!.docs.first.get('phonenumber');
          return Scaffold(
            body: DefaultTabController(
              length: 4,
              child: NestedScrollView(
                headerSliverBuilder: (context, _) {
                  return [
                    SliverToBoxAdapter(
                      child: profilebox(profilename, numjoined, numfollowing,
                          numfollower, phonenumber),
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
                              name: '    ?????????????????????   ',
                              size: 13,
                              color: Colors.deepOrange,
                            ),
                          ),
                          Tab(
                            height: MediaQuery.of(context).size.height * 0.025,
                            child: const TextBcolorwidget(
                              name: '  ????????????????????????  ',
                              size: 13,
                              color: Colors.deepOrange,
                            ),
                          ),
                          Tab(
                            height: MediaQuery.of(context).size.height * 0.022,
                            child: const TextBcolorwidget(
                              name: '   ??????????????????   ',
                              size: 13,
                              color: Colors.deepOrange,
                            ),
                          ),
                          Tab(
                            height: MediaQuery.of(context).size.height * 0.022,
                            child: const TextBcolorwidget(
                              name: '   ??????????????????   ',
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
                            typeuser: 1,
                            userIDindex: '',
                          ),
                          pulldata(2),
                          pulldata(3),
                          pulldata(4)
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
            .where('createdby', isEqualTo: userID)
            .orderBy('createdat', descending: true)
            .snapshots()
        : type == 3
            ? FirebaseFirestore.instance
                .collection('user')
                .doc(userID)
                .collection('follow')
                .orderBy('createdat', descending: true)
                .snapshots()
            : type == 4
                ? FirebaseFirestore.instance
                    .collection('user')
                    .doc(userID)
                    .collection('saved')
                    .orderBy('createdat', descending: true)
                    .snapshots()
                : type == 5
                    ? FirebaseFirestore.instance
                        .collection('party')
                        .where('createdby', isEqualTo: userID)
                        .orderBy('createdat', descending: true)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('party')
                        .orderBy('createdat', descending: true)
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
              child: TextBwidget(name: ' ????????????????????????????????? ', size: 16),
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
                        .orderBy('createdat', descending: true)
                        .snapshots()
                    : type == 4
                        ? FirebaseFirestore.instance
                            .collection('party')
                            .where(FieldPath.documentId,
                                isEqualTo: data1[index]['docpartyid'])
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
                            childAspectRatio: (1 / 1.6)),
                      );
                    });
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: type == 3 ? 1 : 2,
                  childAspectRatio: (1 / 1.7)));
        });
  }

  Widget editprofilebox(profilename, phonenumber, context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SizedBox(
          height: 200,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const TextBwidget(name: ' ?????????????????? ', size: 16),
                    ),
                    const TextBwidget(name: ' ???????????????????????????????????????????????? ', size: 18),
                    GestureDetector(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          await _updateprofileCollection.doc(userID).update({
                            'username': editprofilename,
                            'phonenumber': editphonenumber
                          });
                        }

                        formKey.currentState!.reset();
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                      child: const TextBcolorwidget(
                        name: ' ?????????????????? ',
                        size: 16,
                        color: Colors.deepOrange,
                      ),
                    )
                  ],
                ),
                TextFormField(
                  maxLength: 10,
                  initialValue: profilename,
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    counterText: '',
                    icon:
                        const TextSwidget(name: ' ????????????????????????????????????????????? ', size: 18),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    isDense: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Colors.deepOrange,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color.fromARGB(160, 0, 0, 0),
                      ),
                    ),
                  ),
                  onSaved: (valueProfilename) {
                    editprofilename = valueProfilename!;
                  },
                ),
                const Divider(
                  height: 2,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  initialValue: phonenumber.toString(),
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    counterText: '',
                    icon: const TextSwidget(name: ' ??????????????????????????????????????? ', size: 18),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    isDense: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        color: Colors.deepOrange,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color.fromARGB(160, 0, 0, 0),
                      ),
                    ),
                  ),
                  onSaved: (valuePhonenumber) {
                    editphonenumber = int.parse(valuePhonenumber.toString());
                  },
                ),
                const Divider(
                  height: 2,
                ),
              ],
            ),
          ),
        ),
      );
  Widget profilebox(
          profilename, numjoined, numfollowing, numfollower, phonenumber) =>
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
                    const TextSwidget(name: ' ???????????????????????? ', size: 16)
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Tapuserlistwidget(
                      uidIndex: userID,
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
                      const TextSwidget(name: ' ??????????????????????????????????????? ', size: 16)
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Tapuserlistwidget(
                      uidIndex: userID,
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
                      const TextSwidget(name: ' ??????????????????????????? ', size: 16)
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: GestureDetector(
                  child: const Icon(
                    Icons.settings,
                    size: 22,
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0),
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              color: Color.fromARGB(224, 13, 13, 13),
                            ),
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                      onTap: () async {
                                        await FirebaseAuth.instance.signOut();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              253, 0, 0, 0),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.white,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 0, 0, 0),
                                                  radius: 18,
                                                  child: Icon(
                                                      Icons
                                                          .power_settings_new_rounded,
                                                      size: 20,
                                                      color: Colors.white),
                                                )),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: TextBwhitewidget(
                                                  name: ' ?????????????????????????????? ',
                                                  size: 12),
                                            )
                                          ],
                                        ),
                                      )),
                                  GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      18.0),
                                                  child: editprofilebox(
                                                      profilename,
                                                      phonenumber,
                                                      context),
                                                )));
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                253, 0, 0, 0),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Color.fromARGB(
                                                              255, 0, 0, 0),
                                                      radius: 18,
                                                      child: Icon(
                                                          Icons
                                                              .person_outline_outlined,
                                                          size: 20,
                                                          color: Colors.white),
                                                    )),
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: TextBwhitewidget(
                                                    name: ' ???????????????????????????????????????????????? ',
                                                    size: 12,
                                                  ),
                                                ),
                                              ])))
                                ]));
                      },
                    );
                  }),
            )
          ],
        ),
      );

  @override
  bool get wantKeepAlive => true;
}
