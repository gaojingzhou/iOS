import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'personal_page.dart';
import 'Info.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';


var image_url = [
  "https://pic2.zhimg.com/v2-fb7b5f511537cb2aeca2daa67de7b752_r.jpg",
  "https://pic3.zhimg.com/80/v2-f68edbc2f48bd5e41909782d885b8281_hd.jpg",
  "https://pic2.zhimg.com/80/v2-27fd8e971fdf33b2b68117c9d40f3f50_hd.jpg",
  "https://pic3.zhimg.com/80/v2-984974033b29bbf4bec34d5a237608f9_hd.jpg",
  "https://pic3.zhimg.com/80/v2-d91e47a42419fb2d1fdaaa91dbf4cac4_hd.jpg",

];

var name = ["Ada", "Brock", "Jake", "Niki", "Cardi"];

var sex = ["female", "male", "male", "female", "female"];

var imgs = [
  "resources/1.jpg",
  "resources/2.jpg",
  "resources/3.jpg",
];


class NearbyList extends StatefulWidget {
  NearbyList({Key key, this.username}): super(key: key);
  final String username;
  @override
  _NearbyListState createState() => new _NearbyListState();
}


class _NearbyListState extends State<NearbyList> {

  void initState() {
    super.initState();
    _init();
  }


  var nearby_list = List<Info>();



  _init() {
    for(int i = 0; i < name.length; i ++) {
      var tmp = Info(image_url: image_url[i], name: name[i], sex: sex[i]);
      nearby_list.add(tmp);
    }
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, //6 items
      itemExtent: 290.0,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: new Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
            color: Colors.white,
            borderOnForeground: false,
            elevation: 1.0,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(

                  children: <Widget>[
                    new Container(
                      //head protrait
                      margin: const EdgeInsets.all(14),
                      height: 80.0,
                      width: 80.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(nearby_list[index].image_url),

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
                                nearby_list[index].name,
                                style: new TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.0,
                                  color: Colors.black,
                                ),
                              ),

                              IconButton (
                                icon: nearby_list[index].sex == "male" ? Icon(
                                  Icons.face,
                                  color: Colors.lightBlueAccent,
                                  size: 15,
                                ) : Icon(
                                  Icons.face,
                                  color: Colors.pinkAccent,
                                  size: 15,
                                ),
                                alignment: Alignment.centerLeft,
                              ),

                            ],
                          ),


                          //message data
                          new Container(
                            margin: const EdgeInsets.only(top: 1, bottom: 5),
                            height: 20,
                            width: 60,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              disabledColor: Color(0xffB2DFEE),

                              child: new Text("300m", style: TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                  ],
                ),

                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: new GridImages(),

                )

              ],
            ),
          ),
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PersonalPage(info: nearby_list[index], username: widget.username,)));
          },
        );
      },
    );
  }
}

class GridImages extends StatefulWidget {
  GridImages({Key key}): super(key: key);
  //final List<String> images;
  @override
  _GridImagesState createState() => new _GridImagesState();
}

class _GridImagesState extends State<GridImages> {
  @override
  Widget build(BuildContext context) {
    return new GridView.count(
        crossAxisCount: 3,
        padding: const EdgeInsets.all(0.0),
        mainAxisSpacing: 1.0,
        crossAxisSpacing: 0.0,
        children: <Widget>[
          new Image.asset(imgs[0], fit: BoxFit.cover,),
          new Image.asset(imgs[1], fit: BoxFit.cover,),
          new Image.asset(imgs[2], fit: BoxFit.cover,),
      ],
    );
  }
}


