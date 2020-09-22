import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'chat_page.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class message {
  final String image_url;
  final String chatname;

  const message({this.image_url, this.chatname});
}

class ChatList extends StatefulWidget {
  ChatList({Key key, this.username}): super(key: key);
  final String username;
  @override
  _ChatListState createState() => new _ChatListState();
}

Widget divider = Divider(color: Colors.black12, height: 30.0, indent: 18,); //separate line

class _ChatListState extends State<ChatList> {
  Dio dio = new Dio(); //第三方网络加载库


  void initState() {
    super.initState();
    _init();
  }

  var messages = List<message>();
  var chat_count;
/*
  List<String> image_url = [
    "https://img.ivsky.com/img/bizhi/pre/201511/10/chunse_beijing.jpg",
    "https://img.ivsky.com/img/bizhi/pre/201511/10/chunse_beijing-001.jpg",
    "https://img.ivsky.com/img/bizhi/pre/201511/10/chunse_beijing-002.jpg",
    "https://img.ivsky.com/img/bizhi/pre/201511/10/chunse_beijing-003.jpg",
    "https://img.ivsky.com/img/bizhi/pre/201511/10/chunse_beijing-005.jpg",
    "https://img.ivsky.com/img/bizhi/pre/201511/10/chunse_beijing-006.jpg",
    "https://img.ivsky.com/img/bizhi/pre/201511/10/chunse_beijing-007.jpg",
    "https://img.ivsky.com/img/bizhi/pre/201511/10/chunse_beijing-008.jpg",
    "https://img.ivsky.com/img/bizhi/pre/201511/10/chunse_beijing-009.jpg"
  ];

  List<String> username = [
    "广州12.01-12.15", "深圳11.15-11.30", "上海12.10-12.30",
    "长沙1.01-1.15", "苏州9.15-9.30", "南京4.10-4.30",
    "三亚11.01-11.15", "台北2.15-2.30", "郑州6.10-6.30",
  ];

*/

  _init() {
    /*
    for(int i = 0; i < username.length; i ++) {
      var tmp = message(image_url: image_url[i], chatname: username[i]);
      messages.add(tmp);
    }
     */
    _getChatList();

  }

  _getChatList() async{
    //String url = 'http://10.0.2.2:8081/chat_list?user_name=${widget.username}';
    String url = 'http://localhost:8081/chat_list?user_name=admin';
    var result = List<message>();
    var count = 0;
    try {
      var response = await dio.get(url);
      if (response.statusCode == HttpStatus.ok) {
        var data = response.data;
        var items = data['chat_list'];
        count = data['chat_num'];
        //print(items);
        //print(count);
        var len = items.length;
        //get json info
        for (int i = 0; i < len; i ++) {
          var tmp = message(image_url: items[i]['ImgUrl'], chatname: items[i]['ChatName'],);
          result.add(tmp);
        }
      } else {

        print('Error getting IP status ${response.statusCode}');
      }
    } catch (exception) {
      print(exception.toString());
    }
    if (!mounted) return;

    setState(() {
      messages = result;
      chat_count = count;
    });


  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: chat_count, //6 items
      separatorBuilder: (BuildContext context, int index) {return divider;},
      itemBuilder: (BuildContext context, int index) {
        return Dismissible (
          key: new Key(messages[index].chatname),
          movementDuration: const Duration(microseconds: 10),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            child: Container(
              alignment: Alignment.centerRight,
              child: Text("删除", style: TextStyle(color: Colors.white),),
            ),
          ),
          onDismissed: (direction){
            messages.removeAt(index);

            showDialog(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('删除会话'),
                  content:Text('会话已删除'),
                  actions:<Widget>[
                    FlatButton(
                      child: Text('OK'),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    ),

                  ],
                  backgroundColor:Colors.white,
                  elevation: 20,
                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                );
              },
            );
            //messages.removeAt(index);
        },
          child: GestureDetector(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container( //user portrait
                  margin: const EdgeInsets.only(left:14.0, right: 14.0, top: 5),
                  child: new CircleAvatar(
                    backgroundImage: NetworkImage(messages[index].image_url),
                  ),
                ),
                Flexible (
                  child: Column (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //group name
                      new Text(
                        messages[index].chatname,
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                      ),


                      //message data
                      new Container(
                        margin: const EdgeInsets.only(top: 6, bottom: 5),
                        child: new Text("Hi guys...", style: TextStyle(color: Colors.grey),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatPage(msg: messages[index],)));
            },
          )
        );
      },
    );
  }
}