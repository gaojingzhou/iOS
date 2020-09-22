import 'package:flutter/material.dart';
import 'package:flutter_uiapp/Json/JsonModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter_uiapp/User/MyFavorites.dart';
import 'dart:async';

class MyPublished extends StatefulWidget {
  @override
  final String username;
  const MyPublished({Key key, this.username}) : super(key: key);
  createState() => new MyPublishedState();
}

class MyPublishedState extends State<MyPublished> with SingleTickerProviderStateMixin{
  TabController _tabController;
  int itemCount = 0;
  List<ItemModel> data = [];
  ScrollController _scrollController;
  Dio dio = new Dio();

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    _tabController = TabController(length: 2, vsync: this);
    _getPublishArticle();
  }

  Future<Null> _getPublishArticle(){
    final Completer<Null> completer = new Completer<Null>();
    fEach().then((list) {
      setState(() {
        data = list;
        itemCount = data.length;
      });
    }).catchError((error) {
      print(error);
    });
    completer.complete(null);
    return completer.future;
  }

  Future<List<ItemModel>> fEach(){
    return _getData();
  }

  Future<List<ItemModel>>  _getData() async{
    List flModels;
    String url = 'http://localhost:8081/article?user_name=${widget.username}';

    Response response = await dio.get(url);
    if((response.data)['message'] == "success"){//响应成功
      flModels = (response.data)['items'];
    }else{
      print("Connect Error");
    }
    return flModels.map((model) {
      return new ItemModel.fromJson(model);
    }).toList();
  }

  Widget _cell(String partialContent){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.all(10.0),
      child: Wrap(
        children: <Widget>[
          Container(
            width: 50.0,
            height: 50.0,
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("resources/dog.jpeg"),
              ),
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width - 100.0,
            height: 50.0,
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            alignment: Alignment.topLeft,
            child: Text("用户AAA",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width - 40.0,
            height: 50.0,
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
            alignment: Alignment.centerLeft,
            child: Text(partialContent,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //没有发布信息时的界面
  Widget _noContent(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,

      child: Center(
        child: Text("还未发布内容哟~",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  //发布信息的动态界面
  Widget _dynamicPage() {
    if (itemCount > 0) {
      return new ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: data.length+1,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          if(index == data.length){
            if(data.length < itemCount && data.length != 0){
              return Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(strokeWidth: 2.0)
                ),
              );
            }
            else{
              return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16.0),
                  child: Text("没有更多啦～", style: TextStyle(color: Colors.grey),)
              );
            }
          }
          return UserCell(celldata: data[index], username: widget.username,);
        },
      );
    }
    else {
      return _noContent();
    }
  }

  Widget _partnerPage(){
    int itemCount = 6;
    String partialContent = "震惊！爷爷的儿子居然是我的爸爸！";

    if (itemCount > 0) {
      return ListView.builder(
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          return _cell(partialContent);
        },
      );
    }
    else {
      return _noContent();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的发布"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: "动态"),
            Tab(text: "约伴"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _dynamicPage(),
          _partnerPage(),
        ],
      ),
    );
  }
}