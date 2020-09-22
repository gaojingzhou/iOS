import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'chat_list.dart';
import 'dart:math';
import 'record_list.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';

class chatInfo {
  String text;
  bool isSender;

  chatInfo(this.text, this.isSender);
}

var _infos = List<chatInfo>(); //chat infos
//var _infos = new Map<String, List<chatInfo>>();

String name;


final TextEditingController _textController = new TextEditingController();

int record_count;
int i = 1;
Dio dio = new Dio(); //第三方网络加载库

_addRecordPost(String text) async{
  String url = 'http://localhost:8081/chat_record';
  int recordid;
  print('i: ' + i.toString());
  recordid = record_count + i;

  //以表单形式发送
  FormData frienddata = new FormData.from({
    "chat_name": name,
    "record": text,
    "record_id": recordid.toString(),
  });
  print(frienddata);
  try{
    Response response = await dio.post(url, data: frienddata);
    print(response.data);
  }catch(e){
    print("Connect Error: " + e.toString());
  }
}


void _handleSubmitted(String text) {
  _textController.clear();//清空文本框
  chatInfo info = new chatInfo(
      text,(Random().nextBool())
  );
  _infos.add(info);
  //record_count = record_count + 1;

  for (int i =0; i < _infos.length; i ++)
    if (_infos[i].text == "") _infos.removeAt(i);
  for (int i =0; i < _infos.length; i ++)
    print(_infos[i].text);

  _addRecordPost(text);

  i ++;
}

//构造输入框
Widget _buildTextComposer(){
  return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
          children: <Widget> [
            new Flexible(
                child: new TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  decoration: new InputDecoration.collapsed(hintText: '发送消息'),
                )
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send,color: Colors.blue,),
                  onPressed: () => _handleSubmitted(_textController.text)
              ),
            )
          ]
      )
  );
}


class EntryItem extends StatelessWidget{
  final chatInfo info;
  final message msg;
  const EntryItem(this.info, this.msg);

  Widget row(){
    ///由自己发送，在右边显示
    if(info.isSender){
      return new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: FlatButton(
                      child: new Text(info.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledColor: Colors.lightBlueAccent,
                    ),
                  )
                ]
            ),
          ),
          new Container(
            margin: const EdgeInsets.only(left: 12.0,right: 12.0),
            child: new CircleAvatar(
              backgroundImage: NetworkImage("https://c-ssl.duitang.com/uploads/item/201704/10/20170410073535_HXVfJ.thumb.700_0.jpeg"),
              radius: 24.0,
            ) ,
          ),
        ],
      );
    }
    else{
      ///对方发送，左边显示
      return new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(left: 12.0,right: 12.0),
            child: new CircleAvatar(
              backgroundImage: NetworkImage(msg.image_url),
              radius: 24.0,
            ) ,
          ),
          Flexible(
            child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: FlatButton(
                      child: new Text(info.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledColor: Colors.white,
                    ),
                  )
                ]
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: row(),
    );
  }
}

class ChatPage extends StatefulWidget {
  ChatPage({Key key, @required this.msg}): super(key: key);
  final message msg;
  @override
  _ChatPageState createState() => new _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    i = 1;
    _infos.clear();
    setState(() {
      name = this.widget.msg.chatname;
      print(name);
    });
    _getRecordList();
  }

  _getRecordList() async {
    String url = 'http://localhost:8081/chat_record?user_name=${name}';
    //String url = 'http://10.0.2.2:8081/chat_record?chat_name=admin';
    var result = List<record>();
    var count = 0;
    try {
      var response = await dio.get(url);
      if (response.statusCode == HttpStatus.ok) {
        var data = response.data;
        count = data['record_num'];
        print(count);
      } else {
        print('Error getting IP status ${response.statusCode}');
      }
    } catch (exception) {
      print(exception.toString());
    }
    if (!mounted) return;

    setState(() {
      record_count = count;
    });
  }


  @override


  Widget build(BuildContext context) {
    Widget divider = Divider(color: Colors.white30, height: 18.0, indent: 18,);


    return new Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.white,
        title: new Text(widget.msg.chatname),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.message, color: Colors.black54, size: 30,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:
                  (context) => RecordList(chatname: widget.msg.chatname,)));

            },
          )
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child:new ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return divider;
              },
              padding: new EdgeInsets.all(8.0),
              reverse: false,
              itemBuilder: (context, int index) => EntryItem(_infos[index], widget.msg),
              itemCount: _infos.length,
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(
              color: Colors.white70,
            ),
            child: _buildTextComposer(),
          )
        ],
      ),
    );
  }
}