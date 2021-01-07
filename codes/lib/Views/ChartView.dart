import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:io';
import 'package:demo5/common/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluwx/fluwx.dart';


GlobalKey repaintWidgetKey = GlobalKey();

class ChartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _MyHomePage();
  }
}

class _MyHomePage extends StatefulWidget {
 @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  Future future;
  List<RecordData> chartData = <RecordData>[];

  @override
  void initState() {
    super.initState();
    getRequestGetStudyRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
          actions: <Widget>[
            new MaterialButton(
              child: Text(
                "保存",
                style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(36)),
              ),
              onPressed: (() => {
                capture()
              }),
            ),
          ],
        ),
        body: RepaintBoundary(
            key: repaintWidgetKey,
            child: Container(
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    // Chart title
                    title: ChartTitle(text: '我的学习统计'),
                    // Enable legend
                    legend: Legend(isVisible: true),
                    // Enable tooltip
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries<RecordData, String>>[
                      LineSeries<RecordData, String>(
                          dataSource: chartData,
                          xValueMapper: (RecordData sales, _) => sales.date,
                          yValueMapper: (RecordData sales, _) => sales.totalTime,
                          // Enable data label
                          dataLabelSettings: DataLabelSettings(isVisible: true))
                    ]),
            )
        ),

    );
  }

  Future<void> getRequestGetStudyRecords() async {
    List<RecordData> _chartData = <RecordData>[];
    Dio dio = new Dio();
    dio.options.headers["authorization"] = "Bearer " + Global.token;
    String url = "http://"+Global.url+":9000/study-service/user/" +
        Global.userId.toString() + "/studyRecords";
    Response response = await dio
        .get(url);
    print(response);
    response.data.forEach((element) {
      _chartData.add(RecordData(element["startTime"], element["duration"]));
    });
    setState(() {
      chartData = _chartData;
    });
    // _shareUiImage();
  }

  Future<ByteData> _capturePngToByteData() async {
    try {
      RenderRepaintBoundary boundary = repaintWidgetKey.currentContext
          .findRenderObject();
      double dpr = ui.window.devicePixelRatio; // 获取当前设备的像素比
      ui.Image image = await boundary.toImage(pixelRatio: dpr);
      ByteData _byteData = await image.toByteData(
          format: ui.ImageByteFormat.png);
      return _byteData;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Null> _shareUiImage() async {
    ByteData sourceByteData = await _capturePngToByteData();
    Uint8List sourceBytes = sourceByteData.buffer.asUint8List();
    Directory documentsDirectory = await getExternalStorageDirectory();
    String storagePath = documentsDirectory.path;
    File file = new File('$storagePath/hello.png');
    print(file);
    if (!file.existsSync()) {
      file.createSync();
    }
    file.writeAsBytesSync(sourceBytes);
  }

  capture(){
    _shareUiImage();
  }
}

class RecordData {
  RecordData(this.date, this.totalTime);
  final String date;
  final int totalTime;
}


