import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  FirestoreHelper._();
  static final FirestoreHelper firestoreHelper = FirestoreHelper._();
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  //Insert Record

  Future<void> insertRecord({required Map<String, dynamic> data}) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await db.collection("counter").doc("notes_counter").get();

    Map<String, dynamic>? counterData = documentSnapshot.data();

    int counter = counterData!['counter'];
    int length = counterData!['length'];

    counter++;
    length++;

    await db.collection("notes").doc("$counter").set(data);

    await db
        .collection("counter")
        .doc("notes_counter")
        .update({"counter": counter, "length": length});
  }

//  Fetch Record

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllRecord() {
    return db.collection("notes").snapshots();
  }

//  Delete Record

  Future<void> deleteRecord({required String id}) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await db.collection("counter").doc("notes_counter").get();

    Map<String, dynamic>? counterData = documentSnapshot.data();

    int length = counterData!['length'];

    await db.collection("notes").doc(id).delete();

    length--;

    await db
        .collection("counter")
        .doc("notes_counter")
        .update({"length": length});
  }

//  Update Record
  Future<void> updateRecord(
      {required String id, required Map<String, dynamic> data}) async {
    await db.collection("notes").doc(id).update(data);
  }
}
