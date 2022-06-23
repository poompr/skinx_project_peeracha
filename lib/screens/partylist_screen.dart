import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/partyboxlist_widget.dart';

class Partylistscreen extends StatefulWidget {
  const Partylistscreen({
    Key? key,
  }) : super(key: key);

  @override
  State<Partylistscreen> createState() => _PartylistscreenState();
}

class _PartylistscreenState extends State<Partylistscreen>
    with AutomaticKeepAliveClientMixin<Partylistscreen> {
  String userID = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Partyboxlistwidget(
      userID: userID,
      type: 1,
      inputdocID: '',
      typeuser: 1,
      userIDindex: '',
    );
  }

  @override
  bool get wantKeepAlive => true;
}
