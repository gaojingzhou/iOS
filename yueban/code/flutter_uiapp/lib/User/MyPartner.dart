import 'package:flutter/material.dart';

class MyPartner extends StatefulWidget {
  @override
  createState() => new MyPartnerState();
}

class MyPartnerState extends State<MyPartner>{
  Widget _cell(String partialContent){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.all(10.0),
      child: Wrap(
        children: <Widget>[
          Container(
            width: 50.0,
            height: 50.0,
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("resources/dog.jpeg"),
              ),
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width - 160.0,
            height: 50.0,
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            alignment: Alignment.topLeft,
            child: Text("用户AAA",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ),

          Container(
            width: 50.0,
            height: 30.0,
            margin: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Text("约伴成功",
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black,
              ),
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width - 40.0,
            height: 50.0,
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
            alignment: Alignment.centerLeft,
            child: Text(partialContent,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _noContent(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,

      child: Center(
        child: Text("尚未约伴成功哟~",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  Widget _pageBody(){
    int itemCount = 10;
    String partialContent = "本人月入十亿，求可爱的小gaigai和我一起去旅游";

    if (itemCount > 0) {
      return ListView.builder(
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          return _cell(partialContent);
        },
      );
    }
    else {
      return _noContent();
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("我的约伴"),
        centerTitle: true,
      ),
      body: _pageBody(),
    );
  }
}