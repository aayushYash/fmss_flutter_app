import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fundamentalscience/pages/viewMessage.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';

class Messages extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MessagesState();
  }
}

class MessagesState extends State<Messages> {
  Future<List<DocumentSnapshot>> _getDocuments() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('messages').orderBy('time', descending: true).get();
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidPullToRefresh(
        onRefresh: () async{
          setState((){});
          return await Future.delayed(const Duration(seconds: 1));
        },
        color: Colors.black,
        backgroundColor: Colors.grey.shade300,
        showChildOpacityTransition: false,
        height: 200,
        animSpeedFactor: 4,
        child: FutureBuilder<List<DocumentSnapshot>>(
          future: _getDocuments(),
          builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot){
            if(snapshot.hasError) return const Text('Error Occurred');
            if(snapshot.connectionState == ConnectionState.waiting) return const Text('Loading');
            if(snapshot.data?.length == 0 || snapshot.data == null) {
              return Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  
                  Lottie.network("https://lottie.host/17a38dd8-d448-4850-83e3-4af2fbae5e00/AuP6lRAOIY.json", height: 200,width: 200,fit: BoxFit.contain),
                  const Text('No Messages'),
                ],
                          ),
              );
            }
            if(snapshot.hasData) {
              return ListView.separated(
              
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => const Divider(thickness: 1, indent: 15, endIndent: 15, color: Colors.grey,),
              itemBuilder: (context,index){
                var data = snapshot.data?[index].data() as Map<String, dynamic>;
                var id = snapshot.data?[index].id;
                return Dismissible(key: UniqueKey(),
                 onDismissed: (dir){
                  setState(() {
                    
                  });
                 },
                 confirmDismiss: (direction){
                  return showDialog(context: context, builder: (context){
                    return AlertDialog(
                      title: const Text("Are You Sure? \nWant to delete this message?"),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.pop(context,false);
                        }, child: const Text('Cancel')),
                        TextButton(onPressed: (){
                          FirebaseFirestore.instance.collection('messages').doc(id).delete().then((value){
                            Navigator.pop(context,true);
                          }, onError: (e){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString()))
                            );
                          });
                        }, child: const Text('Delete'))
                      ],
                    );
                  });
                 },
                 child: ListTile(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewMessage(data: {'id': id, ...data})));
                  },
                  title: Text(data['name']),
                  subtitle: Text(data['subj']),
                  trailing: (!data['seen'])? const Icon(Icons.circle,color: Colors.grey,) : const Text(''),
                 ),
                 );
              },
            );
            }
            
            return const Center(child: Text('loading'));
          }),
        )
    );
  }
}
