import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../helper/firebase_auth_helper.dart';
import '../../helper/firestore_helper.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final GlobalKey<FormState> insertKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController taskController = TextEditingController();

  String? title;
  String? task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notes",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuthHelper.firebaseAuthHelper.logOut();

              Navigator.of(context)
                  .pushNamedAndRemoveUntil('login_page', (route) => false);
            },
            icon: const Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: Colors.orangeAccent,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("notes").snapshots(),
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            return Center(
              child: Text("ERROR:${snapShot.error}"),
            );
          } else if (snapShot.hasData) {
            QuerySnapshot<Map<String, dynamic>>? data = snapShot.data;

            if (data == null) {
              return const Center(
                child: Text("No Data Available"),
              );
            } else {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                  data.docs;

              return ListView.builder(
                itemCount: allDocs.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: ListTile(
                      isThreeLine: true,
                      leading: Text(allDocs[i].id),
                      title: Text("${allDocs[i].data()['title']}"),
                      subtitle: Text("${allDocs[i].data()['task']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Map<String, dynamic> records = {
                                'title': allDocs[i].data()['title'],
                                'task': allDocs[i].data()['task'],
                              };
                              updateAndInsert(id: allDocs[i].id, data: records);
                            },
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.blue,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await FirestoreHelper.firestoreHelper
                                  .deleteRecord(id: allDocs[i].id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Record Deleted Successfully..."),
                                  backgroundColor: Colors.redAccent,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          validateAndInsert();
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  validateAndInsert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Add record",
          style: GoogleFonts.poppins(),
        ),
        content: Form(
          key: insertKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter Title First";
                  }
                  return null;
                },
                onSaved: (val) {
                  title = val;
                },
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter Title Here",
                  labelText: "Title",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: taskController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter Task First";
                  }
                  return null;
                },
                onSaved: (val) {
                  task = val;
                },
                maxLines: 5,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter Task Here",
                  labelText: "Task",
                ),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () async {
              if (insertKey.currentState!.validate()) {
                insertKey.currentState!.save();

                Map<String, dynamic> record = {
                  "title": title,
                  "task": task,
                };

                await FirestoreHelper.firestoreHelper
                    .insertRecord(data: record);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Record inserted successfully..."),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                titleController.clear();
                taskController.clear();

                setState(() {
                  title = null;
                  task = null;
                });
                Navigator.of(context).pop();
              }
            },
            child: Text(
              "Add",
              style: GoogleFonts.poppins(),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              titleController.clear();
              taskController.clear();

              setState(() {
                title = null;
                task = null;
              });
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  updateAndInsert({required String id, required Map<String, dynamic> data}) {
    titleController.text = data['title'];
    taskController.text = data['task'];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Add record",
          style: GoogleFonts.poppins(),
        ),
        content: Form(
          key: updateKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter Title First";
                  }
                  return null;
                },
                onSaved: (val) {
                  title = val;
                },
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter Title Here",
                  labelText: "Title",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: taskController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Enter Task First";
                  }
                  return null;
                },
                onSaved: (val) {
                  task = val;
                },
                maxLines: 5,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter Task Here",
                  labelText: "Task",
                ),
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () async {
              if (updateKey.currentState!.validate()) {
                updateKey.currentState!.save();

                Map<String, dynamic> record = {
                  "title": title,
                  "task": task,
                };

                await FirestoreHelper.firestoreHelper
                    .updateRecord(data: record, id: id);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Record Updated successfully..."),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                titleController.clear();
                taskController.clear();

                setState(() {
                  title = null;
                  task = null;
                });
                Navigator.of(context).pop();
              }
            },
            child: Text(
              "Update",
              style: GoogleFonts.poppins(),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              titleController.clear();
              taskController.clear();

              setState(() {
                title = null;
                task = null;
              });
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }
}
