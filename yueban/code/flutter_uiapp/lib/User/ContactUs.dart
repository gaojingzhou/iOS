import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  @override
  createState() => new ContactUsState();
}

class ContactUsState extends State<ContactUs>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("联系我们"),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,

        child: Center(
          child: Text("微信: XXXXX",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}