import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'search_page.dart';
import 'personal_page.dart';
import 'Info.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';


class FriendList extends StatefulWidget {
  FriendList({Key key, this.username}): super(key: key);
  final String username;
  @override
  _FriendListState createState() => new _FriendListState();
}

Widget divider = Divider(color: Colors.black12, height: 40.0, indent: 18,); //separate line

class _FriendListState extends State<FriendList> {
  Dio dio = new Dio(); //第三方网络加载库

  void initState() {
    super.initState();
    _init();
  }


  var friends = List<Info>();
  var friend_count;

  /*
  var img = [
    " ",
    "https://pic3.zhimg.com/80/v2-8eed44a6f3fbe92e203295994a6af3f3_hd.jpg",
    "https://pic4.zhimg.com/80/v2-3fa13c445bcb89ce3227836a5e9d1ae9_hd.jpg",
    "https://pic2.zhimg.com/80/v2-cc94ebe6d1f78ba11d344b890cc48c70_hd.jpg",
    "https://pic2.zhimg.com/80/v2-572d39bea884153449ecaa58a422809c_hd.jpg",
    "https://pic4.zhimg.com/80/v2-b0481685f305e4f56991ae9f2df276a8_hd.jpg",
    "https://pic3.zhimg.com/80/v2-97431e5c2ea30d83a61e217f22f4e7b2_hd.jpg"
  ];

  var name = [" ","Mike", "Candy", "Jake", "Brian", "Kay", "Niki"];

  var sex = [" ", "male", "female", "male", "male", "female", "female"];

*/
  _init() {
    _getFriendList();

  }

  _getFriendList() async{
    //String url = 'http://localhost:8081/friend_list?user_name=${widget.username}';
    String url = 'http://localhost:8081/friend_list?user_name=admin';
    var result = List<Info>();
    var count = 0;
    try {
      var response = await dio.get(url);
      if (response.statusCode == HttpStatus.ok) {
        var data = response.data;
        var items = data['friend_list'];
        count = data['friend_num'];
        print(items);
        print(count);
        var len = items.length;
        //get json info
        for (int i = 0; i < len; i ++) {
          var tmp = Info(image_url: items[i]['Img'], name: items[i]['FriendName'], sex: items[i]['Sex']);

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
      friends = result;
      friend_count = count;
    });


  }



  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: friend_count, //6 items
      separatorBuilder: (BuildContext context, int index) {return divider;},
      itemBuilder: (BuildContext context, int index) {
        return Container (
            key: new Key(friends[index].name),

            child: GestureDetector(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: index != 0 ? <Widget>[
                  Container( //user portrait
                    margin: const EdgeInsets.only(left:14.0, right: 14.0),
                    child: new CircleAvatar(
                      backgroundImage: NetworkImage(friends[index].image_url),
                    ),
                  ),
                  Flexible (
                    child: Column (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //group name
                        new Text(
                          friends[index].name,
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, height: 1.7),
                        ),


                        //message data
                        new Container(
                          margin: const EdgeInsets.only(top: 6, bottom: 5),
                          child: new Text(" ", style: TextStyle(color: Colors.grey),),
                        ),
                      ],
                    ),
                  ),
                  IconButton (
                    icon: friends[index].sex == "male" ? Icon(
                      Icons.face,
                      color: Colors.lightBlueAccent,
                      size: 15,
                    ) : Icon(
                      Icons.face,
                      color: Colors.pinkAccent,
                      size: 15,
                    ),
                    alignment: Alignment.topLeft,
                  ),
                ]

                    : <Widget>[
                  Container(

                    margin: const EdgeInsets.only(left:7.0, right: 14.0, top: 10),
                    child: IconButton(
                      icon: Icon(Icons.search, color: Colors.grey,),
                      alignment: Alignment.centerLeft,
                    )
                  ),
                  Flexible (
                    child: Container (
                      child: Column (
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //group name
                         Container(
                           child:  new Text(
                             "搜索...",
                             style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, height: 2, color: Colors.grey),
                           ),
                           padding: EdgeInsets.only(top: 13),
                         ),

                        ],
                      ),
                    )
                  ),
                ],
              ),
              onTap: (){
                if(index == 0) {
                   Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPage()));
                }
                else{
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PersonalPage(info: friends[index], username: widget.username,)));
                }

              },
            )
        );
      },
    );
  }
}