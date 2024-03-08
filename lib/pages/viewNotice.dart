import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../component/TextField.dart';

class ViewNotice extends StatefulWidget {
  ViewNotice(
      {super.key, required this.title, required this.notice, required this.id});

  late String title, notice, id;

  @override
  State<ViewNotice> createState() => _ViewNoticeState();
}

class _ViewNoticeState extends State<ViewNotice> {
  String notice = '';
  String title = '';

  bool edit = false;

  TextEditingController noticeController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    notice = widget.notice;
    title = widget.title;
    noticeController.text = widget.notice;
    titleController.text = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: edit
            ? Column(
                children: [
                  Textfield(
                      controller: titleController,
                      icon: Icons.title,
                      hintText: "Title",
                      obscureText: false,
                      multiline: false),
                  Textfield(
                    controller: noticeController,
                    icon: Icons.content_copy,
                    hintText: 'Notice',
                    multiline: true,
                    obscureText: false,
                  ),
                ],
              )
            : Text(notice),
      )),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: edit
              ? () {
                  FirebaseFirestore.instance
                      .collection('notices')
                      .doc(widget.id)
                      .update({
                    'title': titleController.text,
                    'content': noticeController.text
                  }).then((value) {
                    setState(() {
                      edit = false;
                      title = titleController.text;
                      notice = noticeController.text;
                    });
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actions: [
                              TextButton(onPressed: () {
                                Navigator.pop(context);
                                
                              },
                                 child: Text('Ok')),
                        
                            ],
                            title: Text("Notice updated"),
                            content:
                                Text("Notice have been updated Successfully."),
                          );
                        });
                  });
                }
              : () => {
                    setState(() {
                      edit = true;
                    })
                  },
          child: edit
              ? Icon(
                  Icons.upload,
                  color: Colors.white,
                )
              : Icon(
                  Icons.edit,
                  color: Colors.white,
                )),
    );
  }
}
