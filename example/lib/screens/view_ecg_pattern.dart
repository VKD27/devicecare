import 'package:devicecare_example/model/lead_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ViewEcgPattern extends StatefulWidget{

  final Map<String, Object> ecgLeadData;

  ViewEcgPattern(this.ecgLeadData);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ViewEcgPatternState();
  }
  
}
class ViewEcgPatternState extends State<ViewEcgPattern>{

  List<ECGLeadData> ecgLeadList = [];

  LineChartData data = LineChartData();

  LineChartData setChartData(){
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xe0eacdc4),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xe0eacdc4),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: false,
      ),
      //lineTouchData:
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.ecgLeadData['EcgLeadList'] != null) {
      List<dynamic> leadData = widget.ecgLeadData['EcgLeadList'] as List;

      for (var data in leadData) {
        ecgLeadList.add(ECGLeadData.fromJson(data));
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    // data: ecgLeadList[0].leadIntegerData,
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.all(4.0),
                  width: double.infinity,
                  height: 100,
                  child:LineChart(
                    setChartData(),
                  ),
              )
            ],
          ),
        )
    );
  }
  
}