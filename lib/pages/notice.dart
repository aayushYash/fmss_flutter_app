
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fundamentalscience/pages/noticePage.dart';
import 'package:fundamentalscience/pages/viewNotice.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';

class Notice extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoticeState();
  }
}

class NoticeState extends State<Notice> {
 

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

        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('notices').orderBy('uploadtime',descending: true).snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if(snapshot.data?.docs.length == 0 || snapshot.data == null) {
              return Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  
                  Lottie.network("https://lottie.host/17a38dd8-d448-4850-83e3-4af2fbae5e00/AuP6lRAOIY.json", height: 200,width: 200,fit: BoxFit.contain),
                  const Text('No Notice'),
                ],
                          ),
              );
            }
              if (snapshot.hasData) {
                return ListView.separated(
                  itemCount: snapshot.data.docs.length,
                  separatorBuilder: (context, index) => const Divider(thickness: 1, indent: 15, endIndent: 15, color: Colors.grey,),
                  itemBuilder: (context,index){
                  var data = snapshot.data.docs?[index].data() as Map<String, dynamic>;
                  var id = snapshot.data.docs?[index].id;
                  return Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    height: 100,
                    child: ListTile(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewNotice(title: data['title'], notice: data['content'], id: id!))),
                      trailing: IconButton(icon: Icon(Icons.delete),onPressed: () => {
                        showDialog(context: context, builder: (context){
                      return AlertDialog(
                        title: Text("Want to delete ${data['title']}"),
                        actions: [
                          TextButton(onPressed: (){
                          Navigator.pop(context,false);
                        }, child: const Text('Cancel')),
                        TextButton(onPressed: (){
                          if(data['pdf'] != null) FirebaseStorage.instance.ref().child('notices/${data["title"]}').delete();
                          FirebaseFirestore.instance.collection('notices').doc(id).delete().then((value) {
                            Navigator.pop(context,true);
                          }, onError: (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString()))
                            );
                          });
                          setState(() {
                            
                          });
                        }, child: const Text('Delete'))
                        ],
                      );
                    })
                      }),
                      
                      title: Text(data['title'],style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text(data['content'],softWrap: true,),
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
              return const Center(child: Text('loading'));
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NoticePage()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
