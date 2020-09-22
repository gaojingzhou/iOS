import 'package:flutter/material.dart';
import 'YueBanRelease.dart';
import 'package:flutter_uiapp/Chat/chat_home.dart';
import 'package:flutter_uiapp/User/LoginPage.dart';
import 'package:flutter_uiapp/User/UserPage.dart';
import 'package:flutter_uiapp/main.dart';

class YueBanMainPage extends StatefulWidget{

  @override
  final String username;
  const YueBanMainPage({Key key, this.username}) : super(key: key);
  _YueBanMainPageState createState() => _YueBanMainPageState();
}

class _YueBanMainPageState extends State<YueBanMainPage>{
  var placePart = ["西南","西北","东北","华东","华南","华北","华中"];
  var viewPointName = ["三亚-海口-海南环岛","桂林-阳朔-北海-龙胜","香港-澳门","广州-深圳-佛山-珠海"
  ];
  var viewPointNames = [["川藏线-G318","川西-稻城-色达-丹巴","拉萨-阿里-林芝-珠峰","丙察察-墨脱","昆大丽卢-香格里拉-雨崩","甘南-若尔盖","大成都-峨眉山-青城山","贵州-黄果树"],
    ["青海湖-敦煌-大西北","青藏线-可可西里","北疆-南疆-新藏线","额济纳-巴丹吉林-腾格里"],
    ["呼伦贝尔-阿尔山","漠河-哈尔滨-长白山","河北-承德-张北-秦皇岛","大连-丹东-沈阳"],
    ["厦门-鼓浪屿-武夷山","台湾-金门-澎湖岛","黄山-宏村-徽杭古道","杭州-嘉兴-乌镇-西塘","庐山-三清山","泰山-青岛-蓬莱-威海","上海","南京-苏州-扬州-太湖"],
    ["三亚-海口-海南环岛","桂林-阳朔-北海-龙胜","香港-澳门","广州-深圳-佛山-珠海"],
    ["平遥-壶口-五台山","北京-天津"],
    ["张家界-凤凰-湘西","恩施-神农架-武当山"]];
  var viewPointImgs =[["11.jpg","12.jpg","13.jpg","14.jpg","15.jpg","16.jpg","17.jpg","18.jpg"],
    ["21.jpg","22.jpg","23.jpg","24.jpg"],
    ["31.jpg","32.jpg","33.jpg","34.jpg"],
    ["41.jpg","42.jpg","43.jpg","44.jpg","45.jpg","46.jpg","47.jpg","48.jpg"],
    ["51.jpg","52.jpg","53.jpg","54.jpg"],
    ["61.jpg","62.jpg"],
    ["71.jpg","72.jpg"]];
  int barPos = 0;

  Container _createElement(int index){
    String imgName = "YueBanImg/" + viewPointImgs[barPos][index];
    String pointName = viewPointNames[barPos][index];
    return Container(
        height: 200,
        width: 250,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white
        ),
        child: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder:
                (context) => YueBanRelease(title: pointName,)));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                imgName,
                width: 200,
                height: 150,
                fit: BoxFit.cover,
              ),
              Padding(padding: EdgeInsets.only(top:10),),
              Text(
                pointName,
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            ],
          ),
        )
    );
  }

  ListView _createListView(int num){
    var num = viewPointNames[barPos].length~/2;
    //num = num + 1;
    return ListView.builder(
      itemCount: num,
      itemBuilder: (BuildContext context, int index){
        // if (index == num) {
        //  return Row(
        //   children: <Widget>[
        //   Expanded(
        //     child: Container(
        //        color: Colors.white,
        //         width: 200,
        //         height: 5,
        //      ),
        //     )
        //  ],
        //);
        //}
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: _createElement(index*2),
            ),
            Expanded(
              child: _createElement(index*2+1),
            )
          ],
        );
      },
      shrinkWrap: true,
    );
  }

  Expanded _createBar(int index){
    return Expanded(
      child: FlatButton(
        child: Text(
          placePart[index],
          style: TextStyle(
              color: barPos == index ? Colors.blue : Colors.black,
              fontSize: 13
          ),
        ),
        onPressed: () {
          setState(() {
            barPos = index;
          });
        },
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
            "约伴"
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1577552577&di=9a9af205bf65a09dc875996688cf99db&imgtype=jpg&er=1&src=http%3A%2F%2Ffile02.16sucai.com%2Fd%2Ffile%2F2015%2F0128%2F8b0f093a8edea9f7e7458406f19098af.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _createBar(0),
              _createBar(1),
              _createBar(2),
              _createBar(3),
              _createBar(4),
              _createBar(5),
              _createBar(6),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height/2,
            child: _createListView((viewPointName.length)~/2),
          )
        ],
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
                            if(widget.username == null || widget.username == ""){
                              showDialog(context: context, builder: (_) => _generateAlertDialog("请先登录"));
                            }
                            else{
                              print("这里是发布动态");
                            }

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
                            if(widget.username == null || widget.username == ""){
                              showDialog(context: context, builder: (_) => _generateAlertDialog("请先登录"));
                            }
                            else{
                              print("这里是发起约伴");
                            }
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
                        (context) => MyHomePage(username: widget.username,)));
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
                  onTap: null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.group, color: Colors.blueAccent,size: 25.0,),
                      Text("约伴", style: TextStyle(color: Colors.blueAccent))
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
                        (context) => ChatHome(username: widget.username,)));
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.forum, color: Colors.black54),
                      Text("社区", style: TextStyle(color: Colors.black54))
                    ],
                  )),
              GestureDetector(
                  onTap: (){
                    if(widget.username == "" || widget.username == null){
                      Navigator.push(context, MaterialPageRoute(builder:
                          (context) => LoginPage()));
                    }
                    else{
                      Navigator.push(context, MaterialPageRoute(builder:
                          (context) => UserPage(username: widget.username,)));
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.person, color: Colors.black54),
                      Text("我的", style: TextStyle(color: Colors.black54))
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}