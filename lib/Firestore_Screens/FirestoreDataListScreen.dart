import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pupil/Widgets/Messages/ToastMessage.dart';
import '../Widgets/Alerts/LogoutConfirmationDialog.dart';
import 'AddFirestoreDataScreen.dart';

class FirestoreListScreen extends StatefulWidget {
  const FirestoreListScreen({Key? key}) : super(key: key);

  @override
  State<FirestoreListScreen> createState() => _FirestoreListScreenState();
}

class _FirestoreListScreenState extends State<FirestoreListScreen> {
  final _auth = FirebaseAuth.instance;
  final editNameTextController = TextEditingController();
  final editAgeTextController = TextEditingController();
  final editClassTextController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('Students').snapshots();

  CollectionReference ref = FirebaseFirestore.instance.collection('Students');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: false,
          leading: BackButton(
            color: Colors.white),
          title: const Text(
                "Student Details",
                style: TextStyle(color: Colors.white),
              ),
          ),

        body: Column(
          children: [
            const SizedBox(height: 20),

            Container(
              color: Colors.blueAccent,
              height: 40,
              width: 400,
              child: const Center(
                child: Text(
                  'Using Firestore Database',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: fireStore,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 4,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Loading'),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Some Error Occurred!');
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text("Student Name : ${snapshot.data!.docs[index]['name'].toString()}"),
                          subtitle: Text("Age : ${snapshot.data!.docs[index]['age'].toString()} \nClass : ${snapshot.data!.docs[index]['class'].toString()}\nSubject : ${snapshot.data!.docs[index]['subject'].toString()}"),
                          isThreeLine: true,
                          trailing: PopupMenuButton(
                            icon: const Icon(Icons.more_vert_outlined),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: ListTile(
                                  leading: Icon(Icons.edit, color: Colors.deepPurple),
                                  title: Text('Edit', style: TextStyle(color: Colors.deepPurple)),
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: ListTile(
                                  leading: Icon(Icons.delete, color: Colors.red),
                                  title: Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'edit') {
                                showEditTextDialog(
                                  snapshot.data!.docs[index]['name'].toString(),
                                  snapshot.data!.docs[index]['age'].toString(),
                                  snapshot.data!.docs[index]['class'].toString(),
                                  snapshot.data!.docs[index]['id'].toString(),
                                );
                              } else if (value == 'delete') {
                                _deleteDocument(snapshot.data!.docs[index]['id'].toString());
                              }
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddFirestoreDataScreen()),
            );
          },
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add_comment_outlined),
        ),
      ),
    );
  }

  Future<void> showEditTextDialog(String name, String age, String clas, String id) async {
    editNameTextController.text = name;
    editAgeTextController.text = age;
    editClassTextController.text = clas;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          child: AlertDialog(
            title: const Text('Edit Your Details'),
            content: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: SizedBox(
                height:380,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name :"),
                      TextField(
                        controller: editNameTextController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                  Text("Age :"),
                      TextField(
                        controller: editAgeTextController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                  Text("Class :"),
                      TextField(
                        controller: editClassTextController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Update'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _updateDocument(id, editNameTextController.text, editAgeTextController.text, editClassTextController.text);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteDocument(String documentId) async {
    await ref.doc(documentId).delete();
  }

  Future<void> _updateDocument(String documentId, String updatedName, String updatedAge, String updatedClass) async {
    await ref.doc(documentId).update({'name': updatedName});
    await ref.doc(documentId).update({'age': updatedAge});
    await ref.doc(documentId).update({'class': updatedClass});
  }
}
