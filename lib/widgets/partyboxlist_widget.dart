import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constans/text.dart';
import 'partybox_widget.dart';

class Partyboxlistwidget extends StatefulWidget {
  final int type;
  final String userID;
  final String inputdocID;
  final String userIDindex;
  final int typeuser;
  const Partyboxlistwidget(
      {Key? key,
      required this.userID,
      required this.type,
      required this.inputdocID,
      required this.userIDindex,
      required this.typeuser})
      : super(key: key);

  @override
  State<Partyboxlistwidget> createState() => _PartyboxlistwidgetState();
}

class _PartyboxlistwidgetState extends State<Partyboxlistwidget> {
  @override
  Widget build(BuildContext context) {
    var stream = widget.type == 1
        ? FirebaseFirestore.instance
            .collection('party')
            .orderBy('createdat', descending: true)
            .snapshots()
        : widget.type == 2
            ? widget.typeuser == 1
                ? FirebaseFirestore.instance
                    .collection('joined')
                    .where(FieldPath.documentId,
                        isEqualTo: widget.inputdocID + widget.userID)
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection('joined')
                    .where(FieldPath.documentId,
                        isEqualTo: widget.inputdocID + widget.userIDindex)
                    .snapshots()
            : widget.type == 3
                ? widget.typeuser == 1
                    ? FirebaseFirestore.instance
                        .collection('party')
                        .where('createdby', isEqualTo: widget.userID)
                        .orderBy('createdat', descending: true)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('party')
                        .where('createdby', isEqualTo: widget.userIDindex)
                        .orderBy('createdat', descending: true)
                        .snapshots()
                : widget.typeuser == 1
                    ? FirebaseFirestore.instance
                        .collection('user')
                        .doc(widget.userID)
                        .collection('joined')
                        .orderBy('createdat', descending: true)
                        // .where('uid', isEqualTo: auth.currentUser!.uid)
                        //https://petercoding.com/firebase/2020/04/04/using-cloud-firestore-in-flutter/ //
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('user')
                        .doc(widget.userIDindex)
                        .collection('joined')
                        .orderBy('createdat', descending: true)
                        // .where('uid', isEqualTo: auth.currentUser!.uid)
                        //https://petercoding.com/firebase/2020/04/04/using-cloud-firestore-in-flutter/ //
                        .snapshots();
    //type 1 = partylisscreen type 2= profile->joined // type 3= profile->following //type 4 ==profile ->saved//
    return StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Padding(
              padding: EdgeInsets.all(18.0),
              child: TextBwidget(name: ' ไม่มีรายการ ', size: 16),
            ));
          }

          return GridView.builder(
            // physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              String createdby = snapshot.data!.docs[index]['createdby'];
              String title = snapshot.data!.docs[index]['title'];
              int numppl = snapshot.data!.docs[index]['numppl'];
              int donedate = snapshot.data!.docs[index]['donedate'];
              String docID = snapshot.data!.docs[index].id;
              String detail = snapshot.data!.docs[index]['detail'];
              int createdat = snapshot.data!.docs[index]['createdat'];
              int numjoined = snapshot.data!.docs[index]['numjoined'];
              int numliked = snapshot.data!.docs[index]['numliked'];
              int numcomment = snapshot.data!.docs[index]['numcomment'];
              bool editdetail = snapshot.data!.docs[index]['edit'];
              int editdetailtime = snapshot.data!.docs[index]['editdated'];
              bool completed = snapshot.data!.docs[index]['completed'];
              String category = snapshot.data!.docs[index]['category'];
              print('read doc : ' + docID);
              return Partybox(
                docID: docID,
                title: title,
                numppl: numppl,
                donedate: donedate,
                createdby: createdby,
                detail: detail,
                createdat: createdat,
                userID: widget.userID,
                numjoined: numjoined,
                numliked: numliked,
                numcomment: numcomment,
                editdetail: editdetail,
                editdetailtime: editdetailtime,
                completed: completed,
                category: category,
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: (1 / 1.6)),
          );
        });
  }
}
