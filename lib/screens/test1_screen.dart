import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../partyboxbloctest.dart/bloc/partybox_blocs.dart';
import '../partyboxbloctest.dart/bloc/partybox_events.dart';
import '../partyboxbloctest.dart/bloc/partybox_states.dart';
import '../partyboxbloctest.dart/partybox_model.dart';
import 'profile_screen.dart';

class Test1screen extends StatefulWidget {
  const Test1screen({
    Key? key,
  }) : super(key: key);

  @override
  State<Test1screen> createState() => _Test1screenState();
}

class _Test1screenState extends State<Test1screen>
    with AutomaticKeepAliveClientMixin<Test1screen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<PartyboxBloc>(context).add(GetData());
  }

  @override
  Widget build(BuildContext context) {
    print('rebuildpartytestlist');
    super.build(context);

    return BlocBuilder<PartyboxBloc, PartyboxState>(
      // buildWhen: (previous, current) {
      //   return Container();
      // },
      builder: (context, state) {
        if (state is PartyboxAdding) {
          return const AlertDialog(
            content: SizedBox(
              height: 100,
              width: 100,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            ),
          );
        } else if (state is PartyboxLoaded) {
          List<PartyboxModel> data = state.mydata;
          return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (_, index) {
                print(data[index].title);

                return Card(
                  child: ListTile(
                    title: Text(data[index].title),
                    trailing: Text(data[index].createdby),
                    onTap: () {
                      // showModalBottomSheet(
                      //     isScrollControlled: true,
                      //     context: context,
                      //     builder: (BuildContext ctx) {
                      //       return Padding(
                      //         padding: EdgeInsets.only(
                      //             top: 20,
                      //             left: 20,
                      //             right: 20,
                      //             bottom:
                      //                 MediaQuery.of(ctx)
                      //                         .viewInsets
                      //                         .bottom +
                      //                     20),
                      //         child: Column(
                      //           mainAxisSize:
                      //               MainAxisSize.min,
                      //           crossAxisAlignment:
                      //               CrossAxisAlignment
                      //                   .start,
                      //           children: [
                      //             TextFormField(
                      //               initialValue:
                      //                   data[index].name,
                      //               onChanged:
                      //                   (edittext) {
                      //                 editname = edittext;
                      //               },
                      //               decoration:
                      //                   const InputDecoration(
                      //                       labelText:
                      //                           'Name'),
                      //             ),
                      //             TextFormField(
                      //               initialValue:
                      //                   data[index].price,
                      //               keyboardType:
                      //                   const TextInputType
                      //                           .numberWithOptions(
                      //                       decimal:
                      //                           true),
                      //               onChanged:
                      //                   (editprice1) {
                      //                 editprice =
                      //                     editprice1;
                      //               },
                      //               decoration:
                      //                   const InputDecoration(
                      //                 labelText: 'Price',
                      //               ),
                      //             ),
                      //             const SizedBox(
                      //               height: 20,
                      //             ),
                      //             Row(
                      //               children: [
                      //                 ElevatedButton(
                      //                     onPressed:
                      //                         () async {
                      //                       _delete(
                      //                           context,
                      //                           data[index]
                      //                               .id);
                      //                       Navigator.pop(
                      //                           context);
                      //                     }
                      //                     // => BlocProvider
                      //                     //         .of<ProductBloc>(
                      //                     //             context)
                      //                     //     .add(Delete(
                      //                     //         data[index]
                      //                     //             .id))
                      //                     // FirebaseFirestore
                      //                     //     .instance
                      //                     //     .collection(
                      //                     //         'products')
                      //                     //     .doc(data[
                      //                     //             index]
                      //                     //         .id)
                      //                     //     .delete();
                      //                     //   Navigator.pop(
                      //                     //       context);
                      //                     // },
                      //                     ,
                      //                     child: const Text(
                      //                         'delete')),
                      //                 ElevatedButton(
                      //                   child: const Text(
                      //                       'Edit'),
                      //                   onPressed:
                      //                       () async {
                      //                     final double?
                      //                         price =
                      //                         double.tryParse(
                      //                             editprice);
                      //                     if (price !=
                      //                             null &&
                      //                         editname !=
                      //                             '') {
                      //                       _editData(
                      //                           context,
                      //                           data[index]
                      //                               .id);

                      //                       editname = '';
                      //                       editprice =
                      //                           '';
                      //                       Navigator.of(
                      //                               context)
                      //                           .pop();
                      //                     }
                      //                   },
                      //                 ),
                      //               ],
                      //             )
                      //           ],
                      //         ),
                      //       );
                      //     });
                    },
                  ),
                );
              });
        } else if (state is PartyboxLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PartyboxError) {
          return const Center(child: Text("Error"));
        } else {
          return const Profilescreen();
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
