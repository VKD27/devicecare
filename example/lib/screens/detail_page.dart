import 'package:devicecare_example/model/new_lead_data.dart';
import 'package:devicecare_example/screens/regular_result_data.dart';
import 'package:devicecare_example/screens/view_actual_details.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:devicecare_example/global/constants.dart';


class DetailPage extends StatefulWidget{

  final bool isEcgData;
  final String dataId;
  final String authToken;

  DetailPage({required this.isEcgData, required this.dataId, required this.authToken});


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DetailPageState();
  }
  
}
class DetailPageState extends State<DetailPage>{

  // String fetchRegDataID = Global.baseUrl + "patient/contecmed-api/general-xml/";
  // String fetchEcgDataID = Global.baseUrl + "patient/contecmed-api/sync-ecgs/";

  //regular data items
  List<Map<String, String>> listOfColumns = [];
  bool isUrineRoutine = false;
  String urineRoutineData = "";
  List<Map<String, String>> userUrineData = [];

  //for ecg data
  List<NewLeadECGData> ecgLeadList = [];



  bool showLoading = true;


  @override
  void initState() {
    super.initState();
    initiateData();
  }

  void initiateData() async{
    if(widget.isEcgData){
      await fetchECGData();
    }else{
      await fetchRegularData();
    }
  }

  Future<void> fetchRegularData() async {

   // VersionControl.instance!.getServerUrl +

    String fetchRegDataID = VersionControl.instance!.getServerUrl + "patient/contecmed-api/general-xml/";

    print('fetchRegDataIDUrl>>> $fetchRegDataID');

    final http.Response response = await http.get(
      Uri.parse(fetchRegDataID+widget.dataId),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'auth_token': widget.authToken,
      },
    );
    print('resultRegData>>> ${response.body}');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);

      print('responseBody>>> $responseBody');

     // String timestp = responseBody['data']['timestamp']??'';
      var result = responseBody['data']['item_data'];

      print('result>> $result');
      doRegularDataSorting(result);

    }else{
      // no data found
      setState(() {
        showLoading =false;
      });
    }
  }



  Future<void> fetchECGData() async {

    String fetchEcgDataID = VersionControl.instance!.getServerUrl + "patient/contecmed-api/sync-ecgs/";

    print('fetchEcgDataIDUrl>>$fetchEcgDataID');

    print('widget.dataId>>${widget.dataId}');
   // Global.showWaiting(context, false);
    final http.Response response = await http.get(
      Uri.parse(fetchEcgDataID+widget.dataId),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'auth_token': widget.authToken,
      },
    );
    print('resultRegData>>> ${response.body}');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (responseBody['data']!=null) {
        var result = responseBody['data']['ecg_lead_list'];

        if (result != null) {

          for(int i=0;i< result.length;i++){

            NewLeadECGData ecgData =  NewLeadECGData.fromJson(result[i]);
            if(ecgData.leadType.isNotEmpty) {
              ecgLeadList.add(NewLeadECGData.fromJson(result[i]));
            }
          }

          setState(() {
            showLoading = false;
          });
        }else{
          setState(() {
            showLoading = false;
          });
        }

      }else{
        setState(() {
          showLoading = false;
        });
      }


    }else{
      setState(() {
        showLoading = false;
      });
    }

   // Navigator.pop(context);
  }

  void doRegularDataSorting(result) {
    if (result != null) {
      for(int i=0;i< result.length;i++){

        var item = result[i];

        print('item $item');
        print('ItemType ${item['ItemType'][0].toString()}');
        switch(item['ItemType'][0].toString()){
          case bloodPressure:
            Map<String, String> bp = {
              "name": "BP",
              "value": item['ItemData'][0]['SBP'][0].toString() + '/' + item['ItemData'][0]['DBP'][0].toString() + ' (mmHg)',
              "units": ''
            };
            listOfColumns.add(bp);
            break;

          case heightWeight:
            Map<String, String> height = {
              "name": "Height",
              "value": item['ItemData'][0]['Height'][0].toString() + ' (cm)',
              "units": ''
            };
            Map<String, String> weight = {
              "name": "Weight",
              "value": item['ItemData'][0]['Weight'][0].toString() + ' (kg)',
              "units": ''
            };
            Map<String, String> bmi = {
              "name": "BMI",
              "value": item['ItemData'][0]['BMI'][0].toString() + ' (kg/m2)',
              "units": ''
            };
            listOfColumns.add(height);
            listOfColumns.add(weight);
            listOfColumns.add(bmi);
            break;

          case uricAcid:
            Map<String, String> temp = {
              "name": "Uric Acid",
              "value": item['ItemData'][0]['Ua'][0].toString() + ' (pH)',
              "units": ''
            };
            listOfColumns.add(temp);
            break;

          case temperature:
            Map<String, String> temp = {
              "name": "Temperature",
              "value": item['ItemData'][0]['Thermometer'][0].toString() + ' °C',
              "units": ''
            };
            listOfColumns.add(temp);
            break;

          case bloodGlucose:
          //for india
            double bData = 18 * double.parse(item['ItemData'][0]['BloodGlucose'][0].toString().trim());

            Map<String, String> glu = {
              "name": "Blood Glucose (Glu)",
              "value": item['ItemData'][0]['BloodGlucose'][0].toString() +
                  ' (mmol/L) \n' +
                  bData.toString() +
                  ' (mg/dl)',
              "units": ''
            };
            listOfColumns.add(glu);
            break;

          case bloodOxygenSPo2:
            Map<String, String> spo2 = {
              "name": "Blood Oxygen (SPo2)",
              "value": item['ItemData'][0]['BloodOxygen'][0].toString() + ' %',
              "units": ''
            };
            Map<String, String> pulseRate = {
              "name": "Pulse Rate",
              "value": item['ItemData'][0]['PulseRate'][0].toString(),
              "units": ''
            };
            listOfColumns.add(spo2);
            listOfColumns.add(pulseRate);
            break;

          case urineRoutine:
            String urineData = "LEU : " +
                item['ItemData'][0]['LEU'][0].toString() +
                "\n" +
                "PH: " +
                item['ItemData'][0]['PH'][0].toString() +
                ",\n" +
                "NIT: " +
                item['ItemData'][0]['NIT'][0].toString() +
                ",\n" +
                "GLU: " +
                item['ItemData'][0]['GLU'][0].toString() +
                ",\n" +
                "PRO: " +
                item['ItemData'][0]['PRO'][0].toString() +
                ",\n" +
                "VC: " +
                item['ItemData'][0]['VC'][0].toString() +
                ",\n" +
                "SG: " +
                item['ItemData'][0]['SG'][0].toString() +
                ",\n" +
                "UBG: " +
                item['ItemData'][0]['UBG'][0].toString() +
                ",\n" +
                "LRY: " +
                item['ItemData'][0]['LRY'][0].toString() +
                ",\n" +
                "KET: " +
                item['ItemData'][0]['KET'][0].toString() +
                ",\n" +
                "BU: " +
                item['ItemData'][0]['BU'][0].toString();
            urineRoutineData = urineData;

            Map<String, String> leu = {
              "name": "LEU",
              "value": item['ItemData'][0]['LEU'][0].toString()
            };
            Map<String, String> ph = {
              "name": "PH",
              "value": item['ItemData'][0]['PH'][0].toString()
            };
            Map<String, String> nit = {
              "name": "NIT",
              "value": item['ItemData'][0]['NIT'][0].toString()
            };
            Map<String, String> glu = {
              "name": "GLU",
              "value": item['ItemData'][0]['GLU'][0].toString()
            };
            Map<String, String> pro = {
              "name": "PRO",
              "value": item['ItemData'][0]['PRO'][0].toString()
            };
            Map<String, String> vc = {
              "name": "VC",
              "value": item['ItemData'][0]['VC'][0].toString()
            };
            Map<String, String> sg = {
              "name": "SG",
              "value": item['ItemData'][0]['SG'][0].toString()
            };
            Map<String, String> ubg = {
              "name": "UBG",
              "value": item['ItemData'][0]['UBG'][0].toString()
            };
            Map<String, String> lry = {
              "name": "LRY",
              "value": item['ItemData'][0]['LRY'][0].toString()
            };
            Map<String, String> ket = {
              "name": "KET",
              "value": item['ItemData'][0]['KET'][0].toString()
            };
            Map<String, String> bu = {
              "name": "BU",
              "value": item['ItemData'][0]['BU'][0].toString()
            };

            userUrineData.add(leu);
            userUrineData.add(ph);
            userUrineData.add(nit);
            userUrineData.add(glu);
            userUrineData.add(pro);
            userUrineData.add(vc);
            userUrineData.add(sg);
            userUrineData.add(ubg);
            userUrineData.add(lry);
            userUrineData.add(ket);
            userUrineData.add(bu);
            // listOfColumns.add(urineRoutine);
            isUrineRoutine = true;
            break;

          default:
            break;

        }

      }
      setState(() {
        // this.resultDataJson = deviceData;
        // this.timestamp = timestp;
        showLoading =false;
      });
    }else{
      // no data found
      setState(() {
        showLoading =false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.isEcgData?'ECG Data':'Regular Data',  style: TextStyle(fontSize: 16, color: Colors.blue[800])),
        iconTheme: IconThemeData(color: Colors.black, ),
      ),
      body:  showLoading
          ? Center(
        child: CircularProgressIndicator(),
      ):getDataWidget(),

      /*:SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: getDataWidget(),
        *//*child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            getDataWidget()
          ],
        ),*//*
      ),*/
    );
  }

  Widget getDataWidget() {
    if(widget.isEcgData){
      return (ecgLeadList.length == 0)
          ? Center(
         child: Text('No ecg data found', textAlign: TextAlign.center),
        /*child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('No ecg data found', textAlign: TextAlign.center),
          ],
        ),*/
      ) :SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            children: [
              SizedBox(
                height: 8.0,
              ),
              ListView.builder(
                shrinkWrap: true,
                //physics: ClampingScrollPhysics(),
                physics: NeverScrollableScrollPhysics(),
                //scrollDirection: Axis.horizontal,
                itemCount: ecgLeadList.length,

                itemBuilder: (BuildContext context,int index) {

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(ecgLeadList[index].leadType+'\n(${ecgNameList[index]})'),
                      ),
                      Expanded(
                        child: Container(
                          //margin: EdgeInsets.all(4.0),
                            padding: const EdgeInsets.all(4.0),
                            // width: double.infinity*3,
                            height: 180,
                            child: SfSparkLineChart(
                              data: ecgLeadList[index].leadIntegerData,
                              axisLineWidth: 0.0,
                            )
                        ),
                      ),
                    ],
                  );
                },
              ),
            ]
        ),
      );


    }else{
      //margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      // padding: const EdgeInsets.all(2.0),
      return  (listOfColumns.length == 0 && !isUrineRoutine)
          ? Center(
        child: Text('No regular data found', textAlign: TextAlign.center),
       /* child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('No regular data found', textAlign: TextAlign.center),
          ],
        ),*/
      ) :SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            showItemData(listOfColumns),
            SizedBox(
              height: 4.0,
            ),
            if (isUrineRoutine)
              showUrineAnalysisData(urineRoutineData, userUrineData),
            SizedBox(
              height: 4.0,
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Get.to(()=> ViewActualDetails());
                },
                child: Text('Read Safety Measures (Actual Details)'),
              ),
            ),
          ],
        ),
      );
    }
  }

}