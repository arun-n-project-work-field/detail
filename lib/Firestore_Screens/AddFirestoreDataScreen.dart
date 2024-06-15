import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pupil/Widgets/Messages/ToastMessage.dart';
import 'package:pupil/Widgets/Buttons/RoundButtons.dart';
import 'package:flutter/material.dart';

import 'FirestoreDataListScreen.dart';

class AddFirestoreDataScreen extends StatefulWidget {
  const AddFirestoreDataScreen({super.key});

  @override
  State<AddFirestoreDataScreen> createState() => _AddFirestoreDataScreenState();
}

class _AddFirestoreDataScreenState extends State<AddFirestoreDataScreen> {
  bool loading = false;
  final nameController = TextEditingController();
  final classController = TextEditingController();
  final ageController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('Students');
  List<String> subjectItems = ["Select One Subject"];
  String selectedSubject = "None";

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
              color: Colors.white,
            ),
            title: Text(
              "Add Firestore Data",
              style: TextStyle(color: Colors.white),
            )),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  color: Colors.blueAccent,
                  height: 40,
                  width: 400,
                  child: const Center(
                    child: Text(
                      'Student Details Form',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    maxLines: 4,
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    decoration: InputDecoration(
                      // labelText: 'Text',
                      hintText: 'Enter your Name',
                      // prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    maxLines: 4,
                    keyboardType: TextInputType.number,
                    controller: ageController,
                    decoration: InputDecoration(
                      // labelText: 'Text',
                      hintText: 'Enter your Age',
                      // prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    maxLines: 4,
                    keyboardType: TextInputType.number,
                    controller: classController,
                    decoration: InputDecoration(
                      // labelText: 'Text',
                      hintText: 'Enter your Class',
                      // prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("subjectlist")
                        .snapshots(),
                    builder: (context, snapshot) {
                      for (int index = 0;
                          index < snapshot.data!.docs.length;
                          index++) {
                        subjectItems.add(
                            snapshot.data!.docs[index]['subject'].toString());
                      }
                      String dropdownValue = "Select One Subject";

                      return SizedBox(
                          height: 50,
                          child: DropdownMenu<String>(
                            initialSelection: subjectItems.first,
                            onSelected: (String? value) {
                              setState(() {
                                dropdownValue = value!;
                                selectedSubject = value!;
                              });
                            },
                            dropdownMenuEntries: subjectItems
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value, label: value);
                            }).toList(),
                          ));
                    }),
                const SizedBox(
                  height: 150,
                ),
                RoundButton(
                    title: "Add Student Details into Firestore",
                    loading: loading,
                    onTap: () {
                      setState(() {
                        loading = true;
                      });

                      String id =
                          DateTime.now().millisecondsSinceEpoch.toString();

                      fireStore.doc(id).set({
                        'name': nameController.text.toString(),
                        'age': ageController.text.toString(),
                        'class': classController.text.toString(),
                        'subject': selectedSubject,
                        'id': id,
                      }).then((value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const FirestoreListScreen()));
                        ToastMessage().toastMessage(
                            "Student Details Added to Firestore Database!");
                        FocusScope.of(context).unfocus();
                        setState(() {
                          loading = false;
                        });
                      }).onError((error, stackTrace) {
                        ToastMessage().toastMessage(error.toString());
                        setState(() {
                          loading = false;
                        });
                      });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
