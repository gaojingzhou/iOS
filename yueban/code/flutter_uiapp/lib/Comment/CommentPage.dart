import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_uiapp/Json/JsonModel.dart';
import 'package:flutter_uiapp/User/LoginPage.dart';
import 'dart:async';
import 'package:flutter_uiapp/main.dart';

class CommentPage extends StatefulWidget{
  CommentPage({Key key, this.username,this.celldata,this.commentCnt,this.imgNum,this.imgList}) : super(key: key);

  final String username;
  final ItemModel celldata;
  int commentCnt;
  int imgNum;
  List<ArticleImg> imgList;
  @override
  _CommentPageState createState() => new _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  String myComment;
  String replyUser = "";
  int replyId = 0;//默认评论原帖
  bool isEnd = false;
  List<CommentModel> data = []; //初始化列表数据源
  List<CommentModel> alldata = [];

  Map<int,List<CommentModel>> subData = new Map();//每个ReplyId对应的回复

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _commentController = new TextEditingController();
  ScrollController _scrollController;
  Dio dio = new Dio(); //第三方网络加载库
  String hitText = "写回复...";



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

  //刷新时调用
  Future<Null> _refreshData(int replyid){
    final Completer<Null> completer = new Completer<Null>();
    fEach(replyid).then((list) {
      setState(() {
        data = list;
        if(data != null){
          if(replyid == 0 && isEnd == false) {
            alldata.addAll(data);
          }
          else {
            subData[replyid] = data; //直接获取该评论的所有子数据
          }
        }
      });
    }).catchError((error) {
      print(error);
    });
    completer.complete(null);
    return completer.future;
  }

  Future<List<CommentModel>> fEach(int replyid){
    return _getData(replyid);
  }

  Future<List<CommentModel>>  _getData(int replyid) async{
    List flModels;
    String url = 'http://localhost:8081/comment?article_id=${widget.celldata.articleId}&reply_id=${replyid}';

    Response response = await dio.get(url);
    if((response.data)['message'] == "success"){//响应成功
      flModels = (response.data)['comments'];
    }else{
      print("Connect Error");
    }
    return flModels.map((model) {
      return new CommentModel.fromJson(model);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _refreshData(0);//加载初始回复数据
      //加载子评论
      for(int i = 0;i < widget.commentCnt;i ++){
        _refreshData(i+1);
      }
      isEnd = false;
    });
    _scrollController = new ScrollController();
    //滑到底加载
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        setState(() {
          _refreshData(0);
          for(int i = 0;i < alldata.length;i ++){
            _refreshData(alldata[i].commentId);
          }
        });
      }
    });
  }


  //主页评论的replyid为0,level也为0
  _commentPost() async{
    String url = 'http://localhost:8081/comment';
    int cmdid;
    if(replyId == 0)
      cmdid = widget.commentCnt+1;
    else
      cmdid = replyId;
    //以表单形式发送
    FormData commentdata = new FormData.from({
      "articleid": widget.celldata.articleId.toString(),
      "username": widget.username,
      "comment": myComment,
      "replyuser": replyUser,
      "commentid": cmdid,
      "replyid": replyId
    });
    try{
      Response response = await dio.post(url, data: commentdata);
      setState(() {
        if(replyId == 0) {
          widget.commentCnt++;
          alldata.add(CommentModel(widget.celldata.articleId.toString(),widget.username,myComment,replyUser,cmdid,replyId));
          _refreshData(0);
        }
        else{
          _refreshData(replyId);//刷新该评论的回复数据
        }
        replyId = 0;
        replyUser = "";
        hitText = "写回复...";
      });
    }catch(e){
      print("Connect Error: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context){
    final String authorName = widget.celldata.authorName;
    final String content = widget.celldata.content;
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
    if(widget.imgList != null && widget.imgNum != null){
      if(widget.imgNum == 1){
        ImgContainer = Container(
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: ImgSize+80,
                  height: ImgSize+30,
                  child: Image.network(widget.imgList[0].ImgUrl),
                ),
              ),
            ],
          ),
        );
      }
      else if (widget.imgNum == 2){
        ImgContainer = Container(
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: ImgSize,
                  height: ImgSize,
                  child: Image.network(widget.imgList[0].ImgUrl),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: ImgSize,
                  height: ImgSize,
                  child: Image.network(widget.imgList[1].ImgUrl),
                ),
              ),
            ],
          ),
        );
      }
      else if(widget.imgNum == 3){
        ImgContainer = Container(
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: ImgSize,
                  height: ImgSize,
                  child: Image.network(widget.imgList[0].ImgUrl),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: ImgSize,
                  height: ImgSize,
                  child: Image.network(widget.imgList[1].ImgUrl),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: ImgSize,
                  height: ImgSize,
                  child: Image.network(widget.imgList[2].ImgUrl),
                ),
              ),
            ],
          ),
        );
      }
      else if(widget.imgNum == 4){
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
                        child: Image.network(widget.imgList[0].ImgUrl),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0, top: 3.0),
                      child: SizedBox(
                        width: ImgSize,
                        height: ImgSize,
                        child: Image.network(widget.imgList[1].ImgUrl),
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
                        child: Image.network(widget.imgList[2].ImgUrl),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0, top: 3.0),
                      child: SizedBox(
                        width: ImgSize,
                        height: ImgSize,
                        child: Image.network(widget.imgList[3].ImgUrl),
                      ),
                    ),

                  ],
                ),
              )
            ],
          ),
        );
        ImgSize *= 2;//防止溢出
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
        iconSize: 30.0,
        onPressed: (){
            //重新加载主界面
          Navigator.push(context, MaterialPageRoute(builder:
              (context) => MyHomePage(
            username: widget.username,
          ))
          );
        },
        padding: const EdgeInsets.only(left: 12.0),
        disabledColor: Colors.black),
        title: new Text("评论",
            style: new TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,//设置成屏幕宽度和高度
        child: Stack(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 15.0),
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 15.0),
                    child: Container(
                      child: Wrap(
                        children: <Widget>[
                          Container(
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

                          Container(
                            padding: EdgeInsets.only(left: 10.0),
                            height: 50.0,
                            width: MediaQuery.of(context).size.width-100,
                            alignment: Alignment.centerLeft,//左中心对齐
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(top: 10.0),),
                                new Text(authorName, style: new TextStyle(fontSize: 20.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),textAlign: TextAlign.left,),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15.0,top: 5.0),
                            child: Text(content, style: new TextStyle(fontSize: 18.0,
                                color: Colors.black),
                            ),
                          ),
                          ImgContainer,
                        ],
                      ),
                    ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 5.0,left: 15.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height-280-ImgSize,
                        child: _commentList(),
                      ),
                    )
                  ],
                ),
            ),

            Positioned(
              left: 15.0,
              bottom: 20.0,
              height: 50.0,
              child: Wrap(
                spacing: 10.0,
                children: <Widget>[
                  Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new AssetImage(
                              "resources/dog.jpeg")),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child:
                      Container(
                        height: 40.0,
                        width: MediaQuery.of(context).size.width-160,
                        alignment: Alignment.centerLeft,//左中心对齐
                        child: Form(
                          key: _formKey,
                          child: new TextFormField(decoration: InputDecoration(
                            hintText: hitText,//提示词
                            border: InputBorder.none,//删去下划线
                          ), style: new TextStyle(fontSize: 22.0),
                            onSaved: (String value){
                              myComment = value;//保存当前评论
                            },
                            controller: _commentController,
                          ),
                        )
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: GestureDetector(
                      child: Text(
                        "发布",
                        style: TextStyle(fontSize: 22.0, color: Color(0xFF1296db)),
                      ),
                      onTap: () {
                        _formKey.currentState.save();//赋值
                        if(widget.username == null || widget.username == ""){
                          showDialog(context: context, builder: (_) => _generateAlertDialog("请先登录"));
                        }
                        else if(myComment != null && myComment != ""){
                          _commentPost();
                          WidgetsBinding.instance.addPostFrameCallback((_) => _commentController.clear());
                        }
                      }
                    ),
                  )
                ],
              )
            )
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _commentList(){
    if(widget.commentCnt == 0 || widget.commentCnt == null){
      return Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: Text(
          '--- 没有评论了～ ---',
          style: TextStyle(fontSize: 20.0,color: Colors.black,fontWeight: FontWeight.w600),
        ),
      );
    }
    else{
      return ListView.separated(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: alldata.length+1,
        controller: _scrollController,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          if(index == alldata.length){
            if(alldata.length < widget.commentCnt && alldata.length != 0){
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
              if(alldata.length >= widget.commentCnt)
                isEnd = true;
              return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16.0),
                  child: Text("--- 没有评论了～ ---", style: TextStyle(color: Colors.grey),)
              );
            }
          }
          return _commentCell(alldata[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(color: Colors.grey,indent: 3.0);
        },
      );
    }
  }

  Widget _commentCell(CommentModel data){
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            replyUser = data.username;
            hitText = '@' + data.username;
            replyId = data.commentId;
          });
        },
        child: Wrap(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 30.0,
                      width: 30.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new AssetImage("resources/dog.jpeg")
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child:  new Text(data.username, style: new TextStyle(fontSize: 20.0,
                          color: Colors.black, fontWeight: FontWeight.w600),textAlign: TextAlign.left,),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 40.0),
                child: new Text(data.comment, style: new TextStyle(fontSize: 18.0,
                    color: Colors.black),textAlign: TextAlign.left, softWrap: true,),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: referComment(subData[data.commentId], data),
              )
            ]
        ),
      )

    );
  }


  Widget referComment(List<CommentModel> refData, CommentModel data){
    if(refData == null || refData.length == 0)
      return null;
    if(refData.length <= 3){
      return commentsListView(refData);
    }
    else{
      List<CommentModel>tmpdata = [];
      tmpdata.add(refData[0]);
      tmpdata.add(refData[1]);
      tmpdata.add(refData[2]);
      return Container(
        child: Column(
          children: <Widget>[
            commentsListView(tmpdata),
            GestureDetector(
              child: Text("查看全部" + refData.length.toString() + "条评论",
                  style: TextStyle(color: Colors.green,fontSize: 20.0,fontWeight: FontWeight.w600)),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:
                    (context) => AllComments(username: widget.username,refData: refData, data: data,)));
              },
            )
          ],
        ),
      );
    }
  }

  Widget commentsListView(List<CommentModel> refData){
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),//不可滚动
      itemCount: refData.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            padding: EdgeInsets.fromLTRB(60.0, 5.0, 10.0, 5.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  hitText = '@' + refData[index].username;
                  replyUser = refData[index].username;
                  replyId = refData[index].commentId;
                });
              },
              child: Wrap(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 30.0,
                            width: 30.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new AssetImage("resources/dog.jpeg")
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child:  new Text(refData[index].username, style: new TextStyle(fontSize: 20.0,
                                color: Colors.black, fontWeight: FontWeight.w600),textAlign: TextAlign.left,),
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 40.0),
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              children: [
                                TextSpan(text: "@"+refData[index].replyUser + "  ",style: TextStyle(color: Colors.green,fontSize: 20.0,fontWeight: FontWeight.w600)),
                                TextSpan(text: refData[index].comment, style: new TextStyle(fontSize: 18.0,
                                    color: Colors.black),)
                              ]
                          ),
                        )
                    ),
                  ]
              ),
            )

        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(color: Colors.grey,indent: 3.0);
      },
    );
  }

}


class AllComments extends StatefulWidget{
  AllComments({Key key, this.username,this.refData,this.data}) : super(key: key);

  final String username;
  List<CommentModel> refData;
  final CommentModel data;
  @override
  _AllCommentsState createState() => new _AllCommentsState();
}

class _AllCommentsState extends State<AllComments> {
  String myComment;
  String replyUser;
  int replyId; //默认评论原帖

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _commentController = new TextEditingController();
  ScrollController _scrollController;
  Dio dio = new Dio(); //第三方网络加载库
  String hitText = "写评论...";

  @override
  void initState() {
    super.initState();
    replyId = widget.data.commentId;//默认是跟随原评论
    replyUser = widget.data.username;
    _scrollController = new ScrollController();
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
  _commentPost() async{
    String url = 'http://localhost:8081/comment';
    int cmdid;
    cmdid = replyId;
    //以表单形式发送
    FormData commentdata = new FormData.from({
      "articleid": widget.data.articleId.toString(),
      "username": widget.username,
      "comment": myComment,
      "replyuser": replyUser,
      "commentid": cmdid,
      "replyid": replyId
    });
    try{
      Response response = await dio.post(url, data: commentdata);
      setState(() {
        _refreshData(replyId);//刷新该评论的回复数据
        replyId = widget.data.commentId;
        replyUser = widget.data.username;
        hitText = "写评论...";
      });
    }catch(e){
      print("Connect Error: " + e.toString());
    }
  }

  //刷新时调用
  Future<Null> _refreshData(int replyid){
    final Completer<Null> completer = new Completer<Null>();
    fEach(replyid).then((list) {
      setState(() {
        widget.refData = list;
      });
    }).catchError((error) {
      print(error);
    });
    completer.complete(null);
    return completer.future;
  }

  Future<List<CommentModel>> fEach(int replyid){
    return _getData(replyid);
  }

  Future<List<CommentModel>>  _getData(int replyid) async{
    List flModels;
    String url = 'http://localhost:8081/comment?article_id=${widget.data.articleId}&offset=0&reply_id=${replyid}';

    Response response = await dio.get(url);
    if((response.data)['message'] == "success"){//响应成功
      flModels = (response.data)['comments'];
    }else{
      print("Connect Error");
    }
    return flModels.map((model) {
      return new CommentModel.fromJson(model);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("评论",
            style: new TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,//设置成屏幕宽度和高度
        child: Stack(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 10.0,left: 15.0),
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height-200,
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              replyUser = widget.data.username;
                              hitText = '@' + widget.data.username;
                              replyId = widget.data.commentId;
                            });
                          },
                          child: Wrap(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        height: 30.0,
                                        width: 30.0,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: new AssetImage("resources/dog.jpeg")
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child:  new Text(widget.data.username, style: new TextStyle(fontSize: 20.0,
                                            color: Colors.black, fontWeight: FontWeight.w600),textAlign: TextAlign.left,),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0, left: 40.0),
                                  child: new Text(widget.data.comment, style: new TextStyle(fontSize: 18.0,
                                      color: Colors.black),textAlign: TextAlign.left, softWrap: true,),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: commentsListView(widget.refData),
                                )
                              ]
                          ),
                        )
                    ),
                  ),
                )
            ),

            Positioned(
                left: 15.0,
                bottom: 20.0,
                height: 50.0,
                child: Wrap(
                  spacing: 10.0,
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new AssetImage(
                                "resources/dog.jpeg")),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 2.0),
                        child:
                        Container(
                            height: 40.0,
                            width: MediaQuery.of(context).size.width-160,
                            alignment: Alignment.centerLeft,//左中心对齐
                            child: Form(
                              key: _formKey,
                              child: new TextFormField(decoration: InputDecoration(
                                hintText: hitText,//提示词
                                border: InputBorder.none,//删去下划线
                              ), style: new TextStyle(fontSize: 22.0),
                                onSaved: (String value){
                                  myComment = value;//保存当前评论
                                },
                                controller: _commentController,
                              ),
                            )
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: GestureDetector(
                          child: Text(
                            "Post",
                            style: TextStyle(fontSize: 22.0, color: Color(0xFF1296db)),
                          ),
                          onTap: () {
                            _formKey.currentState.save();//赋值
                            if(widget.username == null || widget.username == ""){
                              showDialog(context: context, builder: (_) => _generateAlertDialog("Please login first"));
                            }
                            else if(myComment != null && myComment != ""){
                              _commentPost();
                              WidgetsBinding.instance.addPostFrameCallback((_) => _commentController.clear());
                            }
                          }
                      ),
                    )
                  ],
                )
            )
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget commentsListView(List<CommentModel> refData){
    return ListView.separated(
      shrinkWrap: true,
      controller: _scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: refData.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            padding: EdgeInsets.fromLTRB(60.0, 5.0, 10.0, 5.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  hitText = '@' + refData[index].username;
                  replyUser = refData[index].username;
                  replyId = refData[index].commentId;
                });
              },
              child: Wrap(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 30.0,
                            width: 30.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new AssetImage("resources/dog.jpeg")
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child:  new Text(refData[index].username, style: new TextStyle(fontSize: 20.0,
                                color: Colors.black, fontWeight: FontWeight.w600),textAlign: TextAlign.left,),
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10.0, left: 40.0),
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                              children: [
                                TextSpan(text: "@"+refData[index].replyUser + "  ",style: TextStyle(color: Colors.green,fontSize: 20.0,fontWeight: FontWeight.w600)),
                                TextSpan(text: refData[index].comment, style: new TextStyle(fontSize: 18.0,
                                    color: Colors.black),)
                              ]
                          ),
                        )
                    ),
                  ]
              ),
            )
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(color: Colors.grey,indent: 3.0);
      },
    );
  }
}