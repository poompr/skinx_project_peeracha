import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages, library_prefixes
import 'package:path/path.dart' as Path;
import '../constans/partyform.dart';
import '../constans/text.dart';
import 'category_widget.dart';

class Addpartywidget extends StatefulWidget {
  final int type;
  final String docID;
  final String title;

  final int donedate;

  final String detail;

  final String userID;
  final int numppl;
  const Addpartywidget(
      {Key? key,
      required this.type,
      required this.docID,
      required this.title,
      required this.donedate,
      required this.detail,
      required this.userID,
      required this.numppl})
      : super(key: key);

  @override
  State<Addpartywidget> createState() => _AddpartywidgetState();
}

class _AddpartywidgetState extends State<Addpartywidget> {
  @override
  void initState() {
    super.initState();

    partyform.title = widget.title;
    partyform.detail = widget.detail;

    partyform.createdat = widget.donedate;
    partyform.numppl = widget.numppl;
    widget.type == 1
        ? null
        : date = DateTime.fromMillisecondsSinceEpoch(
            int.parse(partyform.createdat.toString()));
  }

  final formKey = GlobalKey<FormState>();
  final userID = FirebaseAuth.instance.currentUser!.uid;
  final picker = ImagePicker();
  final List<File> _briefimage = [];
  final List<File> _image = [];
  bool uploading = false;
  final CollectionReference _partyCollection =
      FirebaseFirestore.instance.collection("party");
  Detailpartyform partyform = Detailpartyform(
      createby: '',
      phonenumber: 0,
      title: '',
      detail: '',
      numppl: 0,
      createdat: 0,
      donedate: 0,
      category: '');

  late Reference ref;
  double val = 0;

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_function_declarations_over_variables
    final VoidCallback onTap = () async {
      final outputdataIndex = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => const Categorywidget()));

      if (outputdataIndex == null) return;

      setState(() => partyform.category = outputdataIndex);
      //callback data
    };
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
                    key: formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const TextBwidget(
                                      name: ' ยกเลิก ', size: 14),
                                ),
                                TextBwidget(
                                    name: widget.type == 2
                                        ? ' แก้ไขรายละเอียดปาร์ตี้ '
                                        : 'สร้างปาร์ตี้ ',
                                    size: 16),
                                GestureDetector(
                                  child: TextBcolorwidget(
                                    name: widget.type == 2
                                        ? ' แก้ไข '
                                        : ' บันทึก ',
                                    size: 14,
                                    color: Colors.deepOrange,
                                  ),
                                  onTap: () async {
                                    if (widget.type == 2) {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        await _partyCollection
                                            .doc(widget.docID)
                                            .update({
                                          'donedate': partyform.donedate,
                                          'title': partyform.title,
                                          'detail': partyform.detail,
                                          'numppl': partyform.numppl,
                                          'edit': true,
                                          'editdated': DateTime.now()
                                              .millisecondsSinceEpoch
                                        });
                                      }

                                      formKey.currentState!.reset();

                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();

                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                    } else {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        await _partyCollection.add({
                                          'createdby': userID,
                                          'createdat': DateTime.now()
                                              .millisecondsSinceEpoch,
                                          'donedate': partyform.donedate,
                                          'title': partyform.title,
                                          'detail': partyform.detail,
                                          'numppl': partyform.numppl,
                                          'partytype': 1,
                                          'numjoined': 0,
                                          'numliked': 0,
                                          'numcomment': 0,
                                          'edit': false,
                                          'editdated': 0,
                                          'completed': false,
                                          'completeddate': 0,
                                          'numsaved': 0,
                                          'category': partyform.category
                                        }).then((value) async {
                                          await uploadbriefFile(value.id);
                                        });
                                      }

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
                              initialValue:
                                  widget.type == 2 ? widget.title : '',
                              maxLength: 50,
                              textAlign: TextAlign.start,
                              decoration: const InputDecoration(
                                counterText: '',
                                label: TextSwidget(
                                    name: ' ชื่อปาร์ตี้ ', size: 14),
                                border: InputBorder.none,
                              ),
                              onSaved: (valueTitle) {
                                partyform.title = valueTitle;
                              },
                              validator:
                                  RequiredValidator(errorText: "กรุณากรอก")),
                          const Divider(
                            height: 2,
                          ),
                          TextFormField(
                            initialValue: widget.type == 2 ? widget.detail : '',
                            minLines: 1,
                            maxLines: 5,
                            maxLength: 300,
                            textAlign: TextAlign.start,
                            decoration: const InputDecoration(
                              label: TextSwidget(
                                name: ' รายละเอียด ',
                                size: 14,
                              ),
                              border: InputBorder.none,
                            ),
                            onSaved: (valueDetail) {
                              partyform.detail = valueDetail;
                            },
                            validator:
                                RequiredValidator(errorText: "กรุณากรอก"),
                          ),
                          const Divider(
                            height: 2,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          widget.type == 2
                              ? TextFormField(
                                  initialValue: widget.numppl.toString(),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.end,
                                  decoration: InputDecoration(
                                    icon: const TextSwidget(
                                        name: ' จำนวนที่ต้องการ ', size: 14),
                                    border: InputBorder.none,
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(10, 8, 10, 8),
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
                                  onSaved: (valueNumppl) {
                                    partyform.numppl =
                                        int.parse(valueNumppl.toString());
                                  },
                                )
                              : TextFormField(
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.end,
                                  decoration: InputDecoration(
                                    icon: const TextSwidget(
                                        name: ' จำนวนที่ต้องการ ', size: 14),
                                    border: InputBorder.none,
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(10, 8, 10, 8),
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
                                  onSaved: (valueNumppl) {
                                    partyform.numppl =
                                        int.parse(valueNumppl.toString());
                                  },
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (widget.type == 1)
                            TextFormField(
                              validator:
                                  RequiredValidator(errorText: "กรุณากรอก"),
                              controller: TextEditingController(
                                  text: partyform.category),
                              onTap: onTap,
                              readOnly: true,
                              textAlign: TextAlign.end,
                              decoration: const InputDecoration(
                                  icon: Text(' ประเภทปาร์ตี้ '),
                                  border: InputBorder.none,
                                  hintText: ' กดเพื่อเลือก '),
                              onSaved: (valueCategory) {
                                partyform.category = valueCategory!;
                              },
                              onChanged: (value) {
                                partyform.category = value;
                              },
                            ),
                          TextFormField(
                            controller: TextEditingController(
                                text: date == null ? '' : getTextDate()),
                            readOnly: true,
                            // initialValue: total[index]['notes'],

                            decoration: InputDecoration(
                              icon: const TextSwidget(
                                  name: ' วันสิ้นสุดปาร์ตี้ ', size: 14),
                              prefix: GestureDetector(
                                  onTap: () {
                                    pickDate(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextSwidget(
                                          name: getTextDate(), size: 14),
                                      const Icon(Icons.arrow_drop_down,
                                          color: Colors.blueGrey)
                                    ],
                                  )),
                              border: InputBorder.none,
                            ),
                            onSaved: (valueDate) {
                              setState(() {
                                partyform.donedate =
                                    date!.millisecondsSinceEpoch;
                                valueDate = partyform.donedate.toString();
                              });
                            },
                            validator:
                                RequiredValidator(errorText: "กรุณากรอก"),
                          ),
                          if (widget.type == 1)
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: TextBwidget(
                                  name: " รูปภาพ (สูงสุด 5 รูป) ", size: 13),
                            ),
                          if (widget.type == 1)
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  // shrinkWrap: true,
                                  itemCount: _briefimage.length + 1,
                                  itemBuilder: (context, index) {
                                    return index == 0
                                        ? Center(
                                            child: IconButton(
                                                icon: const Icon(Icons.add),
                                                onPressed: () => !uploading
                                                    ? chooseBriefImage()
                                                    : null),
                                          )
                                        : Container(
                                            height: 100,
                                            width: 100,
                                            margin: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: FileImage(
                                                        _briefimage[index - 1]),
                                                    fit: BoxFit.cover)),
                                          );
                                  }),
                            ),
                          if (widget.type == 2)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    await _partyCollection
                                        .doc(widget.docID)
                                        .collection('partypic')
                                        .get()
                                        .then(
                                            // ignore: avoid_function_literals_in_foreach_calls
                                            (value) => value.docs
                                                    // ignore: avoid_function_literals_in_foreach_calls
                                                    .forEach((element) async {
                                                  await _partyCollection
                                                      .doc(widget.docID)
                                                      .collection('partypic')
                                                      .doc(element.id)
                                                      .delete();
                                                }))
                                        .then((value) async =>
                                            await _partyCollection
                                                .doc(widget.docID)
                                                .delete());
                                    await _partyCollection
                                        .doc(widget.docID)
                                        .delete();
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context);
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context);
                                  },
                                  child: const TextBcolorwidget(
                                    name: ' ลบรายการปาร์ตี้นี้ ',
                                    size: 15,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                              ),
                            )
                        ])))));
  }

  Future<void> retrieveLostData() async {
    // ignore: deprecated_member_use
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file!.path));
      });
    } else {
      // ignore: avoid_print
      print(response.file);
    }
  }

  chooseBriefImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      // ignore: unnecessary_null_comparison
      if (_briefimage.length < 5 && _briefimage.isNotEmpty) {
        _briefimage.add(File(pickedFile!.path));
        // ignore: avoid_print
        print(_briefimage.length);
      }
    });
    // error when cancel on ios system//
    // if (pickedFile?.path == null) return retrieveLostData();
  }

  Future uploadbriefFile(docIdIndex) async {
    int i = 1;

    for (var img in _briefimage) {
      setState(() {
        val = i / _briefimage.length;
      });
      ref = FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          _partyCollection
              .doc(docIdIndex)
              .collection('partypic')
              .add({'url': value});

          i++;
        });
      });
    }
  }

  DateTime? date;

  String getTextDate() {
    // ignore: unnecessary_null_comparison
    if (date == null) {
      return ' เลือกวันที่ ';
    } else {
      return DateFormat('dd/MM/yyyy').format(date!);
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = widget.type == 2
        ? DateTime.fromMillisecondsSinceEpoch(
            int.parse(partyform.createdat.toString()))
        : DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: date ?? initialDate,
        // ?? เวลาเลือกใหม่แล้วจะดึงค่าที่เคยเลือกไว้แสดงก่อน
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1));
    if (newDate == null) return;
    setState(() {
      date = newDate;
      partyform.donedate = date!.millisecondsSinceEpoch;
    });
  }
}
