import 'package:devicecare_example/watch/custom/custom_circle_symbol_render.dart';
import 'package:devicecare_example/watch/utils/global_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:charts_flutter/flutter.dart' as charts;
//import 'package:charts_common/src/common/rtl_spec.dart' as RTL;


class WeeklyChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WeeklyChartState();
  }
}

class WeeklyChartState extends State<WeeklyChart> {
  DateTime todayTime = DateTime.now();
  List<DateTime> currentWeekDateTime = [];

  String dateTitle = '';

  final List<charts.Series> seriesList = [];

  bool isNextDisable = true;

  final _myState = new charts.UserManagedState<String>();


  @override
  void initState() {
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
          margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          padding: EdgeInsets.all(8.0),
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
        /* SizedBox(
          height: 4.0,
        ),*/
        Container(
          margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          padding: EdgeInsets.all(8.0),
          width: double.infinity,
          height: 180,
          child: new charts.BarChart(
            getSeriesDataList(),
            animate: false,
            barRendererDecorator: new charts.BarLabelDecorator<String>(),
            primaryMeasureAxis: new charts.NumericAxisSpec(
              tickProviderSpec: new charts.BasicNumericTickProviderSpec(desiredTickCount: 4),
              //renderSpec: new charts.NoneRenderSpec(),
              renderSpec:charts.GridlineRendererSpec(
                labelStyle: new charts.TextStyleSpec(
                    fontSize: 12,
                    color: colorToChartColor(Colors.grey),
                    fontFamily: 'Montserrat'),
                lineStyle: new charts.LineStyleSpec(
                    thickness: 1, color: colorToChartColor(Colors.grey)),
              ),
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
            behaviors: [
              charts.LinePointHighlighter(
                  symbolRenderer: CustomCircleSymbolRenderer(textTip: tiptext)
              )
            ],
            userManagedState: _myState,
            selectionModels: [
              charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                //updatedListener: infoSelectionModelUpdated,

                changedListener: _onSelectionChanged,
                /*changedListener: (model) {
                  print('change_ ${model.selectedDatum}');
                },*/
                /* updatedListener: (model) {
                  print('update_ ${model.toString()}');
                },*/
              ),
            ],

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
      ],
    );
  }

  void _onSelectionChanged(charts.SelectionModel<String> model) {

    final selectedDatum = model.selectedDatum;
    DateTime? time;
    final measures = <String, num>{};

    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.dateTime;

      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName!] = datumPair.datum.sales;
      });
    }


    // If you want to allow the chart to continue to respond to select events
    // that update the selection, add an updatedListener that saves off the
    // selection model each time the selection model is updated, regardless of
    // if there are changes.
    //
    // This also allows you to listen to the selection model update events and
    // alter the selection.
    model.selectedDatum.forEach((element) {
      print('datum_index>> ${element.index}');
      print('datum_datum>> ${element.datum}');
      WeekDataRep weekDataRep = element.datum;
      updateToolTip(weekDataRep);
    });

    model.selectedSeries.forEach((element) {
      print('series_displayName>> ${element.displayName}');
      print('series_category>> ${element.seriesCategory}');
      print('series_data>> ${element.data}');
      print('series_seriesIndex>> ${element.seriesIndex}');

    });
   // setState(() {
      _myState.selectionModels[charts.SelectionModelType.info] = new charts.UserManagedSelectionModel(model: model);
      //tiptext ='';
      print('model_{$model}');
    //});
  }

  List<charts.Series<WeekDataRep, String>> getSeriesDataList() {
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
  }

  charts.Color colorToChartColor(Color color) {
    return charts.Color(a: color.alpha, r: color.red, g: color.green, b: color.blue);
  }

  void updateToolTip(WeekDataRep weekDataRep) {
    print('dateTime ${weekDataRep.dateTime}');
    print('weekName ${weekDataRep.weekName}');
    String titleDate = DateFormat("dd-MM-yyyy").format(weekDataRep.dateTime);
    print('titleDate ${titleDate}');
   // if(mounted) {
      setState(() {
        this.tiptext = '12';
      });
   // }
  }

}


class WeekDataRep {
  final String weekName;
  final DateTime dateTime;
  final int dataPoint;
  final Color color;

  WeekDataRep({required this.weekName, required this.dateTime,required this.dataPoint, required this.color});
}
