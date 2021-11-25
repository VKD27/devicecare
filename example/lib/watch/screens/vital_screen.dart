import 'package:devicecare_example/global/constants.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class VitalScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VitalScreenState();
  }
  
}
class VitalScreenState extends State<VitalScreen>{

  List<HealthDataPoint> _healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;


  List<dynamic> stepsDataList = [];


  /// Fetch data from the health plugin and print it
  Future fetchData() async {
    // get everything from midnight until now
    DateTime startDate = DateTime(2021, 10, 15, 0, 0, 0);
    DateTime endDate = DateTime(2021, 11, 02, 0, 0, 0);

    DateTime endDateTime = DateTime.now();

    var fiftyDaysFromNow = endDateTime.subtract(const Duration(days: 50));


    HealthFactory health = HealthFactory();

    // define the types to get
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.BODY_MASS_INDEX,
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.BLOOD_GLUCOSE,
     // HealthDataType.DISTANCE_WALKING_RUNNING,
    ];

    setState(() => _state = AppState.FETCHING_DATA);
    print('setState $_state');
    // you MUST request access to the data types before reading them
    bool accessWasGranted = await health.requestAuthorization(types);
    print('accessWasGranted $accessWasGranted');
    int steps = 0;

    if (accessWasGranted) {
      try {
        // fetch new data
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(fiftyDaysFromNow, endDateTime, types);
        print('healthData $healthData');
        // save all the new data points
        _healthDataList.addAll(healthData);
      } catch (e) {
        print("exception in fetching data: $e");
        print("Caught exception in getHealthDataFromTypes: $e");
      }

      // filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

      String _tempDate ='';
      int tempValue = 0;
      // print the results
      _healthDataList.forEach((x) {
        print("Data point: $x");
        steps += x.value.round();
        if (x.type ==  HealthDataType.STEPS) {
          List<String> str = x.dateTo.toString().trim().split(' ');

          if (_tempDate.isEmpty) {
            //for the first time value
            _tempDate = str[0];
            tempValue = x.value.round();
          } else if (str[0] == _tempDate) {
            //second time on same date
            tempValue += x.value.round();
          } else {
            //save the result then set it with new value
            var xData = {
              'date': _tempDate.toString(),
              'value': tempValue.toString()
            };
            stepsDataList.add(xData);

            tempValue = 0;
            // if it not equals then reset the values
            _tempDate = str[0];
            tempValue = x.value.round();
          }
        }
        /*if (x.type ==  HealthDataType.STEPS) {

          List<String> str = x.dateFrom.toString().trim().split(' ');
          var xData = {'date':str[0].toString(),'value':x.value.round()};
          stepsDataList.add(xData);

        }*/

      });

      print("Steps: $steps");
      print("stepsDataList: $stepsDataList");
      print("stepsDataListLenght: ${stepsDataList.length}");

      // update the UI to display the results
      setState(() {
        _state = _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      });



    } else {
      print("Authorization not granted");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  List<DateTime> calculateDaysInterval(dynamic dateMap) {
    var startDate = dateMap["start"];
    var endDate = dateMap["end"];
    print(startDate.toString());
    print(endDate.toString());

    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }

    /* for (var i=0; i<days.length; i++) {
    print(days[i]);
  }*/
    return days;
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              strokeWidth: 10,
            )),
        Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReady() {
    print('_healthDataList_length ${_healthDataList.length}');
    return ListView.builder(
      shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: _healthDataList.length,
        itemBuilder: (_, index) {
          HealthDataPoint p = _healthDataList[index];
          return ListTile(
            title: Text("${p.typeString}: ${p.value}"),
            trailing: Text('${p.unitString}'),
            subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
          );
        });
  }

  Widget _contentNoData() {
    return Text('No Data to show');
  }

  Widget _contentNotFetched() {
    return Text('Press the download button to fetch data');
  }

  Widget _authorizationNotGranted() {
    return Text('''Authorization not given.
        For Android please check your OAUTH2 client ID is correct in Google Developer Console.
         For iOS check your permissions in Apple Health.''');
  }

  Widget _content() {
    print('content_state $_state');
    if (_state == AppState.DATA_READY)
      return _contentDataReady();
    else if (_state == AppState.NO_DATA)
      return _contentNoData();
    else if (_state == AppState.FETCHING_DATA)
      return _contentFetchingData();
    else if (_state == AppState.AUTH_NOT_GRANTED)
      return _authorizationNotGranted();

    return _contentNotFetched();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // checkPermissions();
  }

  Future<void> checkPermissions() async {
    if (Platform.isAndroid) {
      final permissionStatus = Permission.activityRecognition.request();
      final sensorStatus = Permission.sensors.request();
      if (await permissionStatus.isDenied || await permissionStatus.isPermanentlyDenied) {
        print('activityRecognition permission required to fetch your steps count');
       // return;
      }

      if (await sensorStatus.isDenied || await sensorStatus.isPermanentlyDenied) {
        print('activityRecognition permission denial sensorStatus');
        // return;
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Operations'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              fetchData();
            },
          )
        ],
      ),
      body: Center(
        child: _content(),
      )
      /*body:  SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _content(),
          ],
        ),
      ),*/
    );
  }


  
}



enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED
}

