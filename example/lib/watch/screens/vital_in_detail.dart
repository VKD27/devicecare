import 'package:devicecare_example/watch/screens/charts/monthly_chart.dart';
import 'package:devicecare_example/watch/screens/sync_charts/sync_day_chart.dart';
import 'package:devicecare_example/watch/screens/sync_charts/sync_weekly_chart.dart';
import 'package:devicecare_example/watch/utils/global_utils.dart';
import 'package:flutter/material.dart';

class VitalInDetail extends StatefulWidget {
  final String displayTitle;
  final String activityLabel;

  VitalInDetail({required this.displayTitle, required this.activityLabel});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VitalInDetailState();
  }
}

class VitalInDetailState extends State<VitalInDetail> {
  List<Widget> _buildTabs() {
    return <Widget>[
      Tab(
        child: Align(
          alignment: Alignment.center,
          child: Text("Day"),
        ),
        //text: "Day",
      ),
      Tab(
        child: Align(
          alignment: Alignment.center,
          child: Text("Week"),
        ),
        //text: "Day",
      ),
      Tab(
        child: Align(
          alignment: Alignment.center,
          child: Text("Month"),
        ),
        //text: "Day",
      ),
      /*Tab(text: "Week"),
      Tab(text: "Week"),*/
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<String> list = GlobalUtil.getCurrentDayWeekDates();
    // for week
    // GlobalUtil.getWeekDatesListByTime(todayTime);

    // for month to current date
    // GlobalUtil.getMonthyDatesListByTime(todayTime);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.white,
          backgroundColor: Colors.lightBlueAccent,
          elevation: 2,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          //iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            widget.displayTitle,
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[],
          bottom: TabBar(
            labelColor: Colors.blueGrey,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                color: Colors.white),
            tabs: _buildTabs(),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
           /* SizedBox(
              height: 4.0,
            ),*/
            Container(
              margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              padding: EdgeInsets.all(8.0),
              child: Center(child: Text( widget.activityLabel, textAlign: TextAlign.center,)),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  //DayChart(),
                  SyncDayChart(),
                  //WeeklyChart(),
                  SyncWeeklyChart(),
                  MonthlyChart(),
                ],
              ),
            ),
            SizedBox(
              height: 4.0,
            ),
          ],
        ),
      ),
    );
  }
}
