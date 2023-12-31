import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kazoku_switch/view/AdminScreen.dart';

class AdminDirectScreen extends StatefulWidget {
  static const routeName = '/adminScreen';

  const AdminDirectScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<AdminDirectScreen> {
  _CreateTodoState();

  List<String> listKeyName = new List();
  List<String> listKeyNameDelete = new List();
  bool isLoading = false;
  @override
  void initState() {
    getRecord();
    super.initState();


  }

  @override
  void dispose() {
    super.dispose();
  }




  Future<void> getRecord()  {
    final databaseReference = FirebaseDatabase.instance.reference();
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    databaseReference.keepSynced(true);
     databaseReference.once().then((DataSnapshot snapshot) {
      

      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {

        if (key.toString().contains("delete") ||
            key.toString().contains("monney") ||
            key.toString().contains("link")) {
          if(key.toString().contains("delete")){
            listKeyNameDelete.add(key);
          }

        } else {
          listKeyName.add(key);

        }
      });

      setState(() {
      isLoading = true;
      });
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Quản lý CLB"),
          centerTitle: true,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: !isLoading ? Center(
          child: CircularProgressIndicator(),
        ) : Container(
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Transform.scale(
                      scale: 1.0,
                      child: ButtonTheme(
                        minWidth: 200.0,
                        height: 40.0,
                        child: ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false
                            // otherwise.
                            setState(() {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AdminScreen(listKeyName: listKeyName,)));
                            });
                          },
                          child: Text(
                            'Danh sách võ sinh',
                            style: TextStyle(
                                color: Colors.white.withOpacity(1.0)),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.cyan,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),),
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: new BorderRadius.circular(18.0),
                          //   side: BorderSide(color: Colors.cyan),
                          // ),
                          // color: Colors.cyan,
                        ),
                      )),


                  SizedBox(
                    height: 10.0,
                  ),
                  Transform.scale(
                      scale: 1.0,
                      child: ButtonTheme(
                        minWidth: 200.0,
                        height: 40.0,
                        child: ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false
                            // otherwise.
                            setState(() {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AdminScreen(listKeyName: listKeyNameDelete,)));
                            });
                          },
                          child: Text(
                            'Danh sách bị xoá',
                            style: TextStyle(
                                color: Colors.white.withOpacity(1.0)),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.cyan,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),),
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                      )),
                ],
              )),
        )
    );
  }
}
