import 'package:flutter/material.dart';
import 'package:flutter_uiapp/User/SexSettingPage.dart';
import 'package:flutter_uiapp/User/HeadImgSettingPage.dart';
import 'package:flutter_uiapp/User/UserPage.dart';


class PersonalSettingPage extends StatefulWidget {
  @override
  final String username;
  const PersonalSettingPage({Key key, this.username}) : super(key: key);
  createState() => new PersonalSettingPageState();
}

class PersonalSettingPageState extends State<PersonalSettingPage>{
  var nameList = ["头像","性别"];

  Widget _cell(String funcName){
    return GestureDetector(
      onTap: (){
        if(funcName == "性别"){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SexSettingPage(username: widget.username,);
          }));
        }
        else{
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HeadImgSettingPage(username: widget.username,);
          }));
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 15,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              width: 100.0,
              margin: EdgeInsets.only(left: 15.0),
              child: Text(funcName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width - 165.0),
              child: Icon(
                Icons.chevron_right,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.keyboard_arrow_left),
            iconSize: 30.0,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder:
                  (context) => UserPage(username: widget.username,)));
            },
            padding: const EdgeInsets.only(left: 12.0),
            disabledColor: Colors.black),
        title: Text("个人设置"),
        centerTitle: true,
      ),
      body: new ListView.builder(
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return _cell(nameList[index]);
        },
      ),
    );
  }
}