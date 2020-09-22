import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_uiapp/User/PersonalSettingPage.dart';

class SexSettingPage extends StatefulWidget {
  @override
  final String username;
  const SexSettingPage({Key key, this.username}) : super(key: key);
  createState() => new SexSettingPageState();
}

class SexSettingPageState extends State<SexSettingPage>{
  var nameList = ["男","女"];
  String usersex;
  String selectSex;
  Dio dio = new Dio(); //第三方网络加载库

  void initState() {
    super.initState();
    _getUserSex();
  }

  Widget _cell(String funcName){
    Container select;
    if(selectSex == funcName){
      select = Container(
        margin: EdgeInsets.only(left: MediaQuery.of(context).size.width - 165.0),
        child: Icon(
          Icons.done,
          color: Colors.greenAccent,
        ),
      );
    }
    else{
      select = Container();
    }

    return GestureDetector(
      onTap: (){
        setState(() {
          selectSex = funcName;
        });
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
            select,
          ],
        ),
      ),
    );
  }

  _sexSettingPost(String sex) async{
    String url = 'http://localhost:8081/userInfo';

    //以表单形式发送
    FormData data = new FormData.from({
      "username": widget.username,
      "sex":sex,
      "headImg":""
    });
    try{
      Response response = await dio.post(url, data: data);
      setState(() {
        usersex = sex;
      });
    }catch(e){
      print("Connect Error: " + e.toString());
    }
  }

  _getUserSex() async{
    String url = 'http://localhost:8081/userInfo?user_name=${widget.username}';
    await dio.get(url).then((response){
      if(mounted){
        setState(() {
          if((response.data)['message'] == "success"){//响应成功
            usersex = (response.data)["sex"];
            selectSex = (response.data)["sex"];
          }else{
            print("Connect Error");
          }
        });
      }
    });
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("性别设置"),
        centerTitle: true,
        actions: <Widget>[
          Padding(padding: EdgeInsets.only(top: 10.0,right: 10.0),
          child: GestureDetector(
              child: Text(
                "确认",
                style: TextStyle(fontSize: 20.0, color: Color(0xFF1296db)),
              ),
              onTap: () {
                _sexSettingPost(selectSex);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PersonalSettingPage(username: widget.username,);
                }));
              }
          ),
          ),

        ],
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