import 'package:flutter/material.dart';

class ReportUser extends StatefulWidget {
  @override
  createState() => new ReportUserState();
}

class ReportUserState extends State<ReportUser>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("举报用户"),
        centerTitle: true,
      ),
      body: new ListView.builder(
        itemCount: 0,
        itemBuilder: (BuildContext context, int index) {
          return null;
        },
      ),
    );
  }
}