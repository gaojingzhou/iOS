import 'package:flutter/material.dart';
import 'package:flutter_uiapp/Chat/chat_home.dart';
import 'package:flutter_uiapp/main.dart';
import 'package:flutter_uiapp/User/UserPage.dart';
import 'package:flutter_uiapp/User/LoginPage.dart';

class YueBanRelease extends StatefulWidget {
  YueBanRelease({Key key, @required this.title,this.username}) : super(key: key);
  final String title;
  final String username;
  @override
  _YueBanReleaseState createState() => _YueBanReleaseState();
}

class _YueBanReleaseState extends State<YueBanRelease> {
  var current_index = 0;
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
  _addGroupDialog(String msg) {
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
            onPressed: (){
              Navigator.of(context).pop();
            }
          ),
        )
      ],
    );
  }
  //创建列表元素
  Container _createElement() {
    var name = "Dick";
    var time = "2019-12-21->2019-12-25";
    var place = "拉萨";
    var msg = "拉萨过年约伴！";
    return Container(
          margin: EdgeInsets.all(20),
          color: Colors.white,
          //height: 320,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Row(
                children: <Widget>[
                //暂时用url
                  FlatButton(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        "http://b-ssl.duitang.com/uploads/item/201704/10/20170410073535_HXVfJ.thumb.700_0.jpeg",
                        width: 46,
                      ),
                    ),
                    onPressed: () {
                      //头像被点击
                      print("头像被按下");
                      // Navigator.of(context)
                      // .pushNamed("/person_router", arguments: name);
                      },
                  ),
                  Text(
                    name,
                    textScaleFactor: 1.5,
                  ),
                  Padding(
                    padding: EdgeInsets.all(30),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 120.0),
                  ),
                  Text(place)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                  ),
                  Text(
                    msg,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(time),
                  FlatButton(
                    child: Icon(Icons.add_circle,color: Colors.black54,),
                    onPressed: (){
                      showDialog(context: context, builder: (_) => _addGroupDialog("成功加入群聊"));
                    },
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15),
              )
            ],
          ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 5),
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return _createElement();
                  },
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                ),
              ),
            ),
          ],
        ),
      ),
      //修改bottomNavigatorBar
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
                  onTap: null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.group, color: Colors.blueAccent,size: 25.0,),
                      Text("约伴", style: TextStyle(color: Colors.blueAccent))
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
