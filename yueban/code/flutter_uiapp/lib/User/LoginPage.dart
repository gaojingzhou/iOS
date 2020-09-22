import 'package:flutter/material.dart';
import 'package:flutter_uiapp/main.dart';
import 'package:flutter_uiapp/User/RegisterPage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_uiapp/Chat/chat_home.dart';
import 'package:flutter_uiapp/YueBan/YueBanMainPage.dart';
import 'package:flutter_uiapp/User/UserPage.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}


class LoginPageState extends State<LoginPage>{
  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userNameController = new TextEditingController();
  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Dio dio = new Dio();
  var _username = '';//用户名
  var _password = '';//密码
  var _isShowPwd = false;//是否显示密码
  var _isShowClear = false;//是否显示输入框尾部的清除按钮

  @override
  void initState() {
    //监听用户名框的输入改变
    _userNameController.addListener((){
      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_userNameController.text.length > 0) {
        _isShowClear = true;
      }else{
        _isShowClear = false;
      }
    });
    super.initState();
  }


  String validateUserName(value){
    RegExp exp = RegExp(r'^[0-9A-Za-z\u4E00-\u9FA5]{2,10}$');
    if (value.isEmpty) {
      return '用户名不能为空!' ;
    }
    else if (!exp.hasMatch(value)) {
      return '用户名必须是2-10位的汉字、数字、字母';
    }
    return null;
  }

  String validatePassWord(value){
    RegExp exp = RegExp(r'^[0-9A-Za-z]{6,20}$');
    if (value.isEmpty) {
      return '密码不能为空!';
    }
    else if (!exp.hasMatch(value)) {
      return '密码必须是6-20位的数字或字母';
    }
    return null;
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

  _loginPost() async{
    String url = 'http://localhost:8081/login';
    //以表单形式发送
    FormData registerdata = new FormData.from({
      "username": _username,
      "password": _password,
    });

    try{
      Response response = await dio.post(url, data: registerdata);
      if((response.data)['message'] == "success"){//登陆成功
        //跳转至登陆成功界面

        Navigator.push(context, MaterialPageRoute(builder:
            (context) => UserPage(
              username: (response.data)['username'],
            )));
      }else{
        showDialog(context: context, builder: (_) => _generateAlertDialog((response.data)['error_message']));
      }
    }catch(e){
      print("Connect Error: " + e.toString());
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:false,//删去返回顶栏
        title: Text("登陆",
          style: new TextStyle(fontWeight: FontWeight.w700, fontSize: 23.0),
          textAlign: TextAlign.left,
        ),
        centerTitle: true,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        actions: <Widget>[],

      ),
      body: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,//设置成屏幕宽度和高度
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: new EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
                child: Container(
                  height: 150.0,
                  width: 150.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new AssetImage(
                            "resources/icon.png")),
                  ),
                )
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              //表单
              child: Form(
                key: _formKey,
                child:Theme(
                    data: new ThemeData(primaryColor: Color(0xFF1296db)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,//尽可能填充
                      children: <Widget>[
                        //用户名输入框
                        Container(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            cursorWidth: 3.0,
                            controller: _userNameController,
                            maxLines: 1,
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintText: "输入用户名：",
                              prefixIcon: new IconButton(icon:Icon(Icons.account_circle),
                                  onPressed: null, iconSize: 40.0),
                              suffixIcon: (_isShowClear)? IconButton(icon: Icon(Icons.clear),
                                onPressed: (){
                                  WidgetsBinding.instance.addPostFrameCallback((_) => _userNameController.clear());//输入内容清空
                                },
                              ):null,
                            ),
                            validator: validateUserName,
                            onSaved: (String value){
                              _username = value;//保存用户名
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: TextFormField(
                            cursorWidth: 3.0,
                            obscureText: !_isShowPwd,//密码
                            maxLines: 1,
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintText: "输入密码：",
                              prefixIcon: new IconButton(icon:Icon(Icons.lock),
                                  onPressed: null, iconSize: 40.0),
                              suffixIcon: IconButton(
                                icon: Icon((_isShowPwd) ? Icons.visibility:Icons.visibility_off),
                                onPressed: (){
                                  setState(() {
                                    _isShowPwd = !_isShowPwd;
                                  });
                                },
                              )
                            ),
                            validator: validatePassWord,
                            onSaved: (String value){
                              _password = value;//密码赋值
                            },
                          ),
                        )
                      ],
                    )
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width/2-50,
                        child:OutlineButton(
                          borderSide: BorderSide(
                              color:  Color(0xFF1296db),
                              width: 2.0,
                              style: BorderStyle.solid
                          ),
                          disabledBorderColor: Color(0xFF1296db),
                          child: Text(
                            "注册",
                            style: TextStyle(fontSize: 25.0, color: Color(0xFF1296db)),
                          ),
                          // 设置按钮圆角
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          onPressed: (){
                            //跳转至注册界面
                            Navigator.push(context, MaterialPageRoute(builder:
                                (context) => RegisterPage()));
                          },
                        ),
                      ),
                      Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width/2-50,
                        child:RaisedButton(
                          color: Color(0xFF1296db),
                          child: Text(
                            "登陆",
                            style: TextStyle(fontSize: 25.0, color: Colors.white),
                          ),
                          // 设置按钮圆角
                          shape: RoundedRectangleBorder(borderRadius:
                          BorderRadius.circular(10.0)),
                          onPressed: (){
                            if(_formKey.currentState.validate()){
                              _formKey.currentState.save();//赋值
                              _loginPost();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog<Null>(
            context: context,
            builder: (BuildContext context) {
              return new SimpleDialog(
                // title: new Text('选择'),
                children: <Widget>[
                  new Container(
                    width: 300,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // 此处为发布动态
                        GestureDetector(
                          onTap: (){
                            showDialog(context: context, builder: (_) => _generateAlertDialog("请先登录"));

                          },
                          child: Column(
                            children: <Widget>[
                              new ClipOval(
                                child: Image.network(
                                  "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1579420558&di=5e2fdb134cd947e7ce05a0e6d5dbe559&imgtype=jpg&er=1&src=http%3A%2F%2Fku.90sjimg.com%2Felement_origin_min_pic%2F01%2F60%2F12%2F2957487f7fa2f2c.jpg",
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              Padding(padding: EdgeInsets.only(top:10),),
                              Text(
                                "发布动态",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                        ),
                        // 此处为发起约伴
                        Padding(
                          padding: EdgeInsets.all(20.0),
                        ),
                        GestureDetector(
                          onTap: (){
                            showDialog(context: context, builder: (_) => _generateAlertDialog("请先登录"));
                          },
                          child: Column(
                            children: <Widget>[
                              new ClipOval(
                                child: Image.network(
                                  "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1579420476&di=bf1de1edbcc099ca6b1dfa2ec756d292&imgtype=jpg&er=1&src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2F2008fcbce567095b4c868f811edac81d0f869f79481f-mNs4Dv_fw658",
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              Padding(padding: EdgeInsets.only(top:10),),
                              Text(
                                "发起约伴",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                        )

                      ],
                    ),
                  )

                ],
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => MyHomePage(username: "",)));
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.public, color: Colors.black54,size: 25.0,),
                      Text("动态", style: TextStyle(color: Colors.black54)
                      )],
                  )
              ),
              GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => YueBanMainPage(username: "",)));
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.group, color: Colors.black54,size: 25.0,),
                      Text("约伴", style: TextStyle(color: Colors.black54))
                    ],
                  )
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: Text("发布", style: TextStyle(color: Colors.black54, fontSize: 16.0)),
                  )
                ],
              ),
              GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => ChatHome(username: "",)));
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.forum, color: Colors.black54),
                      Text("社区", style: TextStyle(color: Colors.black54))
                    ],
                  )),
              GestureDetector(
                  onTap: null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.person, color: Colors.blueAccent),
                      Text("我的", style: TextStyle(color: Colors.blueAccent))
                    ],
                  ))
            ],
          ),
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}