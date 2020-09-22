import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'chat_page.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class record {
  String text;
  record(this.text);
}


class RecordList extends StatefulWidget {
  RecordList({Key key, this.chatname}): super(key: key);
  final String chatname;
  @override
  _RecordListState createState() => new _RecordListState();
}

Widget divider = Divider(color: Colors.black12, height: 1.0, indent: 1,); //separate line

class _RecordListState extends State<RecordList> {
  Dio dio = new Dio(); //第三方网络加载库


  void initState() {
    super.initState();
    _init();
  }

  var records = List<record>();
  var record_count;


  _init() {

    _getRecordList();

  }

  _getRecordList() async{
    print(widget.chatname);
    String url = 'http://localhost:8081/chat_record?user_name=${widget.chatname}';
    //String url = 'http://10.0.2.2:8081/chat_record?chat_name=admin';
    var result = List<record>();
    var count = 0;
    try {
      var response = await dio.get(url);
      if (response.statusCode == HttpStatus.ok) {
        var data = response.data;
        var items = data['chat_record'];
        count = data['record_num'];
        print(items);
        print(count);
        var len = items.length;
        //get json info
        for (int i = 0; i < len; i ++) {
          var tmp = record(items[i]['Record']);

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
      records= result;
      record_count = count;
    });


  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: new Text(
          //title
          "聊天记录",
          style: new TextStyle(
              fontWeight: FontWeight.w500, fontSize: 20.0, color: Colors.black),
        ),
        centerTitle: true,
      ),

      body: ListView.separated(
        itemCount: record_count,
        separatorBuilder: (BuildContext context, int index) {return divider;},
        itemBuilder: (BuildContext context, int index) {
          return Container (
              color: Colors.white,
              child: GestureDetector(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[

                    Flexible (
                        child: Container(
                          child: Text(
                            records[index].text,
                            style: TextStyle(fontSize: 30, color: Colors.black),
                          ),
                          padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
                        )
                    ),
                  ],
                ),

              )
          );
        },
      ),
    );
  }
}