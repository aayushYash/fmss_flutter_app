import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fundamentalscience/component/TextField.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../component/CustomButton.dart';

class EventPage extends StatefulWidget {
  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  FilePickerResult? result;
  List<File>? file = [];
  FirebaseStorage storage = FirebaseStorage.instance;
  var storageRef;
  bool noticeUploaded = false;
  double uploadpercent = 0;
  int count = 0;
  List<dynamic> url = [];
  var db = FirebaseFirestore.instance;
  List storageRefList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Event'),
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
                    hintText: 'Event Title',
                    obscureText: false,
                    multiline: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Textfield(
                    controller: content,
                    icon: Icons.edit,
                    hintText: 'Event Description',
                    obscureText: false,
                    multiline: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (file!.isEmpty)
                    CustomButtom(
                      text: 'Add Images',
                      onTap: () async {
                        result = await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            allowedExtensions: ['jpg', 'png', 'svg'],
                            type: FileType.custom);
                        if (result != null) {
                          List<File> temp = [];
      
                          for (var i = 0; i < result!.files.length; i++) {
                            temp.add(File(result!.files[i].path.toString()));
                          }
      
                          setState(() {
                            return file!.addAll(temp);
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
                  else
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 250,
                                height: 150,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: file!
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: 150,
                                              child: Image.file(
                                                File(e
                                                    .path), // You can access it with . operator and path property
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                )),
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
                                                List durl = [];
                                                if (title.text.isEmpty) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                              content: Text(
                                                    'Event Title can not be empty.',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18),
                                                  )));
                                                  return;
                                                }
                                                var downloadurl = Future.wait(
                                                    file!.map((f) async {
                                                  storageRef = storage
                                                      .ref()
                                                      .child(
                                                          'events/${title.text}')
                                                      .child(
                                                          f.path.split('/').last);
      
                                                  UploadTask uploadTask =
                                                      storageRef.putFile(f);
      
                                                  TaskSnapshot ts =
                                                      await uploadTask
                                                          .whenComplete(() {
                                                    debugPrint('uploaded ');
                                                  });
                                                  return await ts.ref
                                                      .getDownloadURL();
                                                }));
      
                                                downloadurl.then((value) {
                                                  setState(() {
                                                    noticeUploaded = true;
                                                  });
                                                  for (final u in value) {
                                                    setState(() {
                                                      url.add(u);
                                                    });
                                                  }
                                                });
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
                    text: 'Upload Event',
                    onTap: () {
                      if (title.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                          'Event Title can not be empty.',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )));
                        return;
                      }
                      db.collection('events').add({
                        'title': title.text.trim(),
                        'content': content.text.trim(),
                        'pdfurl': url,
                        'uploadtime': Timestamp.now()
                      }).then((value) => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Text("Event Uploaded Successfully."),
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
