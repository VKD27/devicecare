import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewActualDetails extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ViewActualDetailsState();
  }
  
}
class ViewActualDetailsState extends State<ViewActualDetails>{

  String textRecommendations ='Recommendations:';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Read More'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text('Know Your blood pressure readings',  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'images/bp01.png',
                width: double.infinity,
                height: 240.0,
                fit: BoxFit.fill,
              ),
            ),
            ListTile(
              leading:  MyBullet(),
              title:  Text('Normal Blood Pressure'),
              subtitle: Text(textRecommendations+'Healthy lifestyle choices and yearly checks.'),
            ),
            ListTile(
              leading: new MyBullet(),
              title: new Text('Elevated Blood Pressure'),
              subtitle: Text(textRecommendations+'Healthy lifestyle changes, reassessed in 3-6 months.'),
            ),
            ListTile(
              leading: new MyBullet(),
              title: new Text('High Blood Pressure / STAGE 1'),
              subtitle: Text(textRecommendations+'10-year heart disease & stroke risk assessment. If less than 10% risk, lifestyle changes, reassessed in 3-6 months. If higher, lifestyle changes and medication with monthly follow-ups until blood pressurer is controlled.'),
            ),
            ListTile(
              leading: new MyBullet(),
              title: new Text('High Blood Pressure / STAGE 2'),
              subtitle: Text(textRecommendations+'Lifestyle changes and 2 differrent classes of medicine, with monthly follow-ups until blood pressure is controlled.'),
            ),

            Container(
              //margin: EdgeInsets.all(4.0),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('If less than NORMAL BP & equal to or greater than HIGH BP, Recommenned to consult our doctor immediately.', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  )),
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

                      },
                      child: Text('Consult a Doctor', style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
             // margin: EdgeInsets.all(4.0),
              child: Image.asset(
                'images/temp01.png',
                width: double.infinity,
                height: 210.0,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              //margin: EdgeInsets.all(4.0),
              child: Image.asset(
                'images/hr01.png',
                width: double.infinity,
                height: 210.0,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}

class MyBullet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.0,
      width: 12.0,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}