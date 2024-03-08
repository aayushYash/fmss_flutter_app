
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fundamentalscience/pages/viewEvent.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';

import 'eventPage.dart';

class Event extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EventState();
  }
}

class EventState extends State<Event> {
  Future<List<DocumentSnapshot>> _getDocuments() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('events').get();
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidPullToRefresh(
        onRefresh: () async {
          setState(() {});
          return await Future.delayed(const Duration(seconds: 1));
        },
        color: Colors.black,
        backgroundColor: Colors.grey.shade300,
        showChildOpacityTransition: false,
        height: 200,
        animSpeedFactor: 4,

        child: FutureBuilder<List<DocumentSnapshot>>(
            future: _getDocuments(),
            builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if(snapshot.data?.length == 0 || snapshot.data == null) {
              return Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  
                  Lottie.network("https://lottie.host/17a38dd8-d448-4850-83e3-4af2fbae5e00/AuP6lRAOIY.json", height: 200,width: 200,fit: BoxFit.contain),
                  const Text('No Event'),
                ],
                          ),
              );
            }
              if (snapshot.hasData) {
                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) => const Divider(thickness: 1, indent: 15, endIndent: 15, color: Colors.grey,),
                  itemBuilder: (context,index){
                  var data = snapshot.data?[index].data() as Map<String, dynamic>;
                  var id = snapshot.data?[index].id;
                
                  if(snapshot.data!.isEmpty) return const Text("No Events Posted.");
                  return Container(
                    decoration: BoxDecoration(),
                    clipBehavior: Clip.antiAlias,
                    height: 100,
                    child: ListTile(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewEvent(eventData: data,))),
                      trailing: IconButton(icon: Icon(Icons.delete),onPressed: () => showDialog(context: context, builder: (context){
                        return AlertDialog(
                          title: Text("Want to delete ${data['title']}"),
                          actions: [
                            TextButton(onPressed: (){
                            Navigator.pop(context,false);
                          }, child: const Text('Cancel')),
                          TextButton(onPressed: (){
                            for(var i=0;i<data['pdfurl'].length;i++){
                              var deleteId = data['pdfurl'][i].toString();
                              var toDelete = deleteId.replaceAll("https://firebasestorage.googleapis.com/v0/b/fmss-e6463.appspot.com/o/events%2F${data['title']}%2F", '').split('?')[0];
                              FirebaseStorage.instance.ref().child('events/${data["title"]}/$toDelete').delete();
                            }
                            FirebaseFirestore.instance.collection('events').doc(id).delete().then((value) {
                              Navigator.pop(context,true);
                            }, onError: (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString()))
                              );
                            });
                        
                          }, child: const Text('Delete'))
                          ],
                        );
                      }),),
                      title: Text(data['title'],style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text(data['content'].toString().trim()),
                      leading: SizedBox(
                        width: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            
                            Row(
                              children: [
                                Text(DateTime.fromMillisecondsSinceEpoch(data['uploadtime'].seconds*1000).hour.toString()),
                                const Text(":"),
                                Text(DateTime.fromMillisecondsSinceEpoch(data['uploadtime'].seconds*1000).minute.toString()),
                              ],
                            ),
                            Row(
                              children: [
                                Text(DateTime.fromMillisecondsSinceEpoch(data['uploadtime'].seconds*1000).day.toString()),
                                const Text("-"),
                                Text(DateTime.fromMillisecondsSinceEpoch(data['uploadtime'].seconds*1000).month.toString()),
                                const Text("-"),
                                Text(DateTime.fromMillisecondsSinceEpoch(data['uploadtime'].seconds*1000).year.toString()),
                              ],
                            ),
                          ],
                        )),
                    ),
                  );
                });
              }
              return const Center(child: Text('Loading...'));
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EventPage()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
