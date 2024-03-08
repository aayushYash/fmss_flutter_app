import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ViewEvent extends StatefulWidget{

  final eventData;

  const ViewEvent({super.key, this.eventData});

  @override
  State<StatefulWidget> createState() {
    return ViewEventState();
  }
}

class ViewEventState extends State<ViewEvent>{

  String title = '';
  String content = '';
  List images = [];

  @override
  void initState() {
    super.initState();
    title = widget.eventData['title'];
    content = widget.eventData['content'];
    images = widget.eventData['pdfurl'];
  }

  int currentPage = 0;

  List<Widget> indicators(imagesLength,currentIndex) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
      margin: EdgeInsets.all(3),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          color: currentIndex == index ? Colors.black : Colors.black26,
          shape: BoxShape.circle),
    );
  });
}

  @override
  Widget build(BuildContext context) {
    PageController pgCtrl = PageController(initialPage: 0);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(content.trim()),
        ),
        Container(
          height: 350,
          child: PageView.builder(
          itemCount: images.length,
          controller: pgCtrl,
          onPageChanged: (value) => setState(() {
            currentPage = value;
          }),
          itemBuilder:(context,index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(images[index],fit: BoxFit.cover,),
          ),),),
      Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: indicators(images.length,currentPage))
      ]),
    );
  }
}


