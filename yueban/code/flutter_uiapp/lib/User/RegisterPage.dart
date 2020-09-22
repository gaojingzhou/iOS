import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uiapp/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter_uiapp/User/LoginPage.dart';
import 'package:flutter_uiapp/Chat/chat_home.dart';
import 'package:flutter_uiapp/YueBan/YueBanMainPage.dart';


class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}


class _RegisterPageState extends State<RegisterPage>{
  //输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _username = '';//用户名
  var _password = '';//密码
  var _phone = '';//手机号
  var _email = '';//email
  var _isShowPwd = false;//是否显示密码
  var _isUserNameClear = false;//是否显示输入框尾部的清除按钮
  var _isEmailClear = false;
  var _isPhoneClear = false;

  Dio dio = new Dio();//第三方网络加载库

  @override
  void initState() {
    //监听输入改变
    _usernameController.addListener((){
      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_usernameController.text.length > 0) {
        _isUserNameClear = true;
      }else{
        _isUserNameClear = false;
      }
    });
    _phoneController.addListener((){
      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_phoneController.text.length > 0) {
        _isPhoneClear = true;
      }else{
        _isPhoneClear = false;
      }
    });
    _emailController.addListener((){
      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_emailController.text.length > 0) {
        _isEmailClear = true;
      }else{
        _isEmailClear = false;
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
      return '用户名必须是2-10位的汉字、数字、字母！';
    }
    return null;
  }

  String validatePassWord(value){
    RegExp exp = RegExp(r'^[0-9A-Za-z]{6,20}$');
    if (value.isEmpty) {
      return '密码不能为空!';
    }
    else if (!exp.hasMatch(value)) {
      return '密码必须是6-20位的数字或字母！';
    }
    return null;
  }

  String validatePhone(value){
    // 正则匹配手机号
    RegExp exp = RegExp(r'^\d{11}$');
    if (value.isEmpty) {
      return '电话不能为空!';
    }else if (!exp.hasMatch(value)) {
      return '电话必须是11位数字';
    }
    return null;
  }

  String validateEmail(value){
    // 正则匹配邮箱
    RegExp exp = RegExp(r'^[A-Za-z0-9]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$');
    if (value.isEmpty) {
      return '邮箱不能为空!';
    }else if (!exp.hasMatch(value)) {
      return '邮箱不合法！';
    }
    return null;
  }


  //注册成功弹窗
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

  _registerPost() async{
    String url = 'http://localhost:8081/register';
    //以表单形式发送
    FormData registerdata = new FormData.from({
      "username": _username,
      "password": _password,
      "phone": _phone,
      "email": _email,
    });

    try{
      Response response = await dio.post(url, data: registerdata);
      if((response.data)['message'] == "success"){//注册成功
        showDialog(context: context, builder: (_) => _generateAlertDialog('注册成功'));
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
        title: Text("注册",
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
                  height: 100.0,
                  width: 100.0,
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
              child: Form(
                key:_formKey,
                child:Theme(
                  data: new ThemeData(primaryColor: Color(0xFF1296db)),
                  child: Column(
                    //用户名输入框
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,//尽可能填充
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: TextFormField(
                          cursorWidth: 3.0,
                          controller: _usernameController,
                          maxLines: 1,
                          autofocus: true,
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: "输入用户名",
                            prefixIcon: new IconButton(icon:Icon(Icons.account_circle),
                                onPressed: null, iconSize: 40.0),
                            suffixIcon: (_isUserNameClear)? IconButton(icon: Icon(Icons.clear),
                              onPressed: (){
                                WidgetsBinding.instance.addPostFrameCallback((_) => _usernameController.clear());
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
                          obscureText: !_isShowPwd,//密码显示
                          maxLines: 1,
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: "输入密码",
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
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: TextFormField(
                          cursorWidth: 3.0,
                          maxLines: 1,
                          controller: _phoneController,
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: "输入电话",
                            prefixIcon: new IconButton(icon:Icon(Icons.phone),
                                onPressed: null, iconSize: 40.0),
                            suffixIcon: (_isPhoneClear)? IconButton(icon: Icon(Icons.clear),
                              onPressed: (){
                                WidgetsBinding.instance.addPostFrameCallback((_) => _phoneController.clear());
                              },
                            ):null,
                          ),
                          validator: validatePhone,
                          onSaved: (String value){
                            _phone = value;//保存电话
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          cursorWidth: 3.0,
                          maxLines: 1,
                          controller: _emailController,
                          style: TextStyle(fontSize: 20.0),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: "输入邮箱",
                            prefixIcon: new IconButton(icon:Icon(Icons.email),
                                onPressed: null, iconSize: 40.0),
                            suffixIcon: (_isEmailClear)? IconButton(icon: Icon(Icons.clear),
                              onPressed: (){
                                WidgetsBinding.instance.addPostFrameCallback((_) => _emailController.clear());//输入内容清空
                              },
                            ):null,
                          ),
                          validator: validateEmail,
                          onSaved: (String value){
                            _email = value;//保存用户名
                          },
                        ),
                      ),
                    ],
                  )
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width,
                    child:RaisedButton(
                      color: Color(0xFF1296db),
                      child: Text(
                        "注册",
                        style: TextStyle(fontSize: 25.0, color: Colors.white),
                      ),
                      // 设置按钮圆角
                      shape: RoundedRectangleBorder(borderRadius:
                      BorderRadius.circular(10.0)),
                        onPressed: () {
                          if(_formKey.currentState.validate()){
                            _formKey.currentState.save();//赋值
                            _registerPost();
                          }
                        }
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}