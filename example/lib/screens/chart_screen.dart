import 'package:devicecare_example/model/lead_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ChartScreen extends StatefulWidget{

  final Map<String, Object> ecgLeadData;

  ChartScreen(this.ecgLeadData);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChartScreenState();
  }
  
}
class ChartScreenState extends State<ChartScreen>{

  List<ECGLeadData> ecgLeadList = [];
  List<String> ecgNameList = ['I','II','III', 'AVR','AVL','AVF','V1','V2','V3','V4','V5','V6'];

  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    // TODO: implement initState
    _zoomPanBehavior = ZoomPanBehavior(
      enableDoubleTapZooming: true,
      enablePanning: true,
      enablePinching: true,
      enableMouseWheelZooming: true,
      enableSelectionZooming: true
    );
    if (widget.ecgLeadData['EcgLeadList'] != null) {
      List<dynamic> leadData = widget.ecgLeadData['EcgLeadList'] as List;

      for (var data in leadData) {
        ecgLeadList.add(ECGLeadData.fromJson(data));
      }
    }
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: const Text('ECG Data'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              /*Container(
                  margin: EdgeInsets.all(4.0),
                  width: double.infinity,
                  height: 100,
                  child: SfCartesianChart(
                    *//*series: <LineSeries<String,dynamic>>[
                     LineSeries<String,dynamic>(
                      dataSource: ecgLeadList[0].leadData,
                       xValueMapper: (String sales, _) => ecgLeadList[0].leadType,
                       yValueMapper: (String sales, _) => 0,
                       animationDuration: 0,
                     )
                    ],*//*
                    //series: ,
                   // da: ecgLeadList[0].leadIntegerData,
                    *//*data: <double>[
                      1, 5, -6, 0, 1, -2, 7, -7, -4, -10, 13, -6, 7, 5, 11, 5, 3
                    ],*//*
                  )
              ),*/
              SizedBox(
                height: 12,
              ),

             /* Container(
                margin: EdgeInsets.all(4.0),
                //width: double.infinity,
                 // height: 100,
                  child: SfSparkLineChart(
                    data: ecgLeadList[10].leadIntegerData,
                    axisLineWidth: 0.0,
                    *//*data: <double>[
                      1, 5, -6, 0, 1, -2, 7, -7, -4, -10, 13, -6, 7, 5, 11, 5, 3
                    ],*//*
                  )
              ),*/
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                //scrollDirection: Axis.horizontal,
                itemCount: ecgLeadList.length,

                itemBuilder: (BuildContext context,int index) {

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(ecgLeadList[index].leadType+'\n(${ecgNameList[index]})'),
                      ),
                      Expanded(
                        child: Container(
                            //margin: EdgeInsets.all(4.0),
                            padding: const EdgeInsets.all(4.0),
                           // width: double.infinity*3,
                             height: 180,
                            child: SfSparkLineChart(
                              data: ecgLeadList[index].leadIntegerData,
                              axisLineWidth: 0.0,
                            )
                        ),
                      ),
                    ],
                  );
                },
              ),

            ],
          ),
        )
    );
  }
}

class EcgData {
  EcgData(this.value1, this.value2);

  final double value1;
  final double value2;
}