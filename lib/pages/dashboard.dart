import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fundamentalscience/pages/message.dart';
import 'package:fundamentalscience/pages/notice.dart';
import 'package:fundamentalscience/pages/event.dart';


class Dashboard extends StatelessWidget{
  Widget ItemCard(itemText,onTapMethod,icon){
    return Container(
      decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(color: Colors.white, spreadRadius: 3)
            ],
            color: Colors.grey.shade300
          ),
      
       margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
          height: 100,
          width: 100,
      child: InkWell(
        onTap: onTapMethod,
        child: Container(
         
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon),
              Text(itemText),
            ],
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exit(0),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
    
          appBar: AppBar(title: const Text('Dashboard'), bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.notifications,),text: 'Notice'),
            Tab(icon: Icon(Icons.event),text: 'Event',),
            Tab(icon: Icon(Icons.message), text: 'Messages',)
          ]), 
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: (){
                  FirebaseAuth.instance.signOut();
                },
                child: const Icon(Icons.logout)),
            )
          ],
          leading: Icon(Icons.home), ),
          body: TabBarView(children: [
            Notice(),
            Event(),
            Messages()
    
          ]),
          
        ),
      ),
    );
  }
}