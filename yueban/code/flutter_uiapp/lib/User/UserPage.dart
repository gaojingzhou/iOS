import 'package:flutter/material.dart';
import 'package:flutter_uiapp/User/SettingPage.dart';
import 'package:flutter_uiapp/User/PersonalSettingPage.dart';
import 'package:flutter_uiapp/User/SystemInformPage.dart';
import 'package:flutter_uiapp/User/MyPublished.dart';
import 'package:flutter_uiapp/User/MyFavorites.dart';
import 'package:flutter_uiapp/User/MyPartner.dart';
import 'package:flutter_uiapp/User/MyTracks.dart';
import 'package:flutter_uiapp/User/HobbyTag.dart';
import 'package:flutter_uiapp/User/ReportUser.dart';
import 'package:flutter_uiapp/User/ContactUs.dart';
import 'package:flutter_uiapp/Chat/chat_home.dart';
import 'package:flutter_uiapp/main.dart';
import 'package:flutter_uiapp/YueBan/YueBanMainPage.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter_uiapp/User/LoginPage.dart';

class UserPage extends StatefulWidget{
  @override
  final String username;
  const UserPage({Key key, this.username}) : super(key: key);
  createState() => new UserPageState();
}

class UserPageState extends State<UserPage>{
  var nameList = ["我的发布","我的收藏","我的约伴","我的足迹","爱好标签","举报用户","联系我们"];
  var iconList = [
    Icons.create, Icons.star, Icons.record_voice_over, Icons.filter_hdr,
    Icons.favorite, Icons.thumb_down, Icons.call
  ];
  var colorList = [Colors.orange, Colors.yellow, Colors.purple, Colors.green, Colors.red, Colors.brown, Colors.blue];
  String imgurl = "";
  Dio dio = new Dio(); //第三方网络加载库
  //记录选择的照片
  File _image;

  Container headContainer;
  @override
  void initState() {
    super.initState();
    _getUserHeadImg();
  }

  Widget _topView(){
    return Container(
      height: MediaQuery.of(context).size.height / 4.5,
      width: MediaQuery.of(context).size.width,
      color: Color.fromRGBO(69, 158, 214, 1.0),
      child: Stack(
        children: <Widget>[
          //左上角icon
          Container(
            margin: EdgeInsets.only(top: 10.0, left: 10.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SettingPage();
                }));
              },
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
            ),
          ),

          //右上角icon
          Container(
            margin: EdgeInsets.only(top: 10.0, left: MediaQuery.of(context).size.width - 50.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SystemInformPage();
                }));
              },
              icon: Icon(
                Icons.mail_outline,
                color: Colors.white,
              ),
            ),
          ),

          //头像
          headContainer,
          //用户名字
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 15.0 + 30.0, left: MediaQuery.of(context).size.height/9 + 50.0),
            child: Text(widget.username,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          //个人设置
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PersonalSettingPage(username: widget.username,);
              }));
            },
            child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 15.0 + 40.0, left: MediaQuery.of(context).size.width - 80.0),
              child: Row(
                children: <Widget>[
                  Text("个人设置",
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(String funcName, IconData funcIcon, MaterialColor color){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          if(funcName == "我的发布")
            return MyPublished(username: widget.username,);
          else if(funcName == "我的收藏")
            return MyFavorites(username: widget.username,);
          else if(funcName == "我的约伴")
            return MyPartner();
          else if(funcName == "我的足迹")
            return MyTracks();
          else if(funcName == "爱好标签")
            return HobbyTag();
          else if(funcName == "举报用户")
            return ReportUser();
          else
            return ContactUs();
        }));
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 15,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 15.0),
              child: Icon(funcIcon,
                color: color,
              ),
            ),

            Container(
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

  _getUserHeadImg() async{
    String url = 'http://localhost:8081/userInfo?user_name=${widget.username}';
    await dio.get(url).then((response){
      if(mounted){
        setState(() {
          if((response.data)['message'] == "success"){//响应成功
            imgurl = (response.data)["img"];
            if(imgurl != ""){
              _image = File(imgurl);
            }
          }else{
            print("Connect Error");
          }
        });
      }
    });
  }

  _generateAlertDialog(String msg) {
    return AlertDialog(
      // 设置弹窗圆角
      shape: RoundedRectangleBorder(borderRadius:
      BorderRadius.circular(10.0)),
      title: Text(msg,
        style: new TextStyle(fontSize: 25.0,
            color: Colors.black,
            fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[

        Container(
          width: 80.0,
          height: 30.0,
          child: FlatButton(
            color: Color(0xFF1296db),
            child: Text('OK',style: new TextStyle(fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,),
            // 设置按钮圆角
            shape: RoundedRectangleBorder(borderRadius:
            BorderRadius.circular(10.0)),
            onPressed: () {
              //跳转回登陆界面
              Navigator.push(context, MaterialPageRoute(builder:
                  (context) => LoginPage()));
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    if(_image == null){
      headContainer = Container(
        width: MediaQuery.of(context).size.height / 9,
        height: MediaQuery.of(context).size.height / 9,
        margin: EdgeInsets.only(left: 20.0, top: MediaQuery.of(context).size.height / 15.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("resources/dog.jpeg"),
          ),
        ),
      );
    }
    else{
      headContainer = Container(
        width: MediaQuery.of(context).size.height / 9,
        height: MediaQuery.of(context).size.height / 9,
        margin: EdgeInsets.only(left: 20.0, top: MediaQuery.of(context).size.height / 15.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: FileImage(_image),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1.0),
      body: new ListView.separated(
          itemCount: 8,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0)
              return _topView();
            else
              return _cell(nameList[index - 1], iconList[index - 1], colorList[index - 1]);
          },
          separatorBuilder: (BuildContext context, int index) {
            if(index == 0 || index == 1 || index == 5){
              return Divider(height: 15.0, color: Color.fromRGBO(250, 250, 250, 1.0));
            }
            else
              return Divider(height: 1.0);
          },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog<Null>(
            context: context,
            builder: (BuildContext context) {
              return new SimpleDialog(
                // title: new Text('选择'),
                children: <Widget>[
                  new Container(
                    width: 300,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // 此处为发布动态
                        GestureDetector(
                          onTap: (){
                            if(widget.username == null || widget.username == ""){
                              showDialog(context: context, builder: (_) => _generateAlertDialog("请先登录"));
                            }
                            else{
                              print("这里是发布动态");
                            }

                          },
                          child: Column(
                            children: <Widget>[
                              new ClipOval(
                                child: Image.network(
                                  "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1579420558&di=5e2fdb134cd947e7ce05a0e6d5dbe559&imgtype=jpg&er=1&src=http%3A%2F%2Fku.90sjimg.com%2Felement_origin_min_pic%2F01%2F60%2F12%2F2957487f7fa2f2c.jpg",
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              Padding(padding: EdgeInsets.only(top:10),),
                              Text(
                                "发布动态",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                        ),
                        // 此处为发起约伴
                        Padding(
                          padding: EdgeInsets.all(20.0),
                        ),
                        GestureDetector(
                          onTap: (){
                            if(widget.username == null || widget.username == ""){
                              showDialog(context: context, builder: (_) => _generateAlertDialog("请先登录"));
                            }
                            else{
                              print("这里是发起约伴");
                            }
                          },
                          child: Column(
                            children: <Widget>[
                              new ClipOval(
                                child: Image.network(
                                  "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1579420476&di=bf1de1edbcc099ca6b1dfa2ec756d292&imgtype=jpg&er=1&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F2008fcbce567095b4c868f811edac81d0f869f79481f-mNs4Dv_fw658",
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              Padding(padding: EdgeInsets.only(top:10),),
                              Text(
                                "发起约伴",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                        )

                      ],
                    ),
                  )

                ],
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => MyHomePage(username: widget.username,)));
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.public, color: Colors.black54,size: 25.0,),
                      Text("动态", style: TextStyle(color: Colors.black54)
                      )],
                  )
              ),
              GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => YueBanMainPage(username: widget.username,)));
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.group, color: Colors.black54,size: 25.0,),
                      Text("约伴", style: TextStyle(color: Colors.black54))
                    ],
                  )
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: Text("发布", style: TextStyle(color: Colors.black54, fontSize: 16.0)),
                  )
                ],
              ),
              GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => ChatHome(username: widget.username,)));
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.forum, color: Colors.black54),
                      Text("社区", style: TextStyle(color: Colors.black54))
                    ],
                  )),
              GestureDetector(
                  onTap: null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.person, color: Colors.blueAccent),
                      Text("我的", style: TextStyle(color: Colors.blueAccent))
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}