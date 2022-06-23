import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constans/text.dart';

class Categorywidget extends StatefulWidget {
  const Categorywidget({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CategorywidgetState createState() => _CategorywidgetState();
}

class _CategorywidgetState extends State<Categorywidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const TextBwhitewidget(name: ' ประเภทปาร์ตี้ ', size: 20),
          elevation: 0.5,
          backgroundColor: Colors.deepOrange,
        ),
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('category').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context,
                              snapshot.data!.docs[index]['categoryname']);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(142, 208, 72, 14),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(3, 2, 3, 2),
                            child: TextBwhitewidget(
                                name: snapshot.data!.docs[index]
                                    ['categoryname'],
                                size: 12),
                          ),
                        ),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: (3.5 / 1)),
                ),
              );
            })

        // return Column(
        //     children: snapshot.data!.docs.map((document) {
        //   final String categoryname = document['categoryname'];

        //   return
        //   InkWell(
        //       onTap: () {
        //         Navigator.pop(context, categoryname);
        //       },
        //       child: Container(
        //         color: Colors.grey,
        //         height: 40,
        //         width: 100,
        //         child: TextBwidget(name: categoryname, size: 12),
        //       ));
        // }).toList());
        );
  }
}
