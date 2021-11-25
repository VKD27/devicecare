import 'package:devicecare_example/global/constants.dart';
import 'package:devicecare_example/watch/screens/vital_main.dart';
import 'package:devicecare_example/watch/screens/vital_screen.dart';
import 'package:devicecare_example/watch/utils/all_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const int heightMin = 90;
const int heightMax = 300;
const int weightMin = 20;
const int weightMax = 200;


class ProfileUpdate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // this class should be initialize whereever there is no data/ info about
    // like gender, birthday, height, weight.

    return ProfileUpdateState();
  }
}

class ProfileUpdateState extends State<ProfileUpdate> {
  late DateTime _selectedDate;
  late String _gender;
  late String _selectedHeight;
  late String _selectedWeight;

  List<String> defaultHeightList = [];
  List<String> defaultWeightList = [];

  @override
  void initState() {
    _selectedDate = DateTime.now();
    _gender = 'male';
    _selectedHeight = heightMin.toString(); // set the minimum values
    _selectedWeight = weightMin.toString(); // set the minimum values
    initializeHeight();
    initializeWeight();
    super.initState();

  }

  void initializeHeight() {
    for (int i = heightMin; i <= heightMax; i++) {
      defaultHeightList.add(i.toString());
    }
  }

  void initializeWeight() {
    for (int i = weightMin; i <= weightMax; i++) {
      defaultWeightList.add(i.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          //elevation: 1.0,
          centerTitle: true,
          title: Text(
            'Need a Profile Update',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text('Dear User,', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text('We need the below feilds to be updated, to proceed futher..!', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12.0,
              ),
              GestureDetector(
                onTap: () async {
                  String data = await selectGender(_gender);
                  if (data.isNotEmpty) {
                    setState(() {
                      _gender = data;
                      // _textEditingController.text = pickedDate.toString();
                    });
                  }
                  print('_selectedGender>> $_gender');
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Gender', style: TextStyle(fontSize: 16)),
                      Text(_gender.toUpperCase(),
                          style: TextStyle(
                              fontSize: 16, color: Colors.blueAccent)),
                    ],
                  ),
                ),
              ),
              Divider(// thickness: 1.0,
                  ),
              GestureDetector(
                onTap: () async {
                  // DateTime tempPickedDate =  DateTime.now();

                  DateTime data = await selectDate(_selectedDate);
                  if (data != DateTime.now()) {
                    setState(() {
                      _selectedDate = data;
                      // _textEditingController.text = pickedDate.toString();
                    });
                  }
                  print('_selectedDate>> $_selectedDate');

                  print('data>> $data');
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Date of Birth', style: TextStyle(fontSize: 16)),
                      Text(_selectedDate.toString().trim().split(' ')[0],
                          style: TextStyle(
                              fontSize: 16, color: Colors.blueAccent)),
                    ],
                  ),
                ),
              ),
              Divider(// thickness: 1.0,
                  ),
              GestureDetector(
                onTap: () async {

                  String data = await selectHeight(_selectedHeight);
                  if (data.isNotEmpty) {
                    setState(() {
                      _selectedHeight = data;
                      // _textEditingController.text = pickedDate.toString();
                    });
                  }
                  print('_selectedHeight>> $_selectedHeight');

                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Height', style: TextStyle(fontSize: 16)),
                      Text(_selectedHeight+' cm',
                          style: TextStyle(
                              fontSize: 16, color: Colors.blueAccent)),
                    ],
                  ),
                ),
              ),
              Divider(// thickness: 1.0,
                  ),
              GestureDetector(
                onTap: () async {
                  String data = await selectWeight(_selectedWeight);
                  if (data.isNotEmpty) {
                    setState(() {
                      _selectedWeight = data;
                      // _textEditingController.text = pickedDate.toString();
                    });
                  }
                  print('_selectedWeight>> $_selectedWeight');
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Weight', style: TextStyle(fontSize: 16)),
                      Text(_selectedWeight+' kg',
                          style: TextStyle(
                              fontSize: 16, color: Colors.blueAccent)),
                    ],
                  ),
                ),
              ),
              Divider(// thickness: 1.0,
                  ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          mini: true,
          onPressed: () {
            print('H: $_selectedHeight, W: $_selectedWeight,DOB: $_selectedDate, G: $_gender');
            Get.to(() => VitalMain());
          },
          tooltip: 'Save and Continue',
          child: Icon(Icons.done),
        ),
      ),
    );
  }

  Future<DateTime> selectDate(DateTime tempPickedDate) async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
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
                        Navigator.of(context).pop(tempPickedDate);
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
                  child: CupertinoDatePicker(
                    initialDateTime: tempPickedDate,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime dateTime) {
                      tempPickedDate = dateTime;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      return pickedDate;
    } else {
      return tempPickedDate;
    }
  }

  Future<String> selectGender(String tempSelectedDate) async {
    String? selectedGender = await showModalBottomSheet<String>(
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
                        Navigator.of(context).pop(tempSelectedDate);
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
                      print('value>> $value');
                      //tempSelectedDate
                      if (value == 1) {
                        tempSelectedDate = 'female';
                      } else {
                        tempSelectedDate = 'male';
                      }
                    },
                    selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(),
                    backgroundColor: Colors.white,
                    itemExtent: 28,
                    scrollController: FixedExtentScrollController(initialItem: tempSelectedDate == 'female' ? 1 : 0),
                    //itemExtent: 10,
                    children: [
                      Text('male'.toUpperCase()),
                      Text('female'.toUpperCase()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedGender != null && selectedGender != _gender) {
      return selectedGender;
    } else {
      return tempSelectedDate;
    }
  }

  Future<String> selectHeight(String tempSelectedHeight) async {
    String? selectedHeight = await showModalBottomSheet<String>(
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
                        Navigator.of(context).pop(tempSelectedHeight);
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
                      tempSelectedHeight = (value + heightMin).toString();
                    },
                    selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(),
                    backgroundColor: Colors.white,
                    itemExtent: 28,
                    scrollController: FixedExtentScrollController(initialItem: int.parse(tempSelectedHeight) - heightMin),
                    //itemExtent: 10,
                    children: defaultHeightList.map((e) => Text(e)).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedHeight != null && selectedHeight != _selectedHeight) {
      return selectedHeight;
    } else {
      return tempSelectedHeight;
    }
  }

  Future<String> selectWeight(String tempSelectedWeight) async {
    String? selectedWeight = await showModalBottomSheet<String>(
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
                        Navigator.of(context).pop(tempSelectedWeight);
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
                      tempSelectedWeight = (value + weightMin).toString();
                    },
                    selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(),
                    backgroundColor: Colors.white,
                    itemExtent: 28,
                    scrollController: FixedExtentScrollController(initialItem: int.parse(tempSelectedWeight) - weightMin),
                    //itemExtent: 10,
                    children: defaultWeightList.map((e) => Text(e)).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedWeight != null && selectedWeight != _selectedWeight) {
      return selectedWeight;
    } else {
      return tempSelectedWeight;
    }
  }
}

/*listOfColumns.map(
((element) => DataRow(
cells: <DataCell>[
DataCell(Text(element["name"]??'')), //Extracting from Map element the value
DataCell(Text(element["act"]??'')),
DataCell(Text(element["predict"]??'')),
],
)),
)
.toList(),*/

