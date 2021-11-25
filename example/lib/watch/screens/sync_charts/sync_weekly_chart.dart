import 'package:devicecare_example/watch/utils/global_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:syncfusion_flutter_charts/charts.dart';

class SyncWeeklyChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SyncWeeklyChartState();
  }
}

class SyncWeeklyChartState extends State<SyncWeeklyChart> {
  DateTime todayTime = DateTime.now();
  List<DateTime> currentWeekDateTime = [];

  String dateTitle = '';

  //final List<charts.Series> seriesList = [];

  bool isNextDisable = true;

  //final _myState = new charts.UserManagedState<String>();

  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: false, header: '');
    super.initState();
    initializeData();
  }


  Future<void> initializeData() async {
    currentWeekDateTime = await GlobalUtil.getWeekDatesListByTime(todayTime);
    setDateTitle(currentWeekDateTime);
  }

// dateToday.toString().substring(0,10)
  void setDateTitle(List<DateTime> weekList) {
    if (weekList.length > 0) {
      String firstDay = weekList[0].day.toString();
      String lastDay = weekList[weekList.length - 1].day.toString();
      String month = GlobalUtil.months[weekList[0].month - 1];

      setState(() {
        dateTitle = firstDay + ' - ' + lastDay + ' ' + month;
      });
    }
  }

  bool checkIsTodayAvail(DateTime todayTime, List<DateTime> currentWeekDateTime) {
    bool tempFlag = false;

    for(DateTime date in currentWeekDateTime){
      if (date.toString().substring(0,10).trim() == todayTime.toString().substring(0,10).trim()) {
        tempFlag = true;
        break;
      }
    }
    return  tempFlag;
  }

  String tiptext ='1';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          // margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          // padding: EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 20,
                onPressed: () async {
                  // print('date time>> ${currentWeekDateTime[0]}');

                  DateTime time = GlobalUtil.getOneDayBackward(currentWeekDateTime[0]);
                  List<DateTime> pastNextWeek = await GlobalUtil.getWeekDatesListByTime(time);

                  setState(() {
                    isNextDisable = false;
                    this.currentWeekDateTime = pastNextWeek;
                  });

                  setDateTitle(this.currentWeekDateTime);
                },
                icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
              ),
              Center(
                  child: Text('$dateTitle',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600))),
              IconButton(
                iconSize: 20,
                onPressed: isNextDisable ? null : () async {

                  DateTime time = GlobalUtil.getOneDayForward(currentWeekDateTime[currentWeekDateTime.length-1]);
                  List<DateTime> nextWeek = await GlobalUtil.getWeekDatesListByTime(time);

                  setState(() {
                   this.currentWeekDateTime = nextWeek;
                    // if the today time is in the list then disable.
                    if(checkIsTodayAvail(todayTime, this.currentWeekDateTime))
                    {
                      isNextDisable = true;
                    }
                  });
                  setDateTitle(this.currentWeekDateTime);

                },
                icon: Icon(Icons.arrow_forward_ios_outlined,
                    color: isNextDisable
                        ? Colors.grey.withOpacity(0.5)
                        : Colors.black),
              )
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          padding: EdgeInsets.all(4.0),
          width: double.infinity,
          height: 200,
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 4),
            ),
            primaryYAxis: NumericAxis(
              majorTickLines: const MajorTickLines(color: Colors.transparent),
              labelFormat: '{value}',
              minimum: 0,
              //maximum: 25,
              //interval: 5,
              axisLine: const AxisLine(width: 0),
            ),
            tooltipBehavior: _tooltipBehavior,
            series: _getGradientComparisonSeries(currentWeekDateTime),
          ),
        ),
      ],
    );
  }

  List<CartesianSeries<WeekDataRep, String>> _getGradientComparisonSeries(List<DateTime> currentDateTime) {

    return <CartesianSeries<WeekDataRep, String>>[
      new ColumnSeries<WeekDataRep, String>(
        //name: currentDateTime.toString().substring(0,10),
        xValueMapper:  (WeekDataRep sales, _) => sales.weekName,
        yValueMapper:(WeekDataRep sales, _) => sales.dataPoint,
        dataLabelMapper: (datum, index) => datum.dateTime.toString().substring(0,10),
        onCreateShader: (ShaderDetails details) {
          return ui.Gradient.linear(
              details.rect.topCenter,
              details.rect.bottomCenter,
              const <Color>[Colors.red, Colors.orange, Colors.yellow],
              <double>[0.3, 0.6, 0.9]);
        },
        width: 0.5,
        //color: ,
        dataSource: this.currentWeekDateTime.map((e) {
          String week = GlobalUtil.weeks[e.weekday - 1];
          int dataValue = 100000 - e.weekday * 1000;
          return WeekDataRep(
            weekName: week,
            dateTime: e,
            dataPoint: dataValue,
            color: dataValue < GlobalUtil.totalTargetedSteps -2000
                ? inCompletedColor // incomplete color
                : completeColor, // completed color
          );
        }).toList(),
       // dataLabelSettings: DataLabelSettings(isVisible: true, offset: const Offset(0, -5)),
      )
    ];
  }

 /* List<charts.Series<WeekDataRep, String>> getSeriesDataList() {
    return [
      new charts.Series<WeekDataRep, String>(
        id: '',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (WeekDataRep item, __) => colorToChartColor(
            item.color != null ? item.color : completeColor),
        domainFn: (WeekDataRep sales, _) => sales.weekName.toString(),
        measureFn: (WeekDataRep sales, _) => sales.dataPoint,
        data: this.currentWeekDateTime.map((e) {
          String week = GlobalUtil.weeks[e.weekday - 1];
          int dataValue = 10000 - e.weekday * 1000;
          return WeekDataRep(
            weekName: week,
            dateTime: e,
            dataPoint: dataValue,
            color: dataValue < GlobalUtil.totalTargetedSteps -2000
                ? inCompletedColor // incomplete color
                : completeColor, // completed color
          );
        }).toList(),

      ) // Set series to use the secondary measure axis.
      // ..setAttribute(charts.measureAxisIdKey,  secondaryMeasureAxisId),
      // ..setAttribute(charts.measureAxisIdKey,  RTL.flipAxisLocations),
    ];
  }*/

  /*charts.Color colorToChartColor(Color color) {
    return charts.Color(a: color.alpha, r: color.red, g: color.green, b: color.blue);
  }*/

  /*void updateToolTip(WeekDataRep weekDataRep) {
    print('dateTime ${weekDataRep.dateTime}');
    print('weekName ${weekDataRep.weekName}');
    String titleDate = DateFormat("dd-MM-yyyy").format(weekDataRep.dateTime);
    print('titleDate ${titleDate}');
   // if(mounted) {
      setState(() {
        this.tiptext = '12';
      });
   // }
  }*/

}


class WeekDataRep {
  final String weekName;
  final DateTime dateTime;
  final int dataPoint;
  final Color color;

  WeekDataRep({required this.weekName, required this.dateTime,required this.dataPoint, required this.color});
}
