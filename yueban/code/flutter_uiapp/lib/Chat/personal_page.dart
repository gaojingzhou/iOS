import 'package:flutter/material.dart';
import 'dart:math';
import 'Info.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';

class PersonalPage extends StatefulWidget {
  PersonalPage({Key key, @required this.info, this.username}): super(key: key);
  final Info info;
  final String username;
  @override
  _PersonalPageState createState() => new _PersonalPageState();
}


class _PersonalPageState extends State<PersonalPage> {
  Dio dio = new Dio(); //第三方网络加载库

  void initState() {
    super.initState();
    _init();
  }


  var friend_count;

  _init() {
    _getFriendNum();

  }

  _getFriendNum() async{
    //String url = 'http://10.0.2.2:8081/friend_list?user_name=${widget.username}';
    String url = 'http://localhost:8081/friend_list?user_name=admin';
    var count = 0;
    try {
      var response = await dio.get(url);
      if (response.statusCode == HttpStatus.ok) {
        var data = response.data;
        count = data['friend_num'];
        print(count);
      } else {
        print('Error getting IP status ${response.statusCode}');
      }
    } catch (exception) {
      print(exception.toString());
    }
    if (!mounted) return;

    setState(() {
      friend_count = count;
    });


  }

  _addFriendPost() async{
    String url = 'http://localhost:8081/friend_list';
    int friendid;
    friendid = friend_count + 1;

    //以表单形式发送
    FormData frienddata = new FormData.from({
      //"user_name": widget.username,
      "user_name": "admin",
      "friend_name": widget.info.name,
      "sex": widget.info.sex,
      "img": widget.info.image_url,
      "friend_id": friendid.toString(),
    });
    print(frienddata);
    try{
      Response response = await dio.post(url, data: frienddata);
      print(response.data);
      setState(() {

        friendid = 0;
      });
    }catch(e){
      print("Connect Error: " + e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {

    return Material(
      child: CustomScrollView(
        slivers: <Widget>[
          //AppBar，包含一个导航栏
          SliverAppBar(
            pinned: true,
            floating: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add, color: Colors.black54, size: 30,),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('添加好友'),
                        content:Text('成功添加！'),
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

                  _addFriendPost();


                },
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.info.name, style: TextStyle(color: Colors.black, fontSize: 25),),
              background: Image.asset(
                "resources/1.jpg", fit: BoxFit.cover,),
              collapseMode: CollapseMode.pin,
              centerTitle: true,
            ),
          ),


          SliverPersistentHeader(
            floating: true,//floating 与pinned 不能同时为true
            pinned: false,
            delegate: _SliverAppBarDelegate(
                minHeight: 0.0,
                maxHeight: 300.0,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('resources/1.jpg'),
                    fit: BoxFit.cover
                  )
                ),
                child:  new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: new Row(
                        children: <Widget>[
                          new Container(
                            //head protrait
                            margin: const EdgeInsets.only(left: 14, right: 14, bottom: 14, top: 200),
                            height: 90.0,
                            width: 90.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(widget.info.image_url),

                              ),
                            ),
                          ),
                          Expanded(
                            child: Container (
                              margin: const EdgeInsets.only(top: 200, bottom: 14),
                              child: Column (
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: new Row(
                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        new Text(
                                          //user name
                                          widget.info.name,
                                          style: new TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 30.0,
                                            color: Color(0xffFFFAF0),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),

                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: <Widget>[
                                        new Container(
                                          margin: const EdgeInsets.only(top: 1, bottom: 5, right: 5),
                                          height: 20,
                                          width: 55,
                                          child: FlatButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            disabledColor: Color(0xff668B8B),

                                            child: new Text("电影", style: TextStyle(color: Colors.white, fontSize: 10),
                                            ),
                                          ),
                                        ),

                                        new Container(
                                          margin: const EdgeInsets.only(top: 1, bottom: 5, right: 5),
                                          height: 20,
                                          width: 55,
                                          child: FlatButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            disabledColor: Color(0xffB2DFEE),

                                            child: new Text("民谣", style: TextStyle(color: Colors.white, fontSize: 10),
                                            ),
                                          ),
                                        ),

                                        new Container(
                                          margin: const EdgeInsets.only(top: 1, bottom: 5, right: 5),
                                          height: 20,
                                          width: 55,
                                          child: FlatButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            disabledColor: Color(0xffCD5555),

                                            child: new Text("美食", style: TextStyle(color: Colors.white, fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ),
                                  //message data
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    )

                  ],
                ),
              )
            ),
          ),


          SliverToBoxAdapter(
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: OutlineButton.icon(
                    icon: Icon(Icons.check),
                    label: Text("已实名"),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: OutlineButton.icon(
                    icon: Icon(Icons.mood),
                    label: Text("信誉良好"),
                  ),
                ),
              ],
            )
          ),

          SliverToBoxAdapter(
            child: Text("ta的相册", style: TextStyle(color: Colors.black38, ), textAlign: TextAlign.start,),
          ),


          SliverPadding(
            padding: const EdgeInsets.all(0.0),
            sliver: new SliverGrid( //Grid
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 0.0,
                crossAxisSpacing: 0.0,
                childAspectRatio: 1.0,
              ),
              delegate: new SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  //创建子widget
                  return new Container(
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.only(bottom: 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('resources/b$index.jpg'),
                            fit: BoxFit.cover
                        )
                    ),
                  );
                },
                childCount: 6,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Text("ta的足迹", style: TextStyle(color: Colors.black38, ), textAlign: TextAlign.start,),
          ),

          //List
          new SliverFixedExtentList(
            itemExtent: 450.0,
            delegate: new SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  //创建列表项
                  return new Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 10.0, bottom: 10.0),
                    color: Colors.white,
                    borderOnForeground: false,
                    elevation: 1.0,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Row(

                          children: <Widget>[
                            new Container(
                              margin: const EdgeInsets.all(14),
                              height: 80.0,
                              width: 80.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(widget.info.image_url),

                                ),
                              ),
                            ),


                            Flexible (
                              child: Column (
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  new Row(
                                    //crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text(
                                        //user name
                                        widget.info.name,
                                        style: new TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20.0,
                                          color: Colors.black,
                                        ),
                                      ),


                                    ],
                                  ),

                                  Container(
                                    child:  new Text(
                                      '2019年12月01日',
                                      style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 13,
                                      ),
                                    ),
                                    margin: EdgeInsets.only(top: 5),
                                  )


                                ],
                              ),
                            ),

                            FlatButton.icon(
                              icon: Icon(Icons.location_on),
                              label: Text('冰岛'),
                              disabledColor: Colors.white,
                            ),


                          ],
                        ),

                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'Nice Place.',
                            style: TextStyle(color: Colors.black87, fontSize: 15),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 14),
                        ),

                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset('resources/b$index.jpg', fit: BoxFit.cover,),

                        ),

                        new Row(
                          //like and comment button
                          children: <Widget>[
                            IconButton(
                              icon: new Icon(
                                Icons.favorite_border,
                                color: Colors.black38,
                                size: 30,
                              ),
                              disabledColor: Colors.white70,
                            ),
                            IconButton(
                              icon: new Icon(
                                Icons.crop_3_2,
                                color: Colors.black38,
                                size: 30,
                              ),
                              disabledColor: Colors.white70,

                            )
                          ],
                        ),

                      ],
                    ),
                  );
                },
                childCount: 6//6个列表项
            ),
          ),
        ],
      ),
    );
  }
}



class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
