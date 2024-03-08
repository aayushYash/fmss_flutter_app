import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fundamentalscience/component/TextField.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../component/CustomButton.dart';

class NoticePage extends StatefulWidget {
  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  FilePickerResult? result;
  File? file;
  FirebaseStorage storage = FirebaseStorage.instance;
  var storageRef;
  bool noticeUploaded = false;
  double uploadpercent = 0;
  var url;
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Notice'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Textfield(
                    controller: title,
                    icon: Icons.pages,
                    hintText: 'Notice Title',
                    obscureText: false,
                    multiline: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Textfield(
                    controller: content,
                    icon: Icons.edit,
                    hintText: 'Notice Body',
                    obscureText: false,
                    multiline: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  file == null
                      ? CustomButtom(
                          text: 'Add Pdf',
                          onTap: () async {
                            result = await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                allowedExtensions: ['pdf', 'jpg'],
                                type: FileType.custom);
      
                            if (result != null) {
                              setState(() {
                                file = File(result!.files.first.path!);
                              });
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("File not selected."),
                                duration: Duration(seconds: 2),
                              ));
                            }
                          },
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 200, child: Text(file!.path)),
                                noticeUploaded
                                    ? const Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.green,
                                          size: 28,
                                        ),
                                      )
                                    : uploadpercent > 0.0 && uploadpercent < 100
                                        ? SizedBox(
                                            width: 130,
                                            child: LinearProgressIndicator(
                                              minHeight: 16,
                                              value: uploadpercent,
                                              color: Colors.lightGreen,
                                            ),
                                          )
                                        : Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () async {
                                                    if (title.text.isEmpty) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              const SnackBar(
                                                                  content: Text(
                                                        'Notice Title can not be empty.',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18),
                                                      )));
                                                      return;
                                                    }
                                                    if (file!.existsSync()) {
                                                      try {
                                                        storageRef = storage
                                                            .ref()
                                                            .child('notices')
                                                            .child(file!.path.split('/').last);
      
                                                        storageRef
                                                            .putFile(file!)
                                                            .snapshotEvents
                                                            .listen(
                                                                (taskSnapshot) async {
                                                          switch (taskSnapshot
                                                              .state) {
                                                            case TaskState
                                                                  .running:
                                                              setState(() {
                                                                uploadpercent = 100 *
                                                                    (taskSnapshot
                                                                            .bytesTransferred /
                                                                        taskSnapshot
                                                                            .totalBytes) as double;
                                                              });
                                                              break;
                                                            case TaskState
                                                                  .success:
                                                                var u = await storageRef
                                                                    .getDownloadURL();
      
                                                                    debugPrint(u.toString());
                                                              const Text('uploaded');
                                                              setState(() {
                                                                noticeUploaded =
                                                                    true;
                                                                    url = u;
                                                              });
                                                              break;
                                                          }
                                                        });
                                                      } on FirebaseException catch (e) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(e
                                                                    .message
                                                                    .toString())));
                                                      }
                                                    }
                                                    
                                                  },
                                                  icon: const Icon(Icons.upload)),
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      file = null;
                                                    });
                                                  },
                                                  icon: const Icon(Icons.close)),
                                            ],
                                          ),
                              ],
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButtom(
                    text: 'Publish Notice',
                    onTap: () {
                      if (title.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                          'Notice Title can not be empty.',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        )));
                        return;
                      }
                      db.collection('notices').add({
                        'title': title.text.trim(),
                        'content': content.text.trim(),
                        'pdfurl': url,
                        'uploadtime': Timestamp.now()
                      }).then((value) => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Text("Notice Published Successfully."),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        var count = 0;
                                        Navigator.of(context).popUntil((route) {
                                          return count++ == 2;
                                        });
                                      },
                                      child: const Text('Done!!'))
                                ],
                              )));
                    },
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
