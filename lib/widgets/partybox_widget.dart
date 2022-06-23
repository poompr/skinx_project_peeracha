import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../constans/text.dart';
import '../constans/user.dart';
import 'likedbutton.dart';
import 'partydetail_widget.dart';
import 'profileindex_widget.dart';
import 'saved_widget.dart';

class Partybox extends StatefulWidget {
  final String docID;
  final String title;
  final int numppl;
  final int donedate;
  final String createdby;
  final String detail;
  final int createdat;
  final String userID;
  final int numjoined;
  final int numliked;
  final int numcomment;
  final bool editdetail;
  final int editdetailtime;
  final bool completed;
  final String category;

  const Partybox({
    Key? key,
    required this.docID,
    required this.title,
    required this.numppl,
    required this.donedate,
    required this.createdby,
    required this.detail,
    required this.createdat,
    required this.userID,
    required this.numjoined,
    required this.numliked,
    required this.numcomment,
    required this.editdetail,
    required this.editdetailtime,
    required this.completed,
    required this.category,
  }) : super(key: key);

  @override
  State<Partybox> createState() => _PartyboxState();
}

class _PartyboxState extends State<Partybox> {
  int picIndex = 0;
  final CollectionReference _profileCollection =
      FirebaseFirestore.instance.collection('user');
  final CollectionReference _partyCollection =
      FirebaseFirestore.instance.collection('party');
  final CollectionReference _joinedCollection =
      FirebaseFirestore.instance.collection('joined');

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 8),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => Partydetailwidget(
                      docID: widget.docID,
                      title: widget.title,
                      numppl: widget.numppl,
                      donedate: widget.donedate,
                      createdby: widget.createdby,
                      detail: widget.detail,
                      createdat: widget.createdat,
                      numjoined: widget.numjoined,
                      userID: widget.userID,
                      numliked: widget.numliked,
                      numcomment: widget.numcomment,
                      editdetail: widget.editdetail,
                      editmaindetailtime: widget.editdetailtime,
                      completed: widget.completed,
                      category: widget.category,
                    ))));
          },
          child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: const Color.fromARGB(222, 255, 255, 255),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 1,
                    spreadRadius: 1,
                    color: Colors.black26,
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //pic row//
                    picture(widget.docID),
                    //title row//
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.035,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextBwidget(name: widget.title, size: 12),
                          const Divider(
                            height: 1,
                            thickness: 1,
                          ),
                        ],
                      ),
                    ),

                    //username row//
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //createby and number joined row//
                            Row(
                              children: [
                                const TextScolorwidget(
                                  name: ' ผู้สร้าง : ',
                                  size: 12,
                                  color: Color.fromARGB(255, 68, 68, 68),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  Profileindexwidget(
                                                      userIDindex:
                                                          widget.createdby))));
                                    },
                                    child: Profilename(
                                        uid: widget.createdby, size: 12)),
                              ],
                            ),
                            TextBcolorwidget(
                                // ignore: prefer_interpolation_to_compose_strings
                                name: ' ผู้เข้าร่วม  ' +
                                    widget.numjoined.toString() +
                                    ' / ' +
                                    widget.numppl.toString(),
                                size: 12,
                                color: widget.numjoined != widget.numppl
                                    ? const Color.fromARGB(162, 255, 86, 34)
                                    : Colors.grey)
                          ],
                        ),
                      ),
                    ),
                    //joinicon and duedate row//
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.completed
                                ? completedicon()
                                : widget.donedate <=
                                        DateTime.now().millisecondsSinceEpoch
                                    ? timesupicon()
                                    : widget.createdby != widget.userID
                                        ? widget.numjoined != widget.numppl
                                            ? joinbutton(widget.docID)
                                            : timesupicon()
                                        : const SizedBox(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const TextScolorwidget(
                                    name: ' สิ้นสุด  ',
                                    size: 12,
                                    color: Colors.grey),
                                TextScolorwidget(
                                    name: formattedDateDay(widget.donedate),
                                    size: 12,
                                    color: Colors.grey)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //likeicon row//
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Likebutton(
                                    docID: widget.docID, userID: widget.userID),
                                if (widget.numliked >= 1)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: TextSwidget(
                                        // ignore: prefer_interpolation_to_compose_strings
                                        name: widget.numliked.toString() +
                                            ' ถูกใจ',
                                        size: 9),
                                  ),
                              ],
                            ),
                            if (widget.numcomment >= 1)
                              TextSwidget(
                                  // ignore: prefer_interpolation_to_compose_strings
                                  name: widget.numcomment.toString() +
                                      ' แสดงความคิดเห็น ',
                                  size: 8),
                            Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: Savedwidget(
                                  type: 1,
                                  docpartyID: widget.docID,
                                  userID: widget.userID),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }

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
              // await _partyCollection
              //     .doc(widget.docID)
              //     .collection('joined')
              //     .doc(widget.userID)
              //     .set({
              //   'uid': widget.userID,
              //   'createdat': DateTime.now().millisecondsSinceEpoch
              // });
              // await _profileCollection
              //     .doc(widget.userID)
              //     .collection('joined')
              //     .doc(widget.docID)
              //     .set({
              //   'joineddocid': widget.docID,
              //   'createdat': DateTime.now().millisecondsSinceEpoch
              // });
              await _partyCollection
                  .doc(widget.docID)
                  .update({'numjoined': FieldValue.increment(1)});
              await _profileCollection
                  .doc(widget.userID)
                  .update({'numjoined': FieldValue.increment(1)});
            },
            child: Container(
              decoration: BoxDecoration(
                // color: const Color.fromARGB(139, 226, 226, 226),
                color: const Color.fromARGB(255, 238, 81, 28),
                borderRadius: BorderRadius.circular(6),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(1, 1),
                    blurRadius: 1,
                    spreadRadius: 0,
                    color: Color.fromARGB(131, 110, 110, 110),
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.025,
              width: MediaQuery.of(context).size.width * 0.12,
              child: const Center(
                  child: TextBcolorwidget(
                name: ' เข้าร่วม ',
                size: 10,
                color: Colors.white,
              )),
            ),
          );
        }
        return GestureDetector(
          onTap: () async {
            await _joinedCollection.doc(snapshot.data!.docs.first.id).delete();
            // await _partyCollection
            //     .doc(widget.docID)
            //     .collection('joined')
            //     .doc(widget.userID)
            //     .delete();
            // await _profileCollection
            //     .doc(widget.userID)
            //     .collection('joined')
            //     .doc(widget.docID)
            //     .delete();
            await _partyCollection
                .doc(widget.docID)
                .update({'numjoined': FieldValue.increment(-1)});
            await _profileCollection
                .doc(widget.userID)
                .update({'numjoined': FieldValue.increment(-1)});
          },
          child: Container(
            decoration: BoxDecoration(
              // color: const Color.fromARGB(139, 226, 226, 226),
              color: const Color.fromARGB(223, 2, 10, 8),
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(1, 1),
                  blurRadius: 1,
                  spreadRadius: 0,
                  color: Color.fromARGB(131, 110, 110, 110),
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.025,
            width: MediaQuery.of(context).size.width * 0.12,
            child: const Center(
                child: TextBcolorwidget(
              name: ' ยกเลิก ',
              size: 10,
              color: Colors.white,
            )),
          ),
        );
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
                      child: Stack(fit: StackFit.expand, children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              snapshot.data!.docs[index]['url'],
                              fit: BoxFit.fill,
                            )),
                        Positioned(
                            left: 10,
                            top: 10,
                            child: TextBcolorwidget(
                              name: widget.category,
                              size: 16,
                              color: const Color.fromARGB(222, 255, 255, 255),
                            ))
                      ]));
                },
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.22,
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
                            dotHeight: 3,
                            dotWidth: 3,
                            activeDotColor: Colors.deepOrange,
                            dotColor: Colors.grey.shade300))
          ],
        );
      });
  Widget completedicon() => Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(209, 65, 204, 206),
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              offset: Offset(1, 1),
              blurRadius: 1,
              spreadRadius: 0,
              color: Color.fromARGB(131, 110, 110, 110),
            ),
          ],
        ),
        height: MediaQuery.of(context).size.height * 0.025,
        width: MediaQuery.of(context).size.width * 0.12,
        child: const Center(
            child: TextBcolorwidget(
          name: ' เสร็จ ',
          size: 10,
          color: Colors.white,
        )),
      );
  Widget timesupicon() => Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 184, 181, 180),
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              offset: Offset(1, 1),
              blurRadius: 1,
              spreadRadius: 0,
              color: Color.fromARGB(131, 110, 110, 110),
            ),
          ],
        ),
        height: MediaQuery.of(context).size.height * 0.025,
        width: MediaQuery.of(context).size.width * 0.12,
        child: Center(
            child: TextBcolorwidget(
          name: widget.numjoined == widget.numppl ? ' เต็ม ' : ' หมดเวลา ',
          size: 10,
          color: Colors.white,
        )),
      );
}
