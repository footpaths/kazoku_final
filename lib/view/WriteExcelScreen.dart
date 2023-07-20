import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:intl/intl.dart';
import 'package:kazoku_switch/model/registerData.dart';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column;

class WriteExcelScreen extends StatefulWidget {
  static const routeName = '/riteExcelScreen';

  final List<RegisterData> listSearch;

  const WriteExcelScreen({Key key, this.listSearch}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateTodoState(listSearch);
}

class _CreateTodoState extends State<WriteExcelScreen> {
  final List<RegisterData> _listSearchs;

  _CreateTodoState(this._listSearchs);

  void requestPermission() {
    PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  @override
  void dispose() {
    super.dispose();
  }

  var valueTotal = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Danh sách nợ phí'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
            child: Center(
          child: ElevatedButton(
            onPressed: () {
              _createExcel();
            },
            child: Text(
              'Xuất file',
              style: TextStyle(color: Colors.black54.withOpacity(1.0)),
            ),
            style: ElevatedButton.styleFrom(
                primary: Colors.greenAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),),
                textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            // shape: RoundedRectangleBorder(
            //   borderRadius: new BorderRadius.circular(18.0),
            //   side: BorderSide(color: Colors.greenAccent),
            // ),
            // color: Colors.greenAccent,
          ),
        )));
  }

  Future<void> _createExcel() async {
    var count = 3;
    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByIndex(1, 1).text = 'Danh Sách võ sinh';
    final Range range9 = sheet.getRangeByName('A1:G1');
    range9.cellStyle.backColor = '#ACB9CA';
    range9.merge();
    range9.cellStyle.hAlign = HAlignType.center;
    range9.cellStyle.vAlign = VAlignType.center;
    sheet.getRangeByIndex(1, 1).cellStyle.fontSize = 16;

    sheet.getRangeByName('A2').setText('Tên');
    sheet.getRangeByName('B2').setText('Ngày sinh');
    sheet.getRangeByName('C2').setText('Phone');
    sheet.getRangeByName('D2').setText('Học phí');
    sheet.getRangeByName('E2').setText('Màu đai');
    sheet.getRangeByName('F2').setText('Ghi chú');

    // sheet.getRangeByName('B2').setText('Ngày Vào Học');

    // sheet.getRangeByName('D2').setText('Ghi chú');
    // sheet.getRangeByName('E2').setText('Học phí');
    // sheet.getRangeByName('F2').setText('Ngày sinh');
    // sheet.getRangeByName('G2').setText('Màu đai');

    for (int i = 0; i < _listSearchs.length; i++) {
      var name = "A" + count.toString();
      var dob = "B" + count.toString();
      var phone = "C" + count.toString();
      var fee = "D" + count.toString();
      var rankColor = "E" + count.toString();
      var note = "F" + count.toString();



      sheet.getRangeByName(name).setText(_listSearchs[i].name);
      sheet.getRangeByName(dob).setText(_listSearchs[i].dob);
      // sheet.getRangeByName(date).setText(_listSearchs[i].time);
      sheet.getRangeByName(phone).setText(_listSearchs[i].phone);
      sheet.getRangeByName(fee).setText(_listSearchs[i].listHP);
      sheet.getRangeByName(rankColor).setText(getColorRank(_listSearchs[i].listcolor));
      sheet.getRangeByName(note).setText(_listSearchs[i].note);
      count++;
    }

    final List<int> bytes = workbook.saveAsStream();
    String path;
    if (Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isLinux ||
        Platform.isWindows) {
      final Directory directory =
          await path_provider.getApplicationSupportDirectory();
      path = directory.path;
    } else {
      path = await PathProviderPlatform.instance.getApplicationSupportPath();
    }
    DateTime now = DateTime.now();
    var formattedDates = DateFormat('yyyy-MM-dd kk:mm').format(now);
    var fileName =
        "danh_sach_vo_sinh" + "_" + formattedDates.toString() + ".xlsx";
    final File file =
        File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
    // await file.writeAsBytes(bytes, flush: true);
    if (Platform.isAndroid || Platform.isIOS) {
      //Launch the file (used open_file package)
      await open_file.OpenFile.open('$path/$fileName');
      await file.writeAsBytes(bytes);
      // await file.writeAsBytes(bytes, flush: true);
      // AwesomeDialog(
      //     context: context,
      //     animType: AnimType.LEFTSLIDE,
      //     headerAnimationLoop: false,
      //     dialogType: DialogType.SUCCES,
      //     title: 'Success',
      //     desc:
      //     'Xuất file thành công',
      //     btnOkOnPress: () {
      //       debugPrint('OnClcik');
      //     },
      //     btnOkIcon: Icons.check_circle,
      //     onDissmissCallback: () {
      //       debugPrint('Dialog Dissmiss from callback');
      //     }).show();
    } else if (Platform.isWindows) {
      await Process.run('start', <String>['$path\\$fileName'],
          runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>['$path/$fileName'], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>['$path/$fileName'],
          runInShell: true);
    }
    /*  if (Platform.isAndroid) {
      //FOR Android
      //final directory = await getExternalStorageDirectory();

      //final path = directory.path;
      String paths = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
      print(paths);
     DateTime now = DateTime.now();
     var formattedDates = DateFormat('yyyy-MM-dd kk:mm').format(now);
     var name  =  "danh_sach_vo_sinh"+"_"+formattedDates.toString()+".xlsx";
      File file = File('$paths/$name');

      await file.writeAsBytes(bytes, flush: true);

// Open the Excel document in mobile
     // OpenFile.open('$paths/Output.xlsx');


      AwesomeDialog(
          context: context,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.SUCCES,
          title: 'Success',
          desc:
          'Xuất file thành công. Vui lòng vào thư mục download(Tải về) để lấy file',
          btnOkOnPress: () {
            debugPrint('OnClcik');
          },
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: () {
            debugPrint('Dialog Dissmiss from callback');
          }).show();
    } else if (Platform.isIOS) {
      Directory documents = await getApplicationDocumentsDirectory();
     // Directory documentss = await getExternalStorageDirectory();
      //print('a'+documentss.path);
      print('bb'+documents.path);

      // var dir = await getExternalStorageDirectory();
       var paths = documents.path;
      DateTime now = DateTime.now();
      var formattedDates = DateFormat('yyyy-MM-dd kk:mm').format(now);
      var name  =  "danh_sach_vo_sinh"+"_"+formattedDates.toString()+".xlsx";
      File file = File('$paths/$name');
      //
       await file.writeAsBytes(bytes, flush: true);
     // OpenFile.open('$paths/Output.xlsx');
      FlutterShareFile.share(paths, name, ShareFileType.file);

      print('success');
    }*/
    workbook.dispose();
  }
}

String getColorRank(String listcolor) {
  var color = "";
  switch (listcolor) {
    case "0":
      color = "Trắng";
      break;
    case "1":
      color = "Vàng";
      break;
    case "2":
      color = "Cam";
      break;
    case "3":
      color = "Xanh lá";
      break;
    case "4":
      color = "Xanh dương";
      break;
    case "5":
      color = "Đỏ";
      break;
    case "6":
      color = "Tím";
      break;
    case "7":
      color = "Nâu 0";
      break;
    case "8":
      color = "Nâu 1";
      break;
    case "9":
      color = "Nâu 2";
      break;
    case "10":
      color = "Đen";
      break;
  }

  return color;
}
