import 'package:devicecare_example/watch/screens/add_device.dart';
import 'package:devicecare_example/watch/utils/global_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VitalSettings extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VitalSettingsState();
  }
  
}
class VitalSettingsState extends State<VitalSettings>{

  List<String> connectedDeviceList =[];

  List<String> savedDeviceList =[];

  bool deviceConnected = true;



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        //title: Text('Devices and Accounts'),
        backgroundColor: Colors.white,
        // elevation: 0,
        title: Text(
          'Devices and Accounts',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 4.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
              padding: EdgeInsets.only(left:8.0, top: 8.0,),
              child: Text('Connected Device', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16.0)),
            ),
            Visibility(
              visible: false,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                child: Card(
                  elevation: 2.0,
                  margin: EdgeInsets.all(8.0),
                  child: Container(
                    //margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                    padding: EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.watch_outlined,
                          color: Colors.black,
                          size: 30.0,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text('Device Identified Name',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text('02:04:0C:DE:15:48:45', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300)),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Visibility(
                                visible: deviceConnected,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    //fixedSize: Size(86.0, 16.0),
                                    primary: Colors.blue,
                                    //onSurface: Colors.red,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Disconnect',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        //decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: !deviceConnected,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    //fixedSize: Size(86.0, 16.0),
                                    primary: Colors.blue,
                                    //onSurface: Colors.red,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Connect',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        //decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),

            Visibility(
              visible: true,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                padding: EdgeInsets.only(left:8.0, top: 8.0,),
                  child: Column(
                    children: [
                      Center(child: Text('No devices are currently connected (you have not link a device)')),
                      GestureDetector(
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
                                    ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ), // you have not linked a device.
              ),
            ),

           /* Container(
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
              padding: EdgeInsets.only(left:8.0, top: 8.0,),
              child: Text('Saved Devices', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16.0)),
            ),

            Visibility(
              visible: true,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                // padding: EdgeInsets.only(left:8.0, top: 8.0,),
                child: Center(child: Text('No devices are currently saved')),
              ),
            ),*/

            Container(
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
              padding: EdgeInsets.only(left:8.0, top: 8.0,),
              child: Text('Link Apps & Services', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16.0)),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
              child: Card(
                elevation: 2.0,
                margin: EdgeInsets.all(8.0),
                child: Container(
                  //margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          'images/fit/gfit.png',
                          width: 30.0,
                          height: 30.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                     /* Icon(
                        Icons.fit_screen,
                        color: Colors.black,
                        size: 30.0,
                      ),*/
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text('Google Fit',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text('linked (email id) to display', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300)),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Visibility(
                              visible: deviceConnected,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  //fixedSize: Size(86.0, 16.0),
                                  primary: Colors.blue,
                                  //onSurface: Colors.red,
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Link',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      //decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !deviceConnected,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  //fixedSize: Size(86.0, 16.0),
                                  primary: Colors.blue,
                                  //onSurface: Colors.red,
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Link',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      //decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
              padding: EdgeInsets.only(left:8.0, top: 8.0,),
              child: Text('Settings', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16.0)),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
              child: Card(
                elevation: 2.0,
                margin: EdgeInsets.all(8.0),
                child: Container(
                 // margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          'images/fit/goal.png',
                          width: 30.0,
                          height: 30.0,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text('Goal',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(GlobalUtil.formatNumber(GlobalUtil.totalTargetedSteps)+' Steps', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
              child: Card(
                elevation: 2.0,
                margin: EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child:  Icon(
                          Icons.person_pin_outlined,
                          color: Colors.black,
                          size: 30.0,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text('Smart Profile',style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text('BMI: - '+' Athl: - ', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}