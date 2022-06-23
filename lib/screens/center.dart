// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../constans/text.dart';

import '../constans/user.dart';
import '../widgets/addparty_widget.dart';
import 'partylist_screen.dart';
import 'profile_screen.dart';

class Centerscreen extends StatefulWidget {
  final String uid;
  const Centerscreen({Key? key, required this.uid}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CenterscreenState createState() => _CenterscreenState();
}

class _CenterscreenState extends State<Centerscreen> {
  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final CollectionReference _detailuserCollection =
      FirebaseFirestore.instance.collection("user");
  Detailusers detailuser = Detailusers(username: '', phonenumber: 0);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where('uid', isEqualTo: widget.uid)
            //https://petercoding.com/firebase/2020/04/04/using-cloud-firestore-in-flutter/ //
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Detailuserform(
                formKey: formKey,
                detailuser: detailuser,
                detailuserCollection: _detailuserCollection,
                auth: auth);
          }
          final profilename = snapshot.data!.docs.first.get('username');

          final uidindex = snapshot.data!.docs.first.get('uid');

          final phonenumber = snapshot.data!.docs.first.get('phonenumber');
          return Main(
            uid: uidindex,
            inputProfilename: profilename,
            inputPhonenumber: phonenumber,
          );
        });
  }
}

class Main extends StatefulWidget {
  final String uid;
  final String inputProfilename;
  final int inputPhonenumber;
  const Main({
    Key? key,
    required this.uid,
    required this.inputProfilename,
    required this.inputPhonenumber,
  }) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  int _selectedIndex = 0;
  void _navigateBottomNavBar(int index) {
    if (index == 1) {
      showBottomSheet();
      return;
    }
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  final List<Widget> _bodychildren = [
    const Partylistscreen(),
    Container(),
    const Profilescreen()
  ];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;

    _bodychildren;

    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1.5,
          titleSpacing: 10,
          title: Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  backgroundImage: Image.asset(
                    'assets/IMG_2842.JPG',
                  ).image,
                  radius: 20,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Center(
                    child: Text(
                  'Party Hann',
                  style: TextStyle(
                      letterSpacing: 0.5,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                )),
              )
            ],
          )),
      body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _bodychildren),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 4,
        type: BottomNavigationBarType.fixed, //แก้มองไม่เห็นเกินสามตัว//
        currentIndex: _selectedIndex,
        onTap: _navigateBottomNavBar,
        selectedItemColor: const Color.fromARGB(255, 221, 76, 9),

        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),

        iconSize: 25,

        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.cottage_rounded), label: ' ปาร์ตี้ '),
          BottomNavigationBarItem(
              icon: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.deepOrange,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 14,
                    child: Icon(Icons.add, color: Colors.deepOrange),
                  )),
              label: ' '),
          BottomNavigationBarItem(
              backgroundColor: Color.fromARGB(154, 255, 86, 34),
              icon: Icon(Icons.person_pin),
              label: ' โปรไฟล์ '),
        ],
      ),
    );
  }

  showBottomSheet() {
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
              child: const Addpartywidget(
                type: 1,
                docID: '',
                title: '',
                donedate: 0,
                detail: '',
                userID: '',
                numppl: 0,
              ));
        });
  }
}

class Detailuserform extends StatefulWidget {
  const Detailuserform({
    Key? key,
    required this.formKey,
    required this.detailuser,
    required CollectionReference<Object?> detailuserCollection,
    required this.auth,
  })  : _detailuserCollection = detailuserCollection,
        super(key: key);

  final GlobalKey<FormState> formKey;
  final Detailusers detailuser;
  final CollectionReference<Object?> _detailuserCollection;
  final FirebaseAuth auth;

  @override
  State<Detailuserform> createState() => _DetailuserformState();
}

class _DetailuserformState extends State<Detailuserform> {
  String id = '';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 1.5,
            leading: GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Icon(
                Icons.cancel_outlined,
                size: 24,
              ),
            ),
            title:
                const TextSwhitewidget(name: ' กรอกข้อมูลเบี้องต้น ', size: 16),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: GestureDetector(
                      child: const TextSwhitewidget(name: 'บันทึก', size: 16),
                      onTap: () async {
                        if (widget.formKey.currentState!.validate()) {
                          widget.formKey.currentState!.save();

                          await widget._detailuserCollection
                              .doc(widget.auth.currentUser!.uid)
                              .set({
                            'createddate':
                                DateTime.now().millisecondsSinceEpoch,
                            'username': widget.detailuser.username,
                            'uid': widget.auth.currentUser!.uid,
                            'phonenumber': widget.detailuser.phonenumber,
                            'typeuser': 1,
                            'numfollow': 0,
                            'numsaved': 0,
                            'numfollower': 0,
                            'numjoined': 0
                          });
                        } else {
                          // ignore: avoid_print
                          // print(e);
                        }
                      }),
                ),
              )
            ],
          ),
          body: ListView(children: [
            Form(
                key: widget.formKey,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(' รายละเอียด :',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        TextFormField(
                          maxLength: 10,
                          // initialValue: '',
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                            label: TextSwidget(
                                name: ' ชื่อบัญชีผู้ใช้ ', size: 16),
                            counterText: '',
                            border: InputBorder.none,
                          ),
                          onSaved: (valueUsername) {
                            widget.detailuser.username = valueUsername!;
                          },
                          validator: RequiredValidator(errorText: "กรุณากรอก"),
                        ),
                        const Divider(
                          height: 2,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: const InputDecoration(
                            label:
                                TextSwidget(name: ' เบอร์โทรศัพท์ ', size: 16),
                            counterText: "",
                            border: InputBorder.none,
                          ),
                          onSaved: (valuePhonenumber) {
                            widget.detailuser.phonenumber =
                                int.parse(valuePhonenumber.toString());
                          },
                          validator: RequiredValidator(errorText: "กรุณากรอก"),
                        ),
                        const Divider(
                          height: 2,
                        ),
                      ]),
                ))
          ])),
    );
  }
}
