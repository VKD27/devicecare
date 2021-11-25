import 'package:devicecare_example/global/constants.dart';
import 'package:devicecare_example/watch/custom/custom_circle_progrees.dart';
import 'package:devicecare_example/watch/screens/add_device.dart';
import 'package:devicecare_example/watch/screens/vital_in_detail.dart';
import 'package:devicecare_example/watch/screens/vital_settings.dart';
import 'package:devicecare_example/watch/utils/cal_utils.dart';
import 'package:devicecare_example/watch/utils/global_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VitalMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VitalMainState();
  }
}

class VitalMainState extends State<VitalMain> with SingleTickerProviderStateMixin{
  DateTime todayTime = DateTime.now();

  late AnimationController progressController;
  late Animation _animation;

  late double noOfSteps;

  late double progressPercentage;

  @override
  void initState() {
    //progressController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));

    noOfSteps = 8000;

    progressPercentage = (noOfSteps * 100) / GlobalUtil.totalTargetedSteps;

    print('progressPercentage>> ${progressPercentage.toString()}');

    double kCal = calculateEnergyExpenditure(
        173,
        DateTime(1992, 2, 27, 05, 45, 0),
        72,
        Gender.MALE.name,
        0,
        4,
        noOfSteps.toInt());

    print('calaries burnt>> $kCal');

    /*controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
      setState(() {});
    });
    controller.repeat(reverse: true);*/

    /*animation = Tween(begin: 0,end: 80).animate(progressController)..addListener((){
      setState(() {

      });
    });*/

    /* animation = Tween<Offset>(
      begin: const Offset(100.0, 50.0),
      end: const Offset(200.0, 300.0),
    ).animate(progressController);*/

    super.initState();
    // ask for the permissions bluetooth, location, physical activities, location enable settings.
    // do the respective task

    /* progressController = AnimationController(
      vsync: this,
      value: progressPercentage,
      duration: const Duration(seconds: 5),
    )..addListener(() {
      setState(() {});
    });*/

    progressController = AnimationController(
        vsync: this,
        // lowerBound: -1.0,
        // upperBound: 1.0,
        duration: Duration(milliseconds: 800))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        print('anim status $status');
      });

    Tween _tween = Tween<double>(
      begin: 0,
      end: progressPercentage,
    );
    /*Tween _tween = new AlignmentTween(
           begin: new Alignment(0.0, 0.0),
        end: new Alignment(progressPercentage, 0.0),
      );*/
    _animation = _tween.animate(progressController);

    // progressController.value = progressPercentage;
    progressController.forward();
    print('progressController.value>> ${progressController.value.toString()}');
    print('animation.value>> ${_animation.value.toString()}');
    // print('animation.value>> ${double.parse(animation.value.toString())}');
  }

  @override
  void dispose() {
    progressController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        //title: Text('Vitals Health Summmary'),
        backgroundColor: Colors.white,
        //elevation: 2.0,
        title: Text('Wellness Summmary',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.watch_outlined, color: Colors.black),
            onPressed: () {
              // navigate to device connections & goals seetings
              Get.to(() => VitalSettings());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 8.0,
            ),
            Visibility(
              visible: true,
              child: Card(
                margin: EdgeInsets.all(8.0),
                elevation: 2.0,
                color:  Colors.white,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(4.0),
                  margin: EdgeInsets.all(2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text('Today', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0)),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    '${todayTime.day}, ${GlobalUtil.months[todayTime.month - 1]}, ${todayTime.year}',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {

                            },
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('Target Steps', style:  TextStyle(
                                        // color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),),
                                     /* Text('${GlobalUtil.formatNumber(GlobalUtil.totalTargetedSteps)}', style:  TextStyle(
                                       // fontWeight: FontWeight.w300,
                                       // color: Colors.grey.withOpacity(0.8),
                                        fontSize: 14.0,
                                      ),),*/
                                      Text('${GlobalUtil.formatNumber(GlobalUtil.totalTargetedSteps)}',
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300)
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Image.asset(
                                    'images/fit/goal.png',
                                    width: 32.0,
                                    height: 32.0,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                           /* child: IconTextWidget(
                              imagePath: 'images/fit/goal.png',
                              mainTitle: 'Goals',
                              subMainTitle: '10000',
                            ),*/
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 4.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Center(
                          child: CustomPaint(
                            foregroundPainter: CircleProgress(double.parse(_animation.value.toString())), // this will add custom painter after child
                            child: Container(
                              width: 150,
                              height: 150,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => VitalInDetail(displayTitle: Activity.STEPS.name, activityLabel: Activity.STEPS.textLabel,));
                                },
                                child: Center(
                                  child: Image.asset(
                                    'images/fit/running.png',
                                    width: 60.0,
                                    height: 60.0,
                                    fit: BoxFit.fill,
                                  ),
                                 /* child: Text(
                                    "${animation.value}%",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),*/
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {

                              Get.to(() => VitalInDetail( displayTitle: Activity.STEPS.name, activityLabel: Activity.STEPS.textLabel,));
                            },
                            child: IconTextWidget(
                              imagePath: 'images/fit/footsteps.png',
                              mainTitle: GlobalUtil.formatNumber(int.parse(noOfSteps.toStringAsFixed(0))),
                              subMainTitle: 'Steps',
                            ),
                          ),
                          Container(
                            height: 23.0,
                            child: VerticalDivider(
                              thickness: 1.0,
                              color: Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //Get.to(() => VitalInDetail( displayTitle: 'Distance'));
                              Get.to(() => VitalInDetail( displayTitle: Activity.DISTANCE.name, activityLabel: Activity.DISTANCE.textLabel,));
                            },
                            child: IconTextWidget(
                              imagePath: 'images/fit/speed.png',
                              //mainTitle: GlobalUtil.formatNumber(int.parse(noOfSteps.toStringAsFixed(0))),
                              mainTitle: '1.25',
                              subMainTitle: 'Km',
                            ),
                          ),
                          Container(
                            height: 23.0,
                            child: VerticalDivider(
                              thickness: 1.0,
                              color: Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //Get.to(() => VitalInDetail( displayTitle: 'Calories Burnt'));
                              Get.to(() => VitalInDetail( displayTitle: Activity.CAl.name, activityLabel: Activity.CAl.textLabel,));

                            },
                            child: IconTextWidget(
                              imagePath: 'images/fit/kcal.png',
                              //mainTitle: noOfSteps.toStringAsFixed(0),
                              mainTitle: '1,300',
                              subMainTitle: 'Kcal',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Last Synced : '),
                              Text('2021-09-12 03:45 PM'),
                              //Spacer(),
                              SizedBox(
                                width: 10.0,
                              ),
                              Icon(
                                Icons.sync,
                                color: Colors.black,
                                size: 18.0,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  fixedSize: Size(86.0, 16.0),
                                  primary: Colors.blue,
                                  //onSurface: Colors.red,
                                ),
                                onPressed: () {
                                  // fetch the latest data
                                  // also sync with the db & retrive.
                                },
                                child: Text(
                                  'Sync Now',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0),
                                ),
                              )
                              /*Row(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.sync,
                                    color: Colors.black,
                                    size: 20.0,
                                  ),

                                ],
                              )*/
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: true,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => AddDevice());
                  },
                  child: Card(
                    elevation: 2.0,
                    margin: EdgeInsets.all(4.0),
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.watch_sharp,
                            color: Colors.black,
                            size: 30.0,
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${GlobalUtil.addSmartWatchText}'),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
              child: GestureDetector(
                onTap: () {
                  //Get.to(() => VitalInDetail( displayTitle: 'Heart Rate'));
                },
                child: VitalDataWidget(
                  imagePath: 'images/fit/heart.png',
                  title: 'Heart Rate',
                  value: '-',
                  units: 'bpm',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
              child: GestureDetector(
                onTap: () {
                  //Get.to(() => VitalInDetail( displayTitle: 'Sleep Duration'));
                },
                child: VitalDataWidget(
                  imagePath: 'images/fit/sleep_time.png',
                  title: 'Sleep Duration',
                  value: '-', //5h 21 min
                  units: '',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
              child: GestureDetector(
                onTap: () {
                  //Get.to(() => VitalInDetail( displayTitle: 'Spo2'));
                },
                child: VitalDataWidget(
                  imagePath: 'images/fit/oxygen.png',
                  //imagePath: 'images/fit/oxygen_saturation.png',
                  title: 'Spo2',
                  value: '-',
                  units: '%',
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
              child: GestureDetector(
                onTap: () {
                  //Get.to(() => VitalInDetail( displayTitle: 'Blood Pressure'));

                },
                child: VitalDataWidget(
                  imagePath: 'images/fit/blood_pressure.png',
                  title: 'BP',
                  value: '-', //126/81 (range zero to 200 only 128 need to plot)
                  units: 'mmHg',
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
              child: GestureDetector(
                onTap: () {
                  //Get.to(() => VitalInDetail( displayTitle: 'Body Temperature'));
                },
                child: VitalDataWidget(
                  imagePath: 'images/fit/temperature_red.png',
                  //imagePath: 'images/fit/temperature.png',
                  title: 'Temperature',
                  value: '-', //126/81 (range zero to 200 only 128 need to plot)
                  units: '°C',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VitalDataWidget extends StatelessWidget {
  const VitalDataWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.value,
    required this.units,
  }) : super(key: key);

  final String imagePath;
  final String title;
  final String value;
  final String units;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(4.0),
      child: Container(
        padding: EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                imagePath,
                width: 40.0,
                height: 40.0,
                fit: BoxFit.fill,
              ),
            ),

            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(title, style:  TextStyle(
                            // color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.black,
                            size: 18.0,
                          ),
                        ],
                      ),
                      Text('$value $units'),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class IconTextWidget extends StatelessWidget {
  const IconTextWidget({
    Key? key,
    required this.imagePath,
    required this.mainTitle,
    required this.subMainTitle,
  }) : super(key: key);

  final String imagePath;
  final String mainTitle;
  final String subMainTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
       // mainAxisAlignment: MainAxisAlignment.center,
       // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.asset(
            imagePath,
            width: 40.0,
            height: 40.0,
            fit: BoxFit.fill,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(mainTitle, style:  TextStyle(
               // color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),),
              /*Text(subMainTitle, style:  TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.grey.withOpacity(0.8),
                fontSize: 14.0,
              ),),*/
              Text(subMainTitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300)
              ),


            ],
          ),
        ),
      ],
    );
  }
}
