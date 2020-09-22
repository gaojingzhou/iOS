import 'package:flutter/material.dart';

class HobbyTag extends StatefulWidget {
  @override
  createState() => new HobbyTagState();
}

class HobbyTagState extends State<HobbyTag>{
  List<Widget> _selectedTag(){
    List<String> tagList = ['登山', '民宿达人', '暴走族'];
    List<MaterialColor> colorList = [Colors.pink, Colors.lightBlue, Colors.yellow];
    int tagCount = tagList.length;
    List<Widget> children = List();

    for(int i = 0; i < tagCount; i++){
      children.add(new Container(
        height: 40.0,
        margin: EdgeInsets.only(left: 20.0),
        child: RaisedButton(
          child: Text(tagList[i],
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          disabledColor: colorList[i],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
      ));
    }

    return children;
  }

  Widget _pageBody(){
    return Container(
      child: Wrap(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            margin: EdgeInsets.all(10.0),
            alignment: Alignment.centerLeft,
            child: Text('已选: ',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Container(
            height: 50.0,
            child: Row(
              children: _selectedTag(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("爱好标签"),
        centerTitle: true,
      ),
      body: _pageBody(),
    );
  }
}