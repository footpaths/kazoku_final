import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<ScheduleScreen> {

  @override
  void initState() {
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đồng bộ dữ liệu"),
        centerTitle: true,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(),
          child: Container(
    child: Text("")
    ),
    )
    );
  }
}


