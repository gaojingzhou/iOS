import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'chat_list.dart';
import 'friend_list.dart';
import 'nearby_list.dart';
import 'add_friend.dart';
import 'package:flutter_uiapp/main.dart';
import 'package:flutter_uiapp/User/UserPage.dart';
import 'package:flutter_uiapp/User/LoginPage.dart';
import 'package:flutter_uiapp/YueBan/YueBanMainPage.dart';

class ChatHome extends StatefulWidget {
  ChatHome({Key key, this.username}) : super(key: key);
  final String username;
  @override
  _ChatHomeState createState() => new _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> with SingleTickerProviderStateMixin{
  TabController _tabController;

  @override

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
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
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: new Text(
          //title
          "社区",
          style: new TextStyle(
              fontWeight: FontWeight.w500, fontSize: 20.0, color: Colors.black),
        ),
        centerTitle: true,

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_add, color: Colors.black54, size: 30,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:
                  (context) => AddPage(username: widget.username,)));

            },
          )
        ],

        bottom: new TabBar(
            tabs: <Widget>[
              new Tab(
                icon: new Icon(Icons.chat, color: Colors.grey, size: 20,),
                text: "聊天",
              ),
              new Tab(
                icon: new Icon(Icons.group, color: Colors.grey, size: 20,),
                text: "好友",
              ),
              new Tab(
                icon: new Icon(Icons.wifi_tethering, color: Colors.grey, size: 20,),
                text: "附近",
              ),
            ],
          controller: _tabController,
        ),
      ),

      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new Center(
              child: Container(
                child: new ChatList(username: widget.username,),
                margin: EdgeInsets.only(top: 20),
              )
          ),
          new Center(
              child: new FriendList(username: widget.username,)
          ),
          new Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      FlatButton.icon(

                        icon: Icon(Icons.location_on),
                        disabledColor: Colors.white,
                        label: Text(" "),
                        padding: EdgeInsets.only(top: 12, bottom: 12),

                      ),

                      FlatButton(
                        child: new FlutterDropdownButtonStatefulWidget(),
                        disabledColor: Colors.white,
                        //padding: EdgeInsets.only(left: 100, right: 167.4),
                      ),

                    ],

                  ),

                  Container(
                    height: 509,
                    width: 500,
                    child: new NearbyList(username: widget.username,),
                  ),
                ],
              )
          ),
        ],
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
                      Text("动态", style: TextStyle(color: Colors.black54))
                    ],
                  )),
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
                  )),
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
                  onTap: null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.forum, color: Colors.blueAccent),
                      Text("社区", style: TextStyle(color: Colors.blueAccent))
                    ],
                  )),
              GestureDetector(
                  onTap: (){
                    if(widget.username == "" || widget.username == null){
                      Navigator.push(context, MaterialPageRoute(builder:
                          (context) => LoginPage()));
                    }
                    else{
                      Navigator.push(context, MaterialPageRoute(builder:
                          (context) => UserPage(username: widget.username,)));
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.person, color: Colors.black54),
                      Text("我的", style: TextStyle(color: Colors.black54))
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}



class FlutterDropdownButtonStatefulWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DropdownState();
  }
}



class _DropdownState extends State<FlutterDropdownButtonStatefulWidget> {

  String selectValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 291,
      child: DropdownButton(
        //要显示的条目
        items: _getCityList(),
        //默认显示的值
        hint: Text("北京"),
        isDense: false,
        iconSize: 30,
        elevation: 0,
        value: selectValue,
        onChanged: (itemValue) {//itemValue为选中的值
          //print("itemValue=$itemValue");
          _onChanged(itemValue);
        },
      ),
    );
  }
  _onChanged(String value) {
    //更新对象的状态
    setState(() {
      selectValue = value;
    });
  }
}


List<DropdownMenuItem<String>> _getCityList() {
  var list = ["北京", "上海", "广州", "深圳", "更多..."];
  return list.map((item) => DropdownMenuItem(
    value: item,
    child: Text(item),
  )).toList();
}





