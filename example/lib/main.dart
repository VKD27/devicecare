
// import 'package:devicecare_example/screens/home_page.dart';
import 'package:devicecare_example/screens/old/signin.dart';
import 'package:devicecare_example/watch/screens/profile_update.dart';
import 'package:devicecare_example/watch/screens/vital_screen.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
//import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:devicecare_example/global/constants.dart';

void main() {

  // set the environment and do the respective
  VersionControl({'environment':Environment.IND.name});

  runApp(MyApp());
  //runApp(HomePage());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.rightToLeft,
      //translations: MyTranslations(),
      locale: Get.deviceLocale,
      debugShowCheckedModeBanner: false,
     // home: HomePage(),
     // home: SignIn(),
     // home: VitalScreen(),
      home: ProfileUpdate(),
      /*home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return SignIn();
             // return HomePage();
            }
            return BluetoothOffScreen(state: state);
          },
      ),*/
    );
  }
}

/*class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context).primaryTextTheme.subtitle1?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}*/
/*class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await DeviceCare.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}*/
