import 'package:flutter/material.dart';

class MyTracks extends StatefulWidget {
  @override
  createState() => new MyTracksState();
}

class MyTracksState extends State<MyTracks>{
  Widget _noContent(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,

      child: Center(
        child: Text("多出去走走吧~",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  Widget _pageBody(){
    int itemCount = 0;

    if (itemCount > 0) {
      return null;
    }
    else {
      return _noContent();
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("我的足迹"),
        centerTitle: true,
      ),
      body: _pageBody(),
    );
  }
}