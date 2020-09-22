import 'package:flutter/material.dart';

class SystemInformPage extends StatefulWidget {
  @override
  createState() => new SystemInformPageState();
}

class SystemInformPageState extends State<SystemInformPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("系统消息"),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,

        child: Center(
          child: Text("暂时没有系统消息哟~",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20.0,
            ),
          ),
        ),
      )
    );
  }
}