import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_uiapp/main.dart';



class ArticlePostPage extends StatefulWidget {
  @override
  final String username;
  const ArticlePostPage({Key key, this.username}) : super(key: key);
  createState() => new ArticlePostPageState();
}

class ArticlePostPageState extends State<ArticlePostPage>{
  Dio dio = new Dio(); //第三方网络加载库
  //记录选择的照片
  List<File> images = [];
  String content = "";
  int articleNum = 0;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _commentController = new TextEditingController();
  String hitText = "这一刻的想法...";

  void initState() {
    super.initState();
    _getArticleNum();
  }
  //相册选择
  Future _getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      images.add(image);
    });
  }

  _ArticlePost() async{
    String url = 'http://localhost:8081/article';
    //以表单形式发送
    FormData data = new FormData.from({
      "articleid": (articleNum.toInt()+1).toString(),
      "authorname":widget.username,
      "content":content
    });
    try{
      Response response = await dio.post(url, data: data);
    }catch(e){
      print("Connect Error: " + e.toString());
    }
  }

  _ArticleImgPost(File file) async{
    String url = 'http://localhost:8081/article/img';
    //以表单形式发送
    FormData data = new FormData.from({
      "username":widget.username,
      "articleid": (articleNum.toInt()+1).toString(),
      "imgurl":file.path
    });
    try{
      Response response = await dio.post(url, data: data);
    }catch(e){
      print("Connect Error: " + e.toString());
    }
  }

  _getArticleNum() async{
    String url = 'http://localhost:8081/article';
    await dio.get(url).then((response){
      if(mounted){
        setState(() {
          if((response.data)['message'] == "success"){//响应成功
            articleNum = (response.data)["article_num"];
            print(articleNum);
          }else{
            print("Connect Error");
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double ImgSize = ((MediaQuery
        .of(context)
        .size
        .width - 50) / 3);
    Container ImgContainer = Container(
      child: Row(
        children: <Widget>[
          GestureDetector(child:
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: SizedBox(
                  width: ImgSize,
                  height: ImgSize,
                  child: Image(image: AssetImage("resources/add.png"),)
              ),
            ),
            onTap: _getImageFromGallery,
          )

        ],
      ),
    );
    if (images != null) {
      if (images.length == 0) {
        ImgContainer = Container(
          child: Row(
            children: <Widget>[
              GestureDetector(child:
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                    width: ImgSize,
                    height: ImgSize,
                    child: Image(image: AssetImage("resources/add.png"),)
                ),
              ),
                onTap: _getImageFromGallery,
              )
            ],
          ),
        );
      }
      else if (images.length == 1) {
        ImgContainer = Container(
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: ImgSize,
                  height: ImgSize,
                  child: Image.file(images[0]),
                ),
              ),
              GestureDetector(child:
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                    width: ImgSize,
                    height: ImgSize,
                    child: Image(image: AssetImage("resources/add.png"),)
                ),
              ),
                onTap: _getImageFromGallery,
              )
            ],
          ),
        );
      }
      else if (images.length == 2) {
        ImgContainer = Container(
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: ImgSize,
                  height: ImgSize,
                  child: Image.file(images[0]),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                  width: ImgSize,
                  height: ImgSize,
                  child: Image.file(images[1]),
                ),
              ),
              GestureDetector(child:
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: SizedBox(
                    width: ImgSize,
                    height: ImgSize,
                    child: Image(image: AssetImage("resources/add.png"),)
                ),
              ),
                onTap: _getImageFromGallery,
              )
            ],
          ),
        );
      }
      else if (images.length == 3) {
        ImgContainer = Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 3.0),
                      child: SizedBox(
                        width: ImgSize,
                        height: ImgSize,
                        child: Image.file(images[0]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0, top: 3.0),
                      child: SizedBox(
                        width: ImgSize,
                        height: ImgSize,
                        child: Image.file(images[1]),
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 3.0),
                      child: SizedBox(
                        width: ImgSize,
                        height: ImgSize,
                        child: Image.file(images[2]),
                      ),
                    ),
                    GestureDetector(child:
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: SizedBox(
                            width: ImgSize,
                            height: ImgSize,
                            child: Image(image: AssetImage("resources/add.png"),)
                        ),
                      ),
                        onTap: _getImageFromGallery,
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }
      else if (images.length == 4) {
        ImgContainer = Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 3.0),
                      child: SizedBox(
                        width: ImgSize,
                        height: ImgSize,
                        child: Image.file(images[0]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0, top: 3.0),
                      child: SizedBox(
                        width: ImgSize,
                        height: ImgSize,
                        child: Image.file(images[1]),
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 3.0),
                      child: SizedBox(
                        width: ImgSize,
                        height: ImgSize,
                        child: Image.file(images[2]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0, top: 3.0),
                      child: SizedBox(
                        width: ImgSize,
                        height: ImgSize,
                        child: Image.file(images[3]),
                      ),
                    ),

                  ],
                ),
              )
            ],
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          title: Text("发布动态"),
          centerTitle: true,
          actions: <Widget>[
            Padding(padding: EdgeInsets.only(top: 10.0, right: 10.0),
              child: GestureDetector(
                  child: Text(
                    "发表",
                    style: TextStyle(fontSize: 20.0, color: Color(0xFF1296db)),
                  ),
                  onTap: () {
                    _formKey.currentState.save(); //赋值
                    _ArticlePost();
                    for (int i = 0; i < images.length; i ++) {
                      _ArticleImgPost(images[i]);
                    }
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => MyHomePage(username: widget.username,)));
                  }
              ),
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 2.0, left: 10.0),
                  child:
                  Container(
                      height: 150.0,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      alignment: Alignment.centerLeft, //左中心对齐
                      child: Form(
                        key: _formKey,
                        child: new TextFormField(decoration: InputDecoration(
                          hintText: hitText, //提示词
                          border: InputBorder.none, //删去下划线
                        ),
                          maxLines: 5,
                          style: new TextStyle(fontSize: 22.0),
                          onSaved: (String value) {
                            content = value; //保存当前评论
                          },
                          controller: _commentController,
                        ),
                      )
                  )
              ),
              ImgContainer
            ],
          ),
        ),
      );
    }
  }
}