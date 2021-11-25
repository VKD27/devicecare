import 'package:devicecare_example/watch/custom/custom_circle_symbol_render.dart';
import 'package:devicecare_example/watch/utils/global_utils.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class DayChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DayChartState();
  }
}

class DayChartState extends State<DayChart> {
  // List<DateTime> currentDayDateTime = [];

  DateTime todayTime = DateTime.now();
  DateTime currentDateTime = DateTime.now();

  String dateTitle = '';
  late String toolText;

  final List<charts.Series> seriesList = [];

  bool isNextDisable = true;

  Map<String, num> _measures = {};

  final _myState = new charts.UserManagedState<DateTime>();

  @override
  void initState() {
    toolText = getDateFormat(currentDateTime);
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
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime? time;
    final measures = <String, num>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName!] = datumPair.datum.dataPoint;
      });
    }


    // Request a build.
    setState(() {
      if (time!=null) {
        currentDateTime = time;
        _measures = measures;

      }
    });

    late String tempTime;

    _measures.forEach((String series, num value) {
      tempTime = '$series: $value'.toString();
    });

    setState(() {
      toolText = tempTime;
    });

  }
  @override
  Widget build(BuildContext context) {


    final children = <Widget>[
      Container(
        margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
        padding: EdgeInsets.all(8.0),
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
        padding: EdgeInsets.all(8.0),
        width: double.infinity,
        height: 180,
        child: new charts.TimeSeriesChart(
          getSeriesDataList(),
          animate: false,
          defaultRenderer: new charts.BarRendererConfig<DateTime>(),
          defaultInteractions: true,

          // Pass in the state you manage to the chart. This will be used to
          // override the internal chart state.
          //userManagedState: myState,
          behaviors: [

           // new charts.SelectNearest(),
           // new charts.DomainHighlighter(),
            new charts.LinePointHighlighter(
               // showHorizontalFollowLine: charts.LinePointHighlighterFollowLineType.none,
              //  showVerticalFollowLine: charts.LinePointHighlighterFollowLineType.nearest,
                symbolRenderer: CustomCircleSymbolRenderer(textTip: '1'),
              //getDateFormat(currentDateTime)
            ),

            // The duration of the animation can be adjusted by pass in
            // [hintDuration]. By default this is 3000ms.
            //new charts.InitialHintBehavior(maxHintTranslate: 4.0),

            // Optionally add a pan or pan and zoom behavior.
            // If pan/zoom is not added, the viewport specified remains the viewport
           // new charts.PanAndZoomBehavior(),

           /* new charts.ChartTitle('Bottom title text',
                behaviorPosition: charts.BehaviorPosition.bottom,
                titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),*/

            // Optional - By default, select nearest is configured to trigger
            // with tap so that a user can have pan/zoom behavior and line point
            // highlighter. Changing the trigger to tap and drag allows the
            // highlighter to follow the dragging gesture but it is not
            // recommended to be used when pan/zoom behavior is enabled.
            /*new charts.SelectNearest(
              eventTrigger: charts.SelectionTrigger.tapAndDrag,
              //selectionMode:
            )*/

          ],
          userManagedState: _myState,
          selectionModels: [
            new charts.SelectionModelConfig(
              type: charts.SelectionModelType.info,
              changedListener: _onSelectionChanged,
            )
          ],

          /*  behaviors: [
              charts.SlidingViewport(),
              charts.PanAndZoomBehavior(),
            ],*/
          //domainAxis: new charts.EndPointsTimeAxisSpec(),
          /* domainAxis: new charts.DateTimeAxisSpec(
              tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                day: new charts.TimeFormatterSpec(
                  //format: 'dd',
                  transitionFormat: 'MMM',
                ),
              ),
            ),*/

          /*domainAxis: charts.DateTimeAxisSpec(
              minimum: DateTime.now(),
              intervalType: DateTimeIntervalType.hours,
              desiredIntervals: 2,
              interval: 2,
              maximum: DateTime.now().add(
                Duration(hours: 12, minutes: 59, seconds: 59),
              ),

              // sets the date format to 12 hour
              dateFormat: DateFormat.jm(),
            ),*/
          primaryMeasureAxis: new charts.NumericAxisSpec(
            tickProviderSpec: new charts.BasicNumericTickProviderSpec(desiredTickCount: 4),
            renderSpec: true
                ? charts.GridlineRendererSpec(
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 12,
                  color: colorToChartColor(Colors.grey),
                  fontFamily: 'Montserrat'),
              lineStyle: new charts.LineStyleSpec(
                  thickness: 1, color: colorToChartColor(Colors.grey)),
            )
                : new charts.NoneRenderSpec(),
          ),
          //rtlSpec: RTL.RTLSpec(axisDirection: RTL.AxisDirection.reversed),
          //barGroupingType: charts.BarGroupingType.stacked,
          /* defaultRenderer: charts.BarRendererConfig(
              maxBarWidthPx: 12,
              // By default, bar renderer will draw rounded bars with a constant
              // radius of 100.
              // To not have any rounded corners, use [NoCornerStrategy]
              // To change the radius of the bars, use [ConstCornerStrategy]
              cornerStrategy: const charts.ConstCornerStrategy(4),
            ),*/
          // barGroupingType: charts.BarGroupingType.grouped,
          /* behaviors: [
              new charts.SeriesLegend(
// Positions for "start" and "end" will be left and right respectively
// for widgets with a build context that has directionality ltr.
// For rtl, "start" and "end" will be right and left respectively.
// Since this example has directionality of ltr, the legend is
// positioned on the right side of the chart.
                position: charts.BehaviorPosition.end,
// By default, if the position of the chart is on the left or right of
// the chart, [horizontalFirst] is set to false. This means that the
// legend entries will grow as new rows first instead of a new column.
                horizontalFirst: false,
// This defines the padding around each legend entry.
                cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
// Set show measures to true to display measures in series legend,
// when the datum is selected.
                showMeasures: false,
// Optionally provide a measure formatter to format the measure value.
// If none is specified the value is formatted as a decimal.
                measureFormatter: (num? value) {
                  return value == null ? '-' : '${value}k';
                },
              )
            ],*/
        ),
      ),
    ];

    // If there is a selection, then include the details.
    if (currentDateTime != null) {
      children.add(new Padding(
          padding: new EdgeInsets.only(top: 5.0),
          child: new Text(currentDateTime.toString())));
    }
    _measures.forEach((String series, num value) {
      children.add(new Text('${series}: ${value}'));
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }


  List<charts.Series<DayDataRep, DateTime>> getSeriesDataList() {
    return [
      new charts.Series<DayDataRep, DateTime>(
        id: '',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (DayDataRep item, __) => colorToChartColor(item.color != null ? item.color : completeColor),

        domainFn: (DayDataRep sales, _) => sales.time,
        measureFn: (DayDataRep sales, _) => sales.dataPoint,
        data: getSeriesData(currentDateTime)
        /*data: this.currentDayDateTime.map((e) {
          String week = GlobalUtil.weeks[e.weekday - 1];
          int dataValue = 10000 - e.weekday * 1000;
          return DayDataRep(
            weekName: week,
            dataPoint: dataValue,
            color: dataValue < GlobalUtil.totalTargetedSteps -2000
                ? inCompletedColor // incomplete color
                : completeColor, // completed color
          );
        }).toList(),*/
      ) // Set series to use the secondary measure axis.
      // ..setAttribute(charts.measureAxisIdKey,  secondaryMeasureAxisId),
      // ..setAttribute(charts.measureAxisIdKey,  RTL.flipAxisLocations),
    ];
  }

  charts.Color colorToChartColor(Color color) {
    return charts.Color(a: color.alpha, r: color.red, g: color.green, b: color.blue);
  }

  List<DayDataRep> getSeriesData(DateTime currentDateTime){

    List<DayDataRep> data =[];

    //DateTime time =  currentDateTime;
    for(int i=1;i <= 5;i++){

      int dataValue = i*100;
      DateTime time =  DateTime(currentDateTime.year, currentDateTime.month,currentDateTime.day,i+2,i*4) ;

      data.add(DayDataRep(
        weekName: '',
        time: time,
        dataPoint:dataValue,
        color: dataValue < GlobalUtil.totalTargetedSteps-8000
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
