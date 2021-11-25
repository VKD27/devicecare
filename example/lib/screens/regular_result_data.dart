import 'package:devicecare_example/screens/view_actual_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


const bloodPressure = "bloodPress";
const bloodGlucose = "bloodGlucose";
const bloodOxygenSPo2 = "bloodOxygen";
const heightWeight = "heightWeight";
const temperature = "temperature";
const urineRoutine = "urineRoutine";
const uricAcid = "uricAcid";

const List<String> ecgNameList = ['I','II','III', 'AVR','AVL','AVF','V1','V2','V3','V4','V5','V6'];

class RegularResultData extends StatefulWidget{

  final List<dynamic> resultData;
  final String timeStamp;

  RegularResultData({required this.resultData, required this.timeStamp});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegularResultDataState();
  }
  
}
class RegularResultDataState extends State<RegularResultData>{

  List<Map<String, String>> listOfColumns = [];

  bool isUrineRoutine = false;
  String urineRoutineData = "";
  List<Map<String, String>> userUrineData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('widget.resultData>> ${widget.resultData}');
    if (widget.resultData.length > 0) {
      for (var data in widget.resultData) {
        String itemType = data['ItemType'].toString();
        var itemData = data['ItemData'];
        if (itemType.isNotEmpty) {
          switch (itemType) {
            case bloodPressure:
              Map<String, String> bp = {
                "name": "BP",
                "value": itemData['SBP'].toString() + '/' + itemData['DBP'].toString() + ' (mmHg)',
                "units": ''
              };
              listOfColumns.add(bp);
              break;

            case heightWeight:
              Map<String, String> height = {
                "name": "Height",
                "value": itemData['Height'].toString() + ' (cm)',
                "units": ''
              };
              Map<String, String> weight = {
                "name": "Weight",
                "value": itemData['Weight'].toString() + ' (kg)',
                "units": ''
              };
              Map<String, String> bmi = {
                "name": "BMI",
                "value": itemData['BMI'].toString() + ' (kg/m2)',
                "units": ''
              };
              listOfColumns.add(height);
              listOfColumns.add(weight);
              listOfColumns.add(bmi);
              break;

            case uricAcid:
              Map<String, String> temp = {
                "name": "Uric Acid",
                "value": itemData['Ua'].toString() + ' (pH)',
                "units": ''
              };
              listOfColumns.add(temp);
              break;

            case temperature:
              Map<String, String> temp = {
                "name": "Temperature",
                "value": itemData['Thermometer'].toString() + ' °C',
                "units": ''
              };
              listOfColumns.add(temp);
              break;

            case bloodGlucose:
            //for india
              double bData = 18 *
                  double.parse(itemData['BloodGlucose'].toString().trim());

              Map<String, String> glu = {
                "name": "Blood Glucose (Glu)",
                "value": itemData['BloodGlucose'].toString() +
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
                "value": itemData['BloodOxygen'].toString() + ' %',
                "units": ''
              };
              Map<String, String> pulseRate = {
                "name": "Pulse Rate",
                "value": itemData['PulseRate'].toString(),
                "units": ''
              };
              listOfColumns.add(spo2);
              listOfColumns.add(pulseRate);
              break;

            case urineRoutine:
              String urineData = "LEU : " +
                  itemData['LEU'].toString() +
                  "\n" +
                  "PH: " +
                  itemData['PH'].toString() +
                  ",\n" +
                  "NIT: " +
                  itemData['NIT'].toString() +
                  ",\n" +
                  "GLU: " +
                  itemData['GLU'].toString() +
                  ",\n" +
                  "PRO: " +
                  itemData['PRO'].toString() +
                  ",\n" +
                  "VC: " +
                  itemData['VC'].toString() +
                  ",\n" +
                  "SG: " +
                  itemData['SG'].toString() +
                  ",\n" +
                  "UBG: " +
                  itemData['UBG'].toString() +
                  ",\n" +
                  "LRY: " +
                  itemData['LRY'].toString() +
                  ",\n" +
                  "KET: " +
                  itemData['KET'].toString() +
                  ",\n" +
                  "BU: " +
                  itemData['BU'].toString();
              urineRoutineData = urineData;

              Map<String, String> leu = {
                "name": "LEU",
                "value": itemData['LEU'].toString()
              };
              Map<String, String> ph = {
                "name": "PH",
                "value": itemData['PH'].toString()
              };
              Map<String, String> nit = {
                "name": "NIT",
                "value": itemData['NIT'].toString()
              };
              Map<String, String> glu = {
                "name": "GLU",
                "value": itemData['GLU'].toString()
              };
              Map<String, String> pro = {
                "name": "PRO",
                "value": itemData['PRO'].toString()
              };
              Map<String, String> vc = {
                "name": "VC",
                "value": itemData['VC'].toString()
              };
              Map<String, String> sg = {
                "name": "SG",
                "value": itemData['SG'].toString()
              };
              Map<String, String> ubg = {
                "name": "UBG",
                "value": itemData['UBG'].toString()
              };
              Map<String, String> lry = {
                "name": "LRY",
                "value": itemData['LRY'].toString()
              };
              Map<String, String> ket = {
                "name": "KET",
                "value": itemData['KET'].toString()
              };
              Map<String, String> bu = {
                "name": "BU",
                "value": itemData['BU'].toString()
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
      }
      setState(() {

      });

    }else{
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      // padding: const EdgeInsets.all(2.0),
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
          TextButton(
            onPressed: () {
              Get.to(()=>ViewActualDetails());
            },
            child: Text('Read Safety Measures (Actual Details)'),
          ),
        ],
      ),
    );
  }
}

Widget showItemData(List<Map<String, String>> listOfColumns) {
  return DataTable(
    columns: [
      DataColumn(label: Text('Categories')),
      DataColumn(label: Text('Readings Values')),
      // DataColumn(label: Text('Predicted')),
    ],
    rows: listOfColumns
        .map(
      ((element) => DataRow(
        cells: <DataCell>[
          DataCell(Text(element["name"] ?? '')),
          //Extracting from Map element the value
          DataCell(Text(
            element["value"] ?? '',
            softWrap: true,
          )),
          // DataCell(Text(element["units"]??'')),
        ],
      )),
    )
        .toList(),
  );
}

Widget showUrineAnalysisData(String urineRoutineData, List<Map<String, String>> userUrineData) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Urine Analysis',
          softWrap: true,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 4.0,
      ),
      //Text(urineRoutineData),
      ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) =>
        const Divider(),
        itemCount: userUrineData.length,
        itemBuilder: (BuildContext context, int index) {
          var actData = userUrineData[index];
          return Container(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(actData['name'].toString() + ' : '),
                Spacer(),
                Text(actData['value'].toString()),
                /*Container(
                    child: Text(actData['name'].toString()+': '),
                    //margin: const EdgeInsets.all(2.0),
                   // padding: const EdgeInsets.all(2.0),
                  ),
                  Container(
                    child: Text(actData['value'].toString()),
                   // margin: const EdgeInsets.all(2.0),
                  ),*/
              ],
            ),
          );
        },
      ),
      SizedBox(
        height: 4.0,
      ),
    ],
  );
}