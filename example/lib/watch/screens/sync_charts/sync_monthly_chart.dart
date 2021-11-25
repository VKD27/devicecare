import 'package:devicecare_example/watch/utils/global_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SyncMonthlyChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SyncMonthlyChartState();
  }
}

class SyncMonthlyChartState extends State<SyncMonthlyChart> {
  DateTime todayTime = DateTime.now();
  List<DateTime> currentMonthDateTime = [];

  String dateTitle = '';

 // final List<charts.Series> seriesList = [];

  bool isNextDisable = true;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    currentMonthDateTime = await GlobalUtil.getMonthyDatesListByTime(todayTime);
    print('$currentMonthDateTime');
    setDateTitle(currentMonthDateTime);
  }

// dateToday.toString().substring(0,10)
  void setDateTitle(List<DateTime> monthList) {
    if (monthList.length > 0) {
      String year = monthList[0].year.toString();
      //String lastDay = monthList[monthList.length - 1].day.toString();
      String month = GlobalUtil.months[monthList[0].month - 1];
      setState(() {
        dateTitle = month + ' ' + year;
      });
    }
  }

  bool checkIsTodayAvail(DateTime todayTime, List<DateTime> currentMonthDateTime) {
    bool tempFlag = false;

    for(DateTime date in currentMonthDateTime){
      if (date.toString().substring(0,10).trim() == todayTime.toString().substring(0,10).trim()) {
        tempFlag = true;
        break;
      }
    }
    return  tempFlag;
  }

  @override
  Widget build(BuildContext context) {

    /*final myNumericFormatter = charts.BasicNumericTickFormatterSpec.fromNumberFormat(
       new NumberFormat.compact() // ← your format goes here
    );*/

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
                  // print('date time>> ${currentMonthDateTime[0]}');

                  DateTime time = GlobalUtil.getOneDayBackward(currentMonthDateTime[0]);
                  List<DateTime> pastNextMonth = await GlobalUtil.getMonthyDatesListByTime(time);

                  setState(() {
                    isNextDisable = false;
                    this.currentMonthDateTime = pastNextMonth;
                  });

                  setDateTitle(this.currentMonthDateTime);
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

                  DateTime time = GlobalUtil.getOneDayForward(currentMonthDateTime[currentMonthDateTime.length-1]);
                  List<DateTime> nextMonth = await GlobalUtil.getMonthyDatesListByTime(time);

                  setState(() {
                   this.currentMonthDateTime = nextMonth;
                    // if the today time is in the list then disable.
                    if(checkIsTodayAvail(todayTime, this.currentMonthDateTime))
                    {
                      isNextDisable = true;
                    }
                  });
                  setDateTitle(this.currentMonthDateTime);

                },
                icon: Icon(Icons.arrow_forward_ios_outlined, color: isNextDisable ? Colors.grey.withOpacity(0.5) : Colors.black),
              )
            ],
          ),
        ),
        /* SizedBox(
          height: 4.0,
        ),*/
        Container(
          margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          padding: EdgeInsets.all(4.0),
          width: double.infinity,
          height: 180,
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,

          ),
        ),
      ],
    );
  }

  /*List<charts.Series<MonthDataRep, String>> getSeriesDataList() {
    return [
      new charts.Series<MonthDataRep, String>(
        id: '',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (MonthDataRep item, __) => colorToChartColor(item.color != null ? item.color : completeColor),
        domainFn: (MonthDataRep sales, _) => sales.monthDateName,
        measureFn: (MonthDataRep sales, _) => sales.dataPoint,
        data: this.currentMonthDateTime.map((e) {
         // print('eValue>>> $e');
          //print('eday>>> ${e.day}');
          // do the maniculation based on the date to view month
         // String monthDate = e.toString().substring(0,10);
          String monthDate = e.day.toString();
          int dataValue = 10000 - e.weekday * 1000;
          
          return MonthDataRep(
            monthDateName: monthDate,
            dataPoint: dataValue,
            color: dataValue < GlobalUtil.totalTargetedSteps -2000 ? inCompletedColor : completeColor,
          );
        }).toList(),
      ) // Set series to use the secondary measure axis.
      // ..setAttribute(charts.measureAxisIdKey,  secondaryMeasureAxisId),
      // ..setAttribute(charts.measureAxisIdKey,  RTL.flipAxisLocations),
    ];
  }

  charts.Color colorToChartColor(Color color) {
    return charts.Color(a: color.alpha, r: color.red, g: color.green, b: color.blue);
  }*/
}

class MonthDataRep {
  final String monthDateName;
  final int dataPoint;
  final Color color;
  MonthDataRep({required this.monthDateName, required this.dataPoint, required this.color});
}
