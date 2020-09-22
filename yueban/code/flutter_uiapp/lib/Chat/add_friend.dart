import 'package:flutter/material.dart';
import 'Info.dart';
import 'personal_page.dart';

class AddPage extends StatefulWidget {
  AddPage({Key key, this.username}): super(key: key);
  final String username;
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
            title:Text('添加好友', style: TextStyle(color: Colors.grey),),
            actions:<Widget>[
              IconButton(
                  icon:Icon(Icons.search),
                  onPressed: (){
                    showSearch(context:context,delegate: searchBarDelegate(username: widget.username));
                  }
              ),
            ]
        )
    );
  }
}
const searchList = [
  "admin", "b", "c", "d", "e", "f"
];

var img_url = "https://c-ssl.duitang.com/uploads/item/201704/10/20170410073535_HXVfJ.thumb.700_0.jpeg";

const recentSuggest = [
  "输入用户名...",
];
class searchBarDelegate extends SearchDelegate<String>{
  searchBarDelegate({this.username});
  final String username;

  //初始化加载
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: ()=>query="",
      )
    ];
  }
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: ()=>close(context, null),
    );
  }
  @override
  Widget buildResults(BuildContext context) {

    return Container (
        margin: EdgeInsets.only(top: 10),
        key: new Key(query),

        child: GestureDetector(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container( //user portrait
                margin: const EdgeInsets.only(left:14.0, right: 14.0),
                child: new CircleAvatar(
                  backgroundImage: NetworkImage(img_url),
                ),
              ),
              Flexible (
                child: Column (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //group name
                    new Text(
                      query,
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, height: 1.7),
                    ),


                    //message data
                    new Container(
                      margin: const EdgeInsets.only(top: 6, bottom: 5),
                      child: new Text(" ", style: TextStyle(color: Colors.grey),),
                    ),
                  ],
                ),
              ),
              IconButton (
                icon: Icon(
                  Icons.face,
                  color: Colors.pinkAccent,
                  size: 15,
                ),
                alignment: Alignment.topLeft,
              ),
            ],

          ),
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PersonalPage(info: new Info(image_url: img_url, name: query, sex: "female"), username: username,)));
          },
        )
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSuggest
        : searchList.where((input) => input.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context,index) => ListTile(
        title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
                children:[
                  TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(
                          color: Colors.grey
                      )
                  )
                ]
            )
        ),
      ),
    );
  }
}
