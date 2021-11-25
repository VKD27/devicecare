import 'package:devicecare_example/watch/utils/all_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//const Color completeColor = Color(0xFF36688D);
const Color completeColor = Colors.deepPurple;
const Color inCompletedColor = Colors.lightBlueAccent;

const String goalTextTitle = "According to the WHO recommendations, you need atleast 150 minutes a week moderate aerobic activity which is equivalent to at least 8000 per day.";

enum Activity { STEPS, CAl, DISTANCE}


extension ActivityExtension on Activity {
  String get name {
    return ["Steps", "Calories Burnt", "Distance"][this.index];
  }
}

extension ActivityTextLabel on Activity {
  String get textLabel {
    return [
      "Steps are a useful measure of how much you're moving around the world which can helps you spot changes in your activity levels" ,
      "Your body uses energy for more than just workouts. You'll see an estimate of your total calories burned while your are in rest as well as active.",
      'Measuring your distance is useful way to track your achievements in your running or walking activities',
    ][this.index];
  }
}

const activityIndex = [
  'steps',
  'cal',
  'km',
];
const activityText = [
  "Steps are a useful measure of how much you're moving around the world which can helps you spot changes in your activity levels" ,
  "Your body uses energy for more than just workouts. You'll see an estimate of your total calories burned while your are in rest as well as active.",
  'Measuring your distance is useful way to track your achievements in your running or walking activities',
];

class GlobalUtil{

  static int totalTargetedSteps = 10000;
  static String addSmartWatchText = 'Add a Smart watch to get to know more about your health information.';

  // datetime.month - 1
  static List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  // datetime.weekday - 1
  static List<String> weeks = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];


  Future<String> selectGoalSteps(BuildContext context, String tempSelectedSteps, String _selectedSteps) async {
    List<Text> defaulStepsList = initializeSteps(2000, 35000);
   // goalTextTitle
    String? selectedSteps = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButtonWidget(
                      title: 'Cancel',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButtonWidget(
                      title: 'Done',
                      onPressed: () {
                        //Navigator.of(context).pop();
                        Navigator.of(context).pop(tempSelectedSteps);
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  child: CupertinoPicker(
                    //offAxisFraction: 0.18, // 0.45 is the Max
                    magnification: 2.35 / 2.1,
                    useMagnifier: true,
                    squeeze: 1.25,
                    onSelectedItemChanged: (value) {
                      print('value_index>> $value');
                      tempSelectedSteps = (value).toString();
                    },
                    selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(),
                    backgroundColor: Colors.white,
                    itemExtent: 28,
                    scrollController: FixedExtentScrollController(initialItem: int.parse(tempSelectedSteps)),
                    //itemExtent: 10,
                    //children: defaulStepsList.map((e) => Text(e)).toList(),
                    children: defaulStepsList,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedSteps != null && selectedSteps != _selectedSteps) {
      return selectedSteps;
    } else {
      return tempSelectedSteps;
    }
  }

  List<Text> initializeSteps(int min, int max) {
    List<Text> steps =[];
    for (int i = min; i <= max; i+1000) {
      steps.add(Text(i.toString()));
    }
    return steps;
  }
  // Find the first date of the week which contains the provided date.
  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  // Find last date of the week which contains provided date.
  static DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }


  // Find the first date of the month which contains the provided date.
  static DateTime findFirstDateOfTheMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }

  // Find last date of the month which contains provided date.
  static DateTime findLastDateOfTheMonth(DateTime dateTime) {
    return dateTime.month < 12 ? DateTime( dateTime.year,  dateTime.month + 1, 0) : DateTime( dateTime.year + 1, 1, 0);
  }



  // operations for the calender shifts
  static DateTime getOneDayBackward(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day -1);
  }

  static DateTime getOneDayForward(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day +1);
  }

  static DateTime getLastDayofCurrentMonth(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    return lastDayOfMonth;
  }

  static Future<List<DateTime>> getWeekDatesListByTime(DateTime dateTime) async{

  //  print('inside>> $dateTime');
    // pass the current date time or past week time
    DateTime firstDate = findFirstDateOfTheWeek(dateTime);

   // print('firstDate>> $firstDate');

    DateTime lastDate = findLastDateOfTheWeek(dateTime);

  //  print('lastDate>> $lastDate');

    List<DateTime> weekDays =[];
    if (firstDate.day > lastDate.day) {
      //27 > 3
      int i=0;
      while(i<7){
        weekDays.add(DateTime(firstDate.year, firstDate.month, firstDate.day+i));
        i++;
      }

    }else{

      for(int i= firstDate.day; i <= lastDate.day;i++){
        weekDays.add(DateTime(firstDate.year, firstDate.month, i));
      }

    }

    print('$weekDays');
    return weekDays;
  }

  static Future<List<DateTime>> getMonthyDatesListByTime(DateTime dateTime) async{

    // below code is used for the current month

    // pass the current date time or past week time
   // print('inside>> $dateTime');
    // pass the current date time or past week time
    DateTime firstDate = findFirstDateOfTheMonth(dateTime);
   // print('firstDate>> $firstDate');
    DateTime lastDate = findLastDateOfTheMonth(dateTime);
   // print('lastDate>> $lastDate');

    List<DateTime> monthDays =[];

    for(int i= firstDate.day; i <= lastDate.day;i++){
      monthDays.add(DateTime(firstDate.year, firstDate.month, i));
    }
    return monthDays;
  }


  static List<String> getCurrentDayWeekDates(){
   // var dateFormatTemp = DateFormat("dd-MM-yyyy");
    //DateFormat("dd-MM-yyyy").format(DateTime.now());
    DateTime today = DateTime.now();
    DateTime firstDate = findFirstDateOfTheWeek(today);
    DateTime lastDate = findLastDateOfTheWeek(today);
    // or
    //String date = dateToday.toString().substring(0,10);

    print('first date : >> ${firstDate.day}');
    print('last date : >> ${lastDate.day}');

    List<String> weekDays =[];

    //var currentDate = DateTime(firstDate.year, 2 );
    for(int i= firstDate.day; i <= lastDate.day;i++){
      weekDays.add(DateTime(firstDate.year, firstDate.month, i ).toString().substring(0,10).trim());
    }

    print('$weekDays');

    List<String> weekDays12 =[];

    DateTime pastNext = DateTime(firstDate.year, firstDate.month, firstDate.day-1);

    DateTime firstDate12 = findFirstDateOfTheWeek(pastNext);
    DateTime lastDate12 = findLastDateOfTheWeek(pastNext);

    for(int i= firstDate12.day; i <= lastDate12.day;i++){
      weekDays12.add(DateTime(firstDate12.year, firstDate12.month, i ).toString().substring(0,10).trim());
    }

    print('$weekDays12');


    List<String> weekDays23 =[];

    DateTime pastNext12 = DateTime(firstDate12.year, firstDate12.month, firstDate12.day-1);

    DateTime firstDate23 = findFirstDateOfTheWeek(pastNext12);
    DateTime lastDate23 = findLastDateOfTheWeek(pastNext12);

    for(int i= firstDate23.day; i <= lastDate23.day;i++){
      weekDays23.add(DateTime(firstDate23.year, firstDate23.month, i ).toString().substring(0,10).trim());
    }

    print('$weekDays23');


    return weekDays;
  }


  /// Find first date of previous week using a date in current week.
  /// [dateTime] A date in current week.
  DateTime findFirstDateOfPreviousWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfLastWeek = dateTime.subtract(const Duration(days: 7));
    return findFirstDateOfTheWeek(sameWeekDayOfLastWeek);
  }

  /// Find last date of previous week using a date in current week.
  /// [dateTime] A date in current week.
  DateTime findLastDateOfPreviousWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfLastWeek = dateTime.subtract(const Duration(days: 7));
    return findLastDateOfTheWeek(sameWeekDayOfLastWeek);
  }


  /// Find first date of next week using a date in current week.
  /// [dateTime] A date in current week.
  DateTime findFirstDateOfNextWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfNextWeek = dateTime.add(const Duration(days: 7));
    return findFirstDateOfTheWeek(sameWeekDayOfNextWeek);
  }

  /// Find last date of next week using a date in current week.
  /// [dateTime] A date in current week.
  DateTime findLastDateOfNextWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfNextWeek = dateTime.add(const Duration(days: 7));
    return findLastDateOfTheWeek(sameWeekDayOfNextWeek);
  }

  static String formatNumber(int number) {
    var f = new NumberFormat("#,###", "en_US");
    return f.format(number);
  }

 /* extension DateTimeExtension on DateTime {

  DateTime get firstDayOfWeek => subtract(Duration(days: weekday - 1));

  DateTime get lastDayOfWeek =>
      add(Duration(days: DateTime.daysPerWeek - weekday));

  DateTime get lastDayOfMonth =>
      month < 12 ? DateTime(year, month + 1, 0) : DateTime(year + 1, 1, 0);
}*/

}