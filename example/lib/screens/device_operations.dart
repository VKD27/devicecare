import 'package:devicecare/spiro_sdk.dart';
import 'package:devicecare_example/global/global.dart';
import 'package:devicecare_example/model/callback_device_response.dart';
import 'package:devicecare_example/model/predicted_data.dart';
import 'package:devicecare_example/screens/view_readings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceOperation extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return DeviceOperationState();
  }
  
}
class DeviceOperationState extends State<DeviceOperation>{

  SpiroSdk spiroSdk = SpiroSdk({});

  late PredictedData predictedData;
  List<PredictedData> actualData =[];
  List<WaveData> waveData =[];

  late CallBackResultList callBackResultList;


  @override
  void initState() {
    super.initState();
    spiroSdk.onDeviceCallbackData((res) {
      try {

        print("onDeviceCallbackData2 res: " + res.toString());

        if (res["id"] != null && res["id"] == SpiroSDKConstants.DC_DEVICE_CONNECT) {
          Global.setValidateDeviceConnectivity(res, context, false);
        }

        if (res["id"] != null && res["id"] == SpiroSDKConstants.DC_DEVICE_OPERATIONS) {

          String status = res['status'].toString();
          if (status != null && status.isNotEmpty) {
            // success, failure
            if (res['data'] != null) {

              switch (status) {
                case SpiroSDKConstants.DC_SUCCESS:
                  //var data = res['data'];
                  //print("inside >> ${res["data"]}");
                  Map<String, dynamic> data = res['data'];
                 // print('data>> $data');

                  if (data['deleteData'] != null && data['deleteData'].toString() == "true") {

                    Global.showAlertDialog(context, "Device Operation", "Cleared all the old data.");

                  } else if (data['getData'] != null && data['getData'].toString() == 'true') {

                    if (data['data'] != null) {
                      var resultData = data['data'];

                      print('resultData>> $resultData');

                      if (resultData != null) {

                        CallBackResultList callBackList = CallBackResultList.fromMap(resultData);

                        setState(() {
                          callBackResultList = callBackList;
                          predictedData = callBackResultList.predictedData!;
                          actualData = callBackResultList.actualData!;
                          waveData = callBackResultList.waveData!;
                        });

                        print('predictedData>> $predictedData');
                        print('actualData>> $actualData');
                      }
                    }
                  }

                  break;
                case SpiroSDKConstants.DC_FAILURE:
                  Global.showAlertDialog(context, "Device Operation", "The respective device operation failed.");
                  break;
              }
            }
          }
        }


      }catch(e){
        print('exception:: $e');
      }

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Operations'),
      ),
      body:  SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(2.0),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton(
                    style:  ElevatedButton.styleFrom(
                      primary: Color(0xFF0BB8FC), // background
                      onPrimary: Colors.white,// foreground
                      onSurface: Color(0xFFCCCCCC),
                      textStyle: TextStyle(fontSize: 18.0),
                    ),
                    onPressed: () {
                      deletePrevData();
                    },
                    child: Text('Delete Prev. Data', style: TextStyle(color: Colors.white)),
                  ),
                  Spacer(),
                  ElevatedButton(
                    style:  ElevatedButton.styleFrom(
                      primary: Color(0xFF0BB8FC), // background
                      onPrimary: Colors.white,// foreground
                      onSurface: Color(0xFFCCCCCC),
                      textStyle: TextStyle(fontSize: 18.0),
                    ),
                    onPressed: () {
                      setUserParams();
                    },
                    child: Text('Set User Data', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style:  ElevatedButton.styleFrom(
                primary: Color(0xFF0BB8FC), // background
                onPrimary: Colors.white,// foreground
                onSurface: Color(0xFFCCCCCC),
                textStyle: TextStyle(fontSize: 18.0),
              ),
              onPressed: () {
                fetchDeviceData();
              },
              child: Text('Get Device Data', style: TextStyle(color: Colors.white)),
            ),
            showResultContainer(actualData, waveData),
            (actualData.length >0)
             ? Container(
                color: Colors.white,
                height: 50.0,
                width: double.infinity,
                // margin: const EdgeInsets.all(2.0),
                // padding: const EdgeInsets.all(2.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF0BB8FC),
                    onPrimary: Colors.white, // foreground
                    onSurface: Color(0xFFCCCCCC),
                    textStyle: TextStyle(fontSize: 18.0),
                  ),
                  onPressed: () {

                  },
                  child: Text('Submit Details', style: TextStyle(
                      color: Colors.white)),
                ),
              )
                : Container()
          ],
        ),
      ),
    );
  }


  Widget showResultContainer(List<PredictedData> actualData, List<WaveData> waveData ) {

    if (actualData.length > 0) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
       // padding: const EdgeInsets.all(2.0),
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          itemCount: actualData.length,
          itemBuilder: (BuildContext context, int index) {

            PredictedData actData = actualData[index];
            WaveData wavePositionedData = waveData[index];

            return Card(
              margin: const EdgeInsets.all(2.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Review : ${index+1}'),
                        ),
                      ],
                    ),
                    _dataItem(actData),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Dated on : '+Global.getDateBind(actData.date)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.blue,
                              //onSurface: Colors.red,
                            ),
                            onPressed: (){
                              navigateToViewMore(predictedData,actData, wavePositionedData, index+1);

                            },
                            child: Text('View More', style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            );
          },
        ),
      );
    } else {
      return Center(child: Text('No Data Found'));
    }
  }


  Future<void> setUserParams() async {

    Map<String, String> userParameters = <String, String>{};
    userParameters['measureMode'] = MeasureMode.ALL.name;
    userParameters['sex'] = Sex.FEMALE.name;
    userParameters['smoke'] = Smoke.NOSMOKE.name;
    userParameters['weight'] = "65"; // in kgs
    userParameters['height'] = "173"; //cms
    userParameters['age'] = "27";

    bool userDataStatus = await spiroSdk.setUserParamsInfo(userParameters);
    print('userDataSet >> $userDataStatus');
  }

  Future<void> deletePrevData() async {
    bool deleteStatus = await spiroSdk.deleteDeviceData();
    print('deleteStatus >> $deleteStatus');
  }

  Future<void> fetchDeviceData() async {
    bool getDataStatus = await spiroSdk.getDeviceData();
    print('getDataStatus >> $getDataStatus');
  }


  Widget _dataItem(PredictedData actData) {

   // PredictedData actData = actualData[index];

    ShowPredictedTitle title = ShowPredictedTitle();

    final List<Map<String, String>> listOfColumns = [
      {"name": title.fvc, "act": actData.fvc+' (L)', "predict": predictedData.fvc+' (L)'},
      {"name": title.fev1, "act": actData.fev1+' (L)', "predict": predictedData.fev1+' (L)'},
      {"name": title.pef, "act": actData.pef+' (L/s)', "predict": predictedData.pef+' (L/s)'},
    ];

    return DataTable(
      columns: [
        DataColumn(label: Text('Params')),
        DataColumn(label: Text('Actual')),
        DataColumn(label: Text('Predicted')),
      ],
      rows: listOfColumns.map(
        ((element) => DataRow(
          cells: <DataCell>[
            DataCell(Text(element["name"]??'')), //Extracting from Map element the value
            DataCell(Text(element["act"]??'')),
            DataCell(Text(element["predict"]??'')),
          ],
        )),
      )
          .toList(),
    );
  }


  void navigateToViewMore(PredictedData predictedData, PredictedData actData, WaveData wavePositionedData, int reviewCount) {

    Get.to(()=>ViewReadings(predictedData,actData,wavePositionedData, reviewCount));
  }
}