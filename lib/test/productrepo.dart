import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:skinxproject/test/model.dart';

class ProductRepository {
  final _fireCloud = FirebaseFirestore.instance.collection("products");

  Future<void> create({required String name, required String price}) async {
    try {
      await _fireCloud.add({"name": name, "price": price}).then((value) =>
          _fireCloud.doc(value.id).update({"id": value.id.toString()}));
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Failed with error '${e.code}': ${e.message}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ProductModel>> get() async {
    List<ProductModel> proList = [];
    try {
      final pro = await FirebaseFirestore.instance.collection('products').get();
      // ignore: avoid_function_literals_in_foreach_calls
      pro.docs.forEach((element) {
        return proList.add(ProductModel.fromJson(element.data()));
      });
      return proList;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Failed with error '${e.code}':${e.message}");
      }
      return proList;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> delete(id) async {
    var fire = FirebaseFirestore.instance.collection("products").doc(id);
    // var snapshots = await fire.get();
    // for (var doc in snapshots.docs) {
    //   await doc.reference.delete();
    // }
    await fire.delete();
  }

  Future<void> edit({required String name, required String price, id}) async {
    try {
      await _fireCloud.doc(id).update({"name": name, "price": price});
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Failed with error '${e.code}': ${e.message}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
