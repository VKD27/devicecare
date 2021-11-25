import 'package:devicecare/spiro_sdk.dart';
import 'package:devicecare_example/global/global.dart';
import 'package:devicecare_example/screens/monitor_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'old/signin.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  late SpiroSdk spiroSdk;

  List<SpiroDeviceType> deviceList = [];

  bool showProgress = false;
  bool deviceConnected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var options = {};
    spiroSdk = SpiroSdk(options);

    spiroSdk.onDeviceCallbackData((res) {
      print("onDeviceCallbackData1 res: " + res.toString());

      if (res["id"] != null && res["id"] == SpiroSDKConstants.DC_DEVICE_CALLBACK) {
        var devices = res["devices"];
        //print("in home devices $devices");
        if (devices != null) {
          SpiroDeviceList spiroDeviceList =  SpiroDeviceList.fromMap(res);
          //SpiroDeviceList spiroDeviceList = SpiroDeviceList.fromMap(res);
          setState(() {
            deviceList = spiroDeviceList.data!;
            showProgress = false;
          });
          stopSearch();
        }
      }

      if (res["id"] != null && res["id"] == SpiroSDKConstants.DC_DEVICE_CONNECT) {
        Global.setValidateDeviceConnectivity(res, context, deviceConnected);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Device Care'),
        elevation: 1.5,
        actions: [
          IconButton(
            icon: Icon( Icons.refresh_outlined, color: Colors.white),
            onPressed: () {
              // refresh list
              getDeviceList();
              //navigateToNext();
            },
          ),
        ],
      ),
     body: Container(
       margin: const EdgeInsets.all(8.0),
         child: showDeviceContainer(deviceList),
     ),
     /* body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            *//*Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF0BB8FC), // background
                    onPrimary: Colors.white, // foreground
                    onSurface: Color(0xFFCCCCCC),
                    textStyle: TextStyle(fontSize: 18.0),
                  ),
                  onPressed: () {
                    callInitiation(context);
                  },
                  child: Text('Initialize', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),*//*
            showDeviceContainer(deviceList),
          ],
        ),
      ),*/
    );
  }

  Widget _deviceItem(int index) {
    SpiroDeviceType device = deviceList[index];
    return Container(
      margin: EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 1.0,
            spreadRadius: 0.0,
            offset: Offset(0.2, 0.2), // shadow direction: bottom right
          )
        ],
      ),
      child: ListTile(
        onTap: () {

          connectDevice(device);
        },
        /* subtitle:  Divider(
          color: Colors.grey,
        ),*/
        leading: Icon(
          Icons.bluetooth_audio_outlined,
          color: Colors.black,
        ),
        title: Text('${device.name}'),
        subtitle: Text('${device.address}'),
      ),
    );

    /*return ListTile(
      onTap: onTap,
      trailing:menuList[index].hasNavigation ? Icon(Icons.keyboard_arrow_right_outlined, size: 30):Container(),
      title: Text(menuList[index].title, style: TextStyle(
        // fontWeight: FontWeight.w500,
          fontSize: 16.0
      )),
      // subtitle: Text('allow user'),
      leading: Icon(menuList[index].icon, size: 30),
    );*/
  }

  Future<void> callInitiation(BuildContext context) async {
    // check all the permissions
    bool status = await checkAllPermissions();

    dynamic initState = await spiroSdk.initializeSdk();

    print('permission status $status');
    print('permission initState $initState');

    if (status && initState) {
      getDeviceList();
    }else{
      // show message
      Global.showAlertDialog(context, "Permissions","Please enable location and the Bluetooth connectivity.");
    }

    /*if (status && initState) {
      Get.to(()=>DeviceList());
    } else {
      print('permission in else');
    }*/
  }

  Future<void> getDeviceList() async {
    try {
      setState(() {
        showProgress = true;
      });
      bool? startDeviceSearch = await spiroSdk.startSearchingDevices();
      print('startDeviceSearch $startDeviceSearch');
    } catch (e) {
      print('exception:: $e');
    }
  }

  Future<bool> checkAllPermissions() async {
    var location = await Permission.locationWhenInUse.status;
    var bluetooth = await Permission.bluetooth.status;

    print('location $location');
    print('bluetooth $bluetooth');

    if (location.isGranted && bluetooth.isGranted) {
      return true;
    } else {
      //  await  Permission.bluetooth.request();
      // await Permission.location.request();
      //return false;
      if (await Permission.locationWhenInUse.request().isGranted &&
          await Permission.bluetooth.request().isGranted) {
        return true;
      } else {
        return false;
      }
    }
  }

 /* Future<bool> _checkDeviceLocationIsOn() async {
    return await Permission.locationWhenInUse.serviceStatus.isEnabled;
  }

  Future<bool> _checkDeviceBluetoothIsOn() async {
    return await FlutterBlue.instance.isOn;
  }*/

  Widget showDeviceContainer(List<SpiroDeviceType> deviceList) {
    if (showProgress) {
      return Center(child: CircularProgressIndicator());
    } else {
      if (deviceList.length > 0) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          //padding: const EdgeInsets.all(2.0),
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) => const Divider(),
            itemCount: deviceList.length,
            itemBuilder: (BuildContext context, int index) {
              return _deviceItem(index);
            },
          ),
        );
      } else {
        return Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF0BB8FC), // background
                    onPrimary: Colors.white, // foreground
                    onSurface: Color(0xFFCCCCCC),
                    textStyle: TextStyle(fontSize: 18.0),
                  ),
                  onPressed: () {
                    Get.to(()=>SignIn());
                  },
                  child: Text('Login to Fetch Data', style: TextStyle(color: Colors.white)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF0BB8FC), // background
                    onPrimary: Colors.white, // foreground
                    onSurface: Color(0xFFCCCCCC),
                    textStyle: TextStyle(fontSize: 18.0),
                  ),
                  onPressed: () {
                    Get.to(()=>MonitorData());
                  },
                  child: Text('Fetch Monitor Data HMS7500', style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF0BB8FC), // background
                    onPrimary: Colors.white, // foreground
                    onSurface: Color(0xFFCCCCCC),
                    textStyle: TextStyle(fontSize: 18.0),
                  ),
                  onPressed: () {
                    callInitiation(context);
                  },
                  child: Text('Initialize & Search Devices',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text('No Devices Found'),
            ],
          ),
        );
      }
    }
  }

  Future<void> connectDevice(SpiroDeviceType device) async {
    bool startDeviceSearch = await spiroSdk.connectWithDevice(device);
    print('connectDevice $startDeviceSearch');
    if (!startDeviceSearch) {
      // show the message
      Global.showAlertDialog(context, "Connection","You can't connect this device, since it's invalid device.");

    }else{
      setState(() {
        deviceConnected = startDeviceSearch;
      });
    }
  }

  Future<void> stopSearch() async {
    bool? stopDeviceSearch = await spiroSdk.stopSearchingDevices();
    print('stopDeviceSearch $stopDeviceSearch');
  }
}