import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_uiapp/Json/JsonModel.dart';
import 'package:flutter_uiapp/User/LoginPage.dart';
import 'dart:async';
import 'package:flutter_uiapp/Comment/CommentPage.dart';
import 'dart:io';

class FeedPage extends StatefulWidget{
  FeedPage({Key key, this.username}) : super(key: key);
  final String username;
  @override
  State<StatefulWidget> createState() {
    return new FeedPageState(
      username: username
    );
  }
}

class FeedPageState extends State<FeedPage> {
  FeedPageState({Key key, this.username});
  final String username;
  List<ItemModel> datatmp = [];
  List<ItemModel> data = []; //初始化列表数据源
  int offset = 0;
  int totalData = 0;
  bool isEnd = false;
  ScrollController _scrollController;
  Dio dio = new Dio(); //第三方网络加载库

//页面初始化时加载数据并实例化ScrollController
  @override
  void initState() {
    super.initState();
    offset = 0;
    isEnd = false;
    totalData = 0;
    _refreshData();

    _scrollController = new ScrollController();
    //滑到底加载
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if(mounted){
          setState(() {
            _refreshData();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var content;
    if (data.isEmpty) {
      content = new Center(child: new CircularProgressIndicator());
    }
    else {
      content = new ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: data.length+1,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          if(index == data.length){
            if(data.length < totalData && data.length != 0){
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
              if(data.length >= totalData)
                isEnd = true;
              return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16.0),
                  child: Text("没有动态啦～", style: TextStyle(color: Colors.grey),)
              );
            }
          }
          return BuildCell(celldata: data[index], username: username,);
        },
      );
    }
    var _refreshIndicator = new RefreshIndicator(
      onRefresh: _refreshData,
      child: content,
    );
    return _refreshIndicator;
  }

  //刷新时调用
  Future<Null> _refreshData(){
    final Completer<Null> completer = new Completer<Null>();
    fEach().then((list) {
      setState(() {
        datatmp = list;
        if(isEnd == false)
          data.addAll(datatmp);

        if(offset + 10 < totalData){
          offset += 10;
        }
        else
          offset = totalData;//设置为最大文章数
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
    String url = 'http://localhost:8081/article?offset=${offset}';

    Response response = await dio.get(url);
    if((response.data)['message'] == "success"){//响应成功
      flModels = (response.data)['items'];
      totalData = (response.data)['article_num'];
      //print(response.data);
    }else{
      print("Connect Error");
    }
    return flModels.map((model) {
      return new ItemModel.fromJson(model);
    }).toList();
  }
}

class BuildCell extends StatefulWidget{
  final ItemModel celldata;
  final String username;
  BuildCell({Key key, this.celldata, this.username}) : super(key: key);
  @override
  _BuildCellState createState() => new _BuildCellState();
}

class _BuildCellState extends State<BuildCell>{
  bool isLike = false;
  bool isfav = false;
  int likeCnt;
  int commentCnt;
  Dio dio = new Dio(); //第三方网络加载库
  int imgNum;
  List<ArticleImg> imgList;
  String imgurl = "";
  //记录选择的照片
  File _image;

  void initState() {
    super.initState();
    _getImgData();
    _getLikeDetail();
    _getFavorite();
    _getCommentNum();
    _getUserHeadImg();
  }

  _getUserHeadImg() async{
    String url = 'http://localhost:8081/userInfo?user_name=${widget.celldata.authorName}';
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

  _getCommentNum() async{
    //获取直接回复帖子的评论数
    String url = 'http://localhost:8081/comment_num?article_id=${widget.celldata.articleId}&reply_id=0';
    await dio.get(url).then((response){
      if(mounted){
        setState(() {
          if((response.data)['message'] == "success"){//响应成功
            commentCnt = (response.data)["comment_num"];
          }else{
            print("Connect Error");
          }
        });
      }

    });
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


  _getLikeDetail() async{
    String url = 'http://localhost:8081/like?user_name=${widget.username}&article_id=${widget.celldata.articleId}';
    await dio.get(url).then((response){
      if(mounted){
        setState(() {
          if((response.data)['message'] == "success"){//响应成功
            isLike = (response.data)["is_like"];
            likeCnt = (response.data)["like_num"];
          }else{
            print("Connect Error");
          }
        });
      }

    });
  }

  _getFavorite() async{
    String url = 'http://localhost:8081/favorite?user_name=${widget.username}&article_id=${widget.celldata.articleId}';
    await dio.get(url).then((response){
      if(mounted){
        setState(() {
          if((response.data)['message'] == "success"){//响应成功
            isfav = (response.data)["is_favorite"];
          }else{
            print("Connect Error");
          }
        });
      }

    });
  }

  _likePost() async{
    String url = 'http://localhost:8081/like';
    //以表单形式发送
    FormData likedata = new FormData.from({
      "username": widget.username,
      "articleid": widget.celldata.articleId,
    });

    try{
      Response response = await dio.post(url, data: likedata);
    }catch(e){
      print("Connect Error: " + e.toString());
    }
  }

  _favoritePost() async{
    String url = 'http://localhost:8081/favorite';
    //以表单形式发送
    FormData favdata = new FormData.from({
      "username": widget.username,
      "articleid": widget.celldata.articleId,
    });

    try{
      Response response = await dio.post(url, data: favdata);
    }catch(e){
      print("Connect Error: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context){
    Container headContainer;
    if(_image == null || FileImage(_image) == null){
      headContainer = Container(
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
      );
    }
    else{
      headContainer = Container(
        height: 45.0,
        width: 45.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
              fit: BoxFit.fill,
              image: FileImage(_image)
          ),
        ),
      );
    }

    final String authorName = widget.celldata.authorName;
    IconButton love;
    if(isLike){
      love = IconButton(icon: Icon(Icons.favorite,color: Colors.red,),
          onPressed: (){
            if(widget.username == null || widget.username == ""){
              showDialog(context: context, builder: (_) => _generateAlertDialog("请先登录"));
            }
            else{
              _likePost();
              if(mounted){
                setState(() {
                  likeCnt--;
                  isLike = !isLike;
                });
              }

            }
          }, iconSize: 30.0,
          disabledColor: Colors.red);
    }
    else{
      love = IconButton(icon: Icon(Icons.favorite_border),
          onPressed: (){
            if(widget.username == null || widget.username == ""){
              showDialog(context: context, builder: (_) => _generateAlertDialog("请先登录"));
            }
            else{
              _likePost();
              if(mounted){
                setState(() {
                  likeCnt++;
                  isLike = !isLike;
                });
              }
            }

          }, iconSize: 30.0,
          disabledColor: Colors.black);
    }

    IconButton fav;
    if(isfav){
      fav = IconButton(icon: Icon(Icons.star,color: Colors.yellow,),
          onPressed: (){
            if(widget.username == null || widget.username == ""){
              showDialog(context: context, builder: (_) => _generateAlertDialog("请先登录"));
            }
            else{
              _favoritePost();
              if(mounted){
                setState(() {
                  isfav = !isfav;
                });
              }

            }
          }, iconSize: 30.0,
          disabledColor: Colors.yellowAccent);
    }
    else{
      fav = IconButton(icon: Icon(Icons.star_border),
          onPressed: (){
            if(widget.username == null || widget.username == ""){
              showDialog(context: context, builder: (_) => _generateAlertDialog("请先登录"));
            }
            else{
              _favoritePost();
              if(mounted){
                setState(() {
                  isfav = !isfav;
                });
              }

            }

          }, iconSize: 30.0,
          disabledColor: Colors.black);
    }
    //print(imgNum);
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
                  child: imgList[0].ImgUrl[0]=='/'?Image.file(File(imgList[0].ImgUrl)):Image.network(imgList[0].ImgUrl),
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
                  child: imgList[0].ImgUrl[0]=='/'?Image.file(File(imgList[0].ImgUrl)):Image.network(imgList[0].ImgUrl),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: ImgSize,
                  height: ImgSize,
                  child: imgList[1].ImgUrl[0]=='/'?Image.file(File(imgList[1].ImgUrl)):Image.network(imgList[1].ImgUrl),
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
                  child: imgList[0].ImgUrl[0]=='/'?Image.file(File(imgList[0].ImgUrl)):Image.network(imgList[0].ImgUrl),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: ImgSize,
                  height: ImgSize,
                  child: imgList[1].ImgUrl[0]=='/'?Image.file(File(imgList[1].ImgUrl)):Image.network(imgList[1].ImgUrl),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: ImgSize,
                  height: ImgSize,
                  child: imgList[2].ImgUrl[0]=='/'?Image.file(File(imgList[2].ImgUrl)):Image.network(imgList[2].ImgUrl),
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
                        child: imgList[0].ImgUrl[0]=='/'?Image.file(File(imgList[0].ImgUrl)):Image.network(imgList[0].ImgUrl),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0, top: 3.0),
                      child: SizedBox(
                        width: ImgSize,
                        height: ImgSize,
                        child: imgList[1].ImgUrl[0]=='/'?Image.file(File(imgList[1].ImgUrl)):Image.network(imgList[1].ImgUrl),
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
                        child: imgList[2].ImgUrl[0]=='/'?Image.file(File(imgList[2].ImgUrl)):Image.network(imgList[2].ImgUrl),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0, top: 3.0),
                      child: SizedBox(
                        width: ImgSize,
                        height: ImgSize,
                        child: imgList[3].ImgUrl[0]=='/'?Image.file(File(imgList[3].ImgUrl)):Image.network(imgList[3].ImgUrl),
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
              },
              child: headContainer
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
            ),

            Container(
              height: 40.0,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Container(
                    height: 40.0,
                    width: MediaQuery.of(context).size.width-100,
                    child: Row(
                      children: <Widget>[
                        love,
                        Text(likeCnt.toString(), style: TextStyle(color: Colors.black,fontSize: 18)),
                        IconButton(icon: Icon(Icons.chat_bubble_outline),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder:
                                (context) => CommentPage(username: widget.username,celldata: widget.celldata,commentCnt: commentCnt,imgList: imgList,imgNum: imgNum,)));
                          }, iconSize: 30.0,
                          disabledColor: Colors.black,),
                        Text(commentCnt.toString(), style: TextStyle(color: Colors.black,fontSize: 18)),
                      ],
                    ),
                  ),
                  Container(
                    height: 40.0,
                    width: 80.0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: fav,
                    )
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}
