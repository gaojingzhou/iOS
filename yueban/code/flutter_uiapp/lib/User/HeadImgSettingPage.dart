import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_uiapp/User/PersonalSettingPage.dart';




class HeadImgSettingPage extends StatefulWidget {
  @override
  final String username;
  const HeadImgSettingPage({Key key, this.username}) : super(key: key);
  createState() => new HeadImgSettingPageState();
}

class HeadImgSettingPageState extends State<HeadImgSettingPage>{
  String imgurl = "";
  Dio dio = new Dio(); //第三方网络加载库
  //记录选择的照片
  File _image;

  //当图片上传成功后，记录当前上传的图片在服务器中的位置
  String _imgServerPath;

  void initState() {
    super.initState();
    _getUserHeadImg();
  }
  //相册选择
  Future _getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  //上传图片到服务器
  _uploadImage() async {
    print(_image.path);
    FormData formData = FormData.from({
      "file": _image,
    });
    var response =
    await Dio().post("http://hn216.api.yesapi.cn/?s=App.CDN.UploadImg&app_key=E799FC6F782F40226E2D649B91DC8327&sign=EDDF81A089CD45249DEA9611FDC18CE9", data: formData);
    print(response.data["msg"]);
    if (response.statusCode == 200) {
      Map responseMap = response.data;
      print(responseMap);
      print("http://jd.itying.com${responseMap["data"]}");
      setState(() {
        _imgServerPath = "http://jd.itying.com${responseMap["path"]}";
      });
    }
  }

  _headImgSettingPost() async{
    String url = 'http://localhost:8081/userInfo';

    //以表单形式发送
    FormData data = new FormData.from({
      "username": widget.username,
      "sex":"",
      "headImg":_image.path
    });
    try{
      Response response = await dio.post(url, data: data);
    }catch(e){
      print("Connect Error: " + e.toString());
    }
  }

  _getUserHeadImg() async{
    String url = 'http://localhost:8081/userInfo?user_name=${widget.username}';
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

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("头像设置"),
        centerTitle: true,
        actions: <Widget>[
          Padding(padding: EdgeInsets.only(top: 10.0,right: 10.0),
            child: GestureDetector(
                child: Text(
                  "确认",
                  style: TextStyle(fontSize: 20.0, color: Color(0xFF1296db)),
                ),
                onTap: () {
                  _uploadImage();
                  _headImgSettingPost();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PersonalSettingPage(username: widget.username,);
                  }));
                }
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0,),
              child:Center(child: RaisedButton(
                color: Color(0xFF1296db),
                onPressed: () {
                  _getImageFromGallery();
                },
                child: Text("打开相册",style: TextStyle(fontSize: 20.0,color: Colors.white),),
              ),)
              ),
            Padding(padding: EdgeInsets.only(top: 20.0),),
            _image == null
                ?
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("resources/dog.jpeg"),
                    ),
                  ),
                ),
              )
                : Center(child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: FileImage(_image),
                ),
              ),
            ),)
          ],
        ),
      ),
    );
  }
}