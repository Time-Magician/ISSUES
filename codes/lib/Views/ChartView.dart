import 'package:demo5/common/global.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

List<RecordData> chartData = <RecordData>[];

class ChartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // chartData = <RecordData>[];
    return _MyHomePage();
  }
}

class _MyHomePage extends StatefulWidget {
 @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  Future future;
  @override
  void initState() {
    super.initState();
    future = getRequestGetStudyRecords();
  }

  //刷新数据
  Future refresh() async {
    setState(() {
      future = getRequestGetStudyRecords();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: SfCartesianChart(
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
            ]));
  }

}

class RecordData {
  RecordData(this.date, this.totalTime);
  final String date;
  final int totalTime;
}

Future<void> getRequestGetStudyRecords() async {
  if(chartData.isNotEmpty)
    chartData.clear();
  Dio dio = new Dio();
  dio.options.headers["authorization"] = "Bearer "+Global.token;
  String url ="http://10.0.2.2:9000/study-service/user/"+Global.userId.toString()+"/studyRecords";
  Response response = await dio
      .get(url);
  print(response);
  response.data.forEach((element) {
    chartData.add(RecordData(element["startTime"], element["duration"]));
  });
}
