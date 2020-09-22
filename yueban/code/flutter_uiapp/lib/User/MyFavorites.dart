import 'package:flutter/material.dart';
import 'package:flutter_uiapp/Json/JsonModel.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class MyFavorites extends StatefulWidget {
  @override
  final String username;
  const MyFavorites({Key key, this.username}) : super(key: key);
  createState() => new MyFavoritesState();
}

class MyFavoritesState extends State<MyFavorites>{
  int itemCount = 0;
  List<ItemModel> data = [];
  ScrollController _scrollController;
  Dio dio = new Dio();
  List<Favorite> favList = [];

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    _getFavorite();
  }

  Widget _noContent(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,

      child: Center(
        child: Text("没有收藏哟~",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  Widget _pageBody(){

    if (itemCount > 0) {
      return new ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: data.length+1,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          if(index == data.length){
            if(data.length < favList.length-1 && data.length != 0){
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

  Future<Null> _getArticle(String articleid){
    final Completer<Null> completer = new Completer<Null>();
    fEach(articleid).then((list) {
      setState(() {
        data.addAll(list);
        itemCount = data.length;
      });
    }).catchError((error) {
      print(error);
    });
    completer.complete(null);
    return completer.future;
  }

  Future<List<ItemModel>> fEach(String articleid){
    return _getData(articleid);
  }

  Future<List<ItemModel>>  _getData(String articleid) async{
    List flModels;
    String url = 'http://localhost:8081/article?article_id=${articleid}';

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

  Future<Null> _getFavorite(){
    final Completer<Null> completer = new Completer<Null>();
    fEachFav().then((list) {
      setState(() {
        favList = list;
        for(int i = 0;i < list.length;i ++){
          _getArticle(list[i].articleId);
        }
      });
    }).catchError((error) {
      print(error);
    });
    completer.complete(null);
    return completer.future;
  }

  Future<List<Favorite>> fEachFav(){
    return _getFavData();
  }

  Future<List<Favorite>>  _getFavData() async{
    List flModels;
    String url = 'http://localhost:8081/favorite?user_name=${widget.username}';

    Response response = await dio.get(url);
    if((response.data)['message'] == "success"){//响应成功
      flModels = (response.data)['fav'];
    }else{
      print("Connect Error");
    }
    return flModels.map((model) {
      return new Favorite.fromJson(model);
    }).toList();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("我的收藏"),
        centerTitle: true,
      ),
      body: _pageBody(),
    );
  }
}

class UserCell extends StatefulWidget{
  final ItemModel celldata;
  final String username;
  UserCell({Key key, this.celldata, this.username}) : super(key: key);
  @override
  _UserCellState createState() => new _UserCellState();
}

class _UserCellState extends State<UserCell>{
  Dio dio = new Dio(); //第三方网络加载库
  int imgNum;
  List<ArticleImg> imgList;

  void initState() {
    super.initState();
    _getImgData();
  }

  //刷新时调用
  Future<Null> _getImgData(){
    final Completer<Null> completer = new Completer<Null>();
    fEach().then((list) {
      setState(() {
        imgList = list;
      });
    }).catchError((error) {
      print(error);
    });
    completer.complete(null);
    return completer.future;
  }

  Future<List<ArticleImg>> fEach(){
    return _getData();
  }

  Future<List<ArticleImg>>  _getData() async{
    List flModels;
    String url = 'http://localhost:8081/article/img?article_id=${widget.celldata.articleId}';

    Response response = await dio.get(url);
    if((response.data)['message'] == "success"){//响应成功
      flModels = (response.data)['imgs'] ;
      imgNum = (response.data)["img_num"];
    }else{
      print("Connect Error");
    }
    return flModels.map((model) {
      return new ArticleImg.fromJson(model);
    }).toList();
  }


  @override
  Widget build(BuildContext context){

    final String authorName = widget.celldata.authorName;
    double ImgSize = ((MediaQuery.of(context).size.width-50)/3);
    Container ImgContainer = Container(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: SizedBox(
                width: ImgSize,
                height: ImgSize,
                child: Image(image: AssetImage("resources/1.jpg"),)
            ),
          ),
        ],
      ),
    );
    if(imgList != null && imgNum != null){
      if(imgNum == 1){
        ImgContainer = Container(
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: ImgSize+80,
                  height: ImgSize+30,
                  child: Image.network(imgList[0].ImgUrl),
                ),
              ),
            ],
          ),
        );
      }
      else if (imgNum == 2){
        ImgContainer = Container(
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: ImgSize,
                  height: ImgSize,
                  child: Image.network(imgList[0].ImgUrl),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: ImgSize,
                  height: ImgSize,
                  child: Image.network(imgList[1].ImgUrl),
                ),
              ),
            ],
          ),
        );
      }
      else if(imgNum == 3){
        ImgContainer = Container(
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: ImgSize,
                  height: ImgSize,
                  child: Image.network(imgList[0].ImgUrl),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: ImgSize,
                  height: ImgSize,
                  child: Image.network(imgList[1].ImgUrl),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: ImgSize,
                  height: ImgSize,
                  child: Image.network(imgList[2].ImgUrl),
                ),
              ),
            ],
          ),
        );
      }
      else if(imgNum == 4){
        ImgContainer = Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10.0,top: 3.0),
                      child: SizedBox(
                        width: ImgSize,
                        height: ImgSize,
                        child: Image.network(imgList[0].ImgUrl),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0, top: 3.0),
                      child: SizedBox(
                        width: ImgSize,
                        height: ImgSize,
                        child: Image.network(imgList[1].ImgUrl),
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10.0,top: 3.0),
                      child: SizedBox(
                        width: ImgSize,
                        height: ImgSize,
                        child: Image.network(imgList[2].ImgUrl),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0, top: 3.0),
                      child: SizedBox(
                        width: ImgSize,
                        height: ImgSize,
                        child: Image.network(imgList[3].ImgUrl),
                      ),
                    ),

                  ],
                ),
              )
            ],
          ),
        );
      }
    }

    return Container(
        padding: EdgeInsets.all(10.0),
        child: Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: <Widget>[
            GestureDetector(
              onTap: (){
                /*Navigator.push(context, MaterialPageRoute(builder:
                    (context) => PersonalPage(info: ,)));*/
              },
              child: Container(
                height: 45.0,
                width: 45.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new AssetImage(
                          "resources/dog.jpeg")
                  ),
                ),
              ),
            ),

            Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width-100,
              alignment: Alignment.centerLeft,//左中心对齐
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: new Text(authorName, style: new TextStyle(fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),textAlign: TextAlign.left,),
                  )
                ],
              ),
            ),
            ImgContainer,
            Padding(
              child: Text(widget.celldata.content, style: TextStyle(color: Colors.black,fontSize: 18)),
              padding: EdgeInsets.only(left: 10.0),
            )
          ],
        )
    );
  }
}