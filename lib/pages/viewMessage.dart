import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class ViewMessage extends StatefulWidget{

  const ViewMessage({super.key, required this.data} );

  final data;

  @override
  State<ViewMessage> createState() => _ViewMessageState();
}

class _ViewMessageState extends State<ViewMessage> {
    TextEditingController mailBody = TextEditingController();

  @override
  Widget build(BuildContext context) {

    if(!widget.data['seen']) FirebaseFirestore.instance.collection('messages').doc(widget.data['id']).update({"seen" : true});


    return Scaffold(
      appBar: AppBar(title: const Text('Message'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 105,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                    const Icon(Icons.person,size: 30,),
                    const SizedBox(width: 20,),
                    Container(
                      width: 300,
                      decoration:  BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SelectableText(widget.data['name'],style: const TextStyle(fontSize: 20),),
                      ))
                  ],),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                    const Icon(Icons.email,size: 30,),
                    const SizedBox(width: 20,),
                    Container(
                      width: 300,
                      decoration:  BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SelectableText(widget.data['email'],style: const TextStyle(fontSize: 20),),
                      ))
                  ],),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                    const Icon(Icons.phone,size: 30,),
                    const SizedBox(width: 20,),
                    Container(
                      width: 300,
                      decoration:  BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SelectableText(widget.data['phone'],style: const TextStyle(fontSize: 20),),
                      ))
                  ],),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                    const Icon(Icons.subject,size: 30,),
                    const SizedBox(width: 20,),
                    Container(
                      width: 300,
                      decoration:  BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SelectableText(widget.data['subj'],style: const TextStyle(fontSize: 20),),
                      ))
                  ],),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    const Icon(Icons.message,size: 30,),
                    const SizedBox(width: 20,),
                    Container(
                      width: 300,
                      height: 150,
                      decoration:  BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(child: SelectableText(widget.data['msg'],style: const TextStyle(fontSize: 20),)),
                      ))
                  ],),
                ),
              ],
            ),
      
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(left: 12),
                child: Text('Reply...'),),
                Padding(padding: const EdgeInsets.all(12),
                child: Container(
                  child: TextField(
                    controller: mailBody,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Reply Message For Email..',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                    ),
                    
                  ),
                ),),
      
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40  ,
                
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 197, 234, 155),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextButton.icon(
                            label: Text(widget.data['phone']),
                            icon: Icon(Icons.call,color: Colors.green,), onPressed: () async{
                              var phone = widget.data['phone'];
                              launchUrl(Uri.parse("tel:$phone"),mode: LaunchMode.externalNonBrowserApplication).onError((error, stackTrace)  {
                                debugPrint(error.toString());
                                return true;
                          });
                          },
                          
                          ),
                        ),
                        ),
                        const SizedBox(width: 20,),
                        Expanded(
                        child: Container(
                          height: 40  ,
                
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 68, 69, 68),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: IconButton(icon: Icon(Icons.mail,color: Colors.black,), onPressed: () async{
                            var email = widget.data['email'];
                            var subj = "RE:${widget.data['subj']}";
                            var body = mailBody.text;
                            if(body.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter in body to send mail")));
                              return;
                            }
                
                            String url = "mailto:$email?subject=$subj&body=$body";
                            launchUrl(Uri.parse(url),mode: LaunchMode.externalNonBrowserApplication).onError((error, stackTrace)  {
                                debugPrint(error.toString());
                                return true;
                          });
                          },
                          
                          ),
                        ),
                        )
                    ],
                  ),
                ),
              ],
            )
          ]),
      
        ),
      ),
      resizeToAvoidBottomInset: true,

    );
  }
}