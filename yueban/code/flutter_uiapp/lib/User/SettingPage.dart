import 'package:flutter/material.dart';
import 'package:flutter_uiapp/User/LoginPage.dart';

class SettingPage extends StatefulWidget {
  @override
  createState() => new SettingPageState();
}

class SettingPageState extends State<SettingPage>{
  var nameList = ["隐私","通用","关于","清除缓存","退出登录"];

  Widget _cell(String funcName){
    return GestureDetector(
      onTap: (){
        if(funcName == '退出登录'){
          Navigator.push(context, MaterialPageRoute(builder:
              (context) => LoginPage()));
        }
        else
          print("empty");
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
                Icons.keyboard_arrow_right,
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
        title: Text("设置"),
        centerTitle: true,
      ),
      body: new ListView.separated(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
            return _cell(nameList[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          if(index == 1 || index == 3){
            return Divider(height: 15.0, color: Color.fromRGBO(250, 250, 250, 1.0));
          }
          else
            return Divider(height: 1.0);
        },
      ),
    );
  }
}