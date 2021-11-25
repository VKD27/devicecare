import 'package:flutter/material.dart';

class AddDevice extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddDeviceState();
  }
  
}
class AddDeviceState extends State<AddDevice>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  // onresume please cross check the permissions

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
       // title: Text('Add Device'),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Add Device',
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
          IconButton(
            icon: Icon(Icons.refresh_outlined, color: Colors.black),
            onPressed: () {

            },
          ),
        ],
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
                      child: Text('DoctyM SmartWatch', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text('Please select your docty smart watch in the petition list', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 4.0,
            ),
            Center(
              child: Text('Searching for docty smartwatch...', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
            )

          ],
        ),
      ),
    );
  }
  
}