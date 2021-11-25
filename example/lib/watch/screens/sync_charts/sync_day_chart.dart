import 'package:devicecare_example/watch/utils/global_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SyncDayChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SyncDayChartState();
  }
}

class SyncDayChartState extends State<SyncDayChart> {
  // List<DateTime> currentDayDateTime = [];

  DateTime todayTime = DateTime.now();
  DateTime currentDateTime = DateTime.now();

  String dateTitle = '';
  //late String toolText;

 // final List<charts.Series> seriesList = [];

  bool isNextDisable = true;

  //Map<String, num> _measures = {};

  //final _myState = new charts.UserManagedState<DateTime>();

  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, canShowMarker: false);
    super.initState();
    initializeData();
   /* // for day
    DateTime todayTime = DateTime.now();
    GlobalUtil.getOneDayBackward(todayTime);
    GlobalUtil.getOneDayForward(todayTime);*/
  }

  Future<void> initializeData() async {
    //currentDayDateTime = await GlobalUtil.getWeekDatesListByTime(todayTime);
    setDateTitle(todayTime);

  }

// dateToday.toString().substring(0,10)
  void setDateTitle(DateTime dateTime) {
      String firstDay = dateTime.day.toString();
      String month = GlobalUtil.months[dateTime.month - 1];
      String week = GlobalUtil.weeks[dateTime.weekday - 1];
      setState(() {
        dateTitle = firstDay + ', ' + month + ' (' + week+')';
      });
  }

  bool checkIsTodayAvail(DateTime todayTime, DateTime currentDayDateTime) {
    bool tempFlag = false;
    if (todayTime.toString().substring(0,10).trim() == currentDayDateTime.toString().substring(0,10).trim()) {
      tempFlag = true;
    }
    return  tempFlag;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          //margin: EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
         // padding: EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 20,
                onPressed: () async {
                  // print('date time>> ${currentDayDateTime[0]}');

                  DateTime time = GlobalUtil.getOneDayBackward(currentDateTime);
                  setState(() {
                    isNextDisable = false;
                    this.currentDateTime = time;
                  });

                  setDateTitle(this.currentDateTime);

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

                  DateTime nextDate = GlobalUtil.getOneDayForward(currentDateTime);
                  setState(() {
                    if(checkIsTodayAvail(todayTime, nextDate))
                    {
                      isNextDisable = true;
                    }
                    this.currentDateTime = nextDate;
                  });
                  setDateTitle(this.currentDateTime);

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
           // borderWidth: 0,
            onSelectionChanged: (selectionArgs) {
              print('selectionArgs>> $selectionArgs');
            },
            primaryXAxis: DateTimeCategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 4),
              dateFormat: DateFormat('''h:mm\na'''),
              labelIntersectAction: AxisLabelIntersectAction.wrap,
              /*title: AxisTitle(
                text: isCardView ? '' : 'Start time',
              ),*/
            ),
            primaryYAxis: NumericAxis(
              majorTickLines: const MajorTickLines(size: 4),
              //interval: 1000,
              minimum: 0,
              //maximum: 50,
              axisLine: const AxisLine(width: 0),
              labelFormat: '{value}',
             /* title: AxisTitle(
                text: isCardView ? '' : 'Duration in minutes',
              ),*/
            ),
            series: getSeriesDataList(currentDateTime),

            // for the default tool tip behaviour
            tooltipBehavior: _tooltipBehavior,

            /// To set the track ball as true and customized trackball behaviour.
            trackballBehavior: TrackballBehavior(
              enable: true,
              markerSettings: TrackballMarkerSettings(
                markerVisibility: TrackballVisibilityMode.hidden,
                // markerVisibility: _showMarker
                //     ? TrackballVisibilityMode.visible // to show always
                //     : TrackballVisibilityMode.hidden,
                height: 10,
                width: 10,
                borderWidth: 1,
              ),
              hideDelay: 1 * 1000,
              // hide delay 2 secs
              activationMode: ActivationMode.singleTap,
              tooltipAlignment: ChartAlignment.near,
              tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
              tooltipSettings: InteractiveTooltip(
                  format: null,
                  // format: _mode != TrackballDisplayMode.groupAllPoints
                  //     ? 'series.name : point.y'
                  //     : null,
                  canShowMarker: false),
              shouldAlwaysShow: false,
              lineWidth: 0
            ),
          ),
        ),
      ],
    );
  }


  List<ColumnSeries<DayDataRep, DateTime>> getSeriesDataList(DateTime currentDateTime) {
    return [
      new ColumnSeries<DayDataRep, DateTime>(
        name: currentDateTime.toString().substring(0, 10),
        dataSource: getSeriesData(currentDateTime),
        xValueMapper: (DayDataRep x, int xx) => x.time,
        yValueMapper: (DayDataRep sales, _) => sales.dataPoint,
        color: inCompletedColor,
        //pointColorMapper: (datum, index) =>  datum.color,
        // markerSettings: const MarkerSettings(isVisible: true),
      )
    ];
  }

  /*charts.Color colorToChartColor(Color color) {
    return charts.Color(a: color.alpha, r: color.red, g: color.green, b: color.blue);
  }*/

  List<DayDataRep> getSeriesData(DateTime dateTime){

    List<DayDataRep> data =[];

    //DateTime time =  currentDateTime;
    for(int i=1;i <= 40;i++){

      int dataValue = i*1000;
      DateTime time =  DateTime(dateTime.year, dateTime.month,dateTime.day,i+2,i*4) ;

      data.add(DayDataRep(
        weekName: '',
        time: time,
        dataPoint:dataValue,
        color: dataValue < GlobalUtil.totalTargetedSteps-2000
            ? inCompletedColor // incomplete color
            : completeColor,
      ));
    }
    return data;
  }


}

String getDateFormat(DateTime dateTime){
  return DateFormat("dd-MM-yyyy").format(dateTime);
}
class DayDataRep {
  final String weekName;
  final DateTime time;
  final int dataPoint;
  final Color color;

  DayDataRep({required this.weekName, required this.time, required this.dataPoint, required this.color});
}
