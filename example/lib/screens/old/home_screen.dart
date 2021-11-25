import 'package:devicecare_example/global/version_control.dart';
import 'package:devicecare_example/screens/records_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String userGender;
  final String userPictureURL,authToken;

  HomeScreen(
      {required this.userName,
      required this.userPictureURL,
      required this.userGender,
      required this.authToken,
      });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        // key: _scaffoldKey,
        appBar: AppBar(
          title: Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            width: double.infinity,
            child: Text(
              'Welcome!',
              style: TextStyle(fontSize: 16, color: Colors.blue[800]),
            ),
            alignment: Alignment.center,
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          leading: IconButton(
            icon: Icon(Icons.menu),
            color: Colors.blue,
            onPressed: () {
              //_scaffoldKey.currentState.openDrawer();
            },
          ),
          actions: <Widget>[
            SizedBox(
              width: 40,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Color(0xfff0f6f9),
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'How do you feel today?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  alignment: Alignment.center,
                  child: Text(
                    'Let Docty help you decide what option is best for you',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Visibility(
                  visible: VersionControl.instance!.isIndia()?false:true,
                 // visible: (index > -1) ? true : false,
                  child: Container(
                    margin: EdgeInsets.only(top: 8),
                    child: ClipRect(
                      child: Container(
                        color: Colors.white,
                        height: 170,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 8,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: Image.asset('images/old/home_page/comment.png'),
                                      decoration: BoxDecoration(
                                          color: Color(0xFF0bb8fc),
                                          shape: BoxShape.circle),
                                    ),
                                    onTap: () {
                                      /*if (index > -1) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatsScreen(
                                              healthAdvisorList[index]
                                                  .advisorCompName,
                                              healthAdvisorList[index].clinic_id,
                                              currentUserDetails.userId,
                                              0,
                                            ),
                                          ),
                                        );
                                      }*/
                                    },
                                  ),
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFf1f1f1),
                                        shape: BoxShape.circle),
                                    child: Image.asset('images/old/home_page/ic_my_doctors.png'),/*(index > -1)
                                        ? FadeInImage.assetNetwork(
                                        placeholder: 'images/old/home_page/ic_my_doctors.png',
                                        image: healthAdvisorList[index].advisorPic ?? '')
                                        :,*/
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: Image.asset('images/old/home_page/phone_call.png'),
                                      decoration: BoxDecoration(
                                          color: Color(0xFF0bb8fc),
                                          shape: BoxShape.circle),
                                    ),
                                    onTap: () async {
                                      /*if (index > -1) {
                                        var url =
                                            "tel:${healthAdvisorList[index].support_phone}";
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      }*/
                                    },
                                  )
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 8,
                            ), //SizedBox
                            Text('Ora Clinics Chains',
                              /*(index > -1)
                                  ? healthAdvisorList[index].advisorCompName
                                  : */
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold), //TextStyle
                            ),
                          ], //<Widget>[]
                        ), //Padding
                      ), //Banner
                    ), //ClipRect
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.16,
                  child: Card(
                    color: Color(0xff2786fb),
                    child: InkWell(
                      onTap: () => {
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SysmtomCheckUp(
                              callingScreen: "Symptom",
                            ),
                          ),
                        )*/
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            height: 20,
                            width: 25,
                            child: Image.asset(
                              "images/old/home_page/request_doctor.png",
                            ),
                          ),
                          Expanded(
                              child: SizedBox(
                                  child: Container(
                                      child: Text(
                            'Check Symptoms',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          )))),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.16,
                  child: Card(
                    color: Color(0xffffb822),
                    child: InkWell(
                      onTap: () async {
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CovidSymptomUser()),
                        );*/
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            height: 20,
                            width: 25,
                            child: Image.asset(
                              "images/old/home_page/virus-white.png",
                            ),
                          ),
                          Expanded(
                              child: SizedBox(
                                  child: Container(
                            child: Text(
                              'Covid 19 Self Checker',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          )))
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.16,
                  child: Card(
                    color: Color(0xffed3b5a),
                    child: InkWell(
                      onTap: () async {
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SysmtomCheckUp()),
                        );*/
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            height: 20,
                            width: 25,
                            child: Image.asset(
                              "images/old/home_page/request_first_aid.png",
                            ),
                          ),
                          Expanded(
                              child: SizedBox(
                                  child: Container(
                            child: Text(
                              'Consult Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          )))
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.16,
                  child: Card(
                    color: Color(0xff00897B),
                    child: InkWell(
                      onTap: () async {
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SysmtomCheckUp()),
                        );*/

                        Get.to(()=>RecordsList(authToken: widget.authToken));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            height: 20,
                            width: 25,
                            child: Image.asset(
                              "images/old/home_page/request_hospital.png",
                            ),
                          ),
                          Expanded(
                              child: SizedBox(
                                  child: Container(
                                    child: Text(
                                      'Lab Reports',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  )))
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.16,
                  child: Card(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyAppsScreen()),
                        );*/
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    'Scheduled Consultations',
                                    style: TextStyle(
                                        fontSize: 18, color: Color(0xff7e7e7e)),
                                  )),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text('0',
                                  style: TextStyle(
                                      fontSize: 18, color: Color(0xff7e7e7e))),
                              Icon(Icons.keyboard_arrow_right)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.16,
                  child: Card(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewFamilyMemberList()),
                        );*/
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  'Family Members',
                                  style: TextStyle(
                                      fontSize: 18, color: Color(0xff7e7e7e)),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text('0',
                                  style: TextStyle(
                                      fontSize: 18, color: Color(0xff7e7e7e))),
                              Icon(Icons.keyboard_arrow_right)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.16,
                  child: Card(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        /*  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListFavouriteDoctors()),
                        );*/
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  'My favorites',
                                  style: TextStyle(
                                      fontSize: 18, color: Color(0xff7e7e7e)),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text('0',
                                  style: TextStyle(
                                      fontSize: 18, color: Color(0xff7e7e7e))),
                              Icon(Icons.keyboard_arrow_right)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.16,
                  child: Card(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        /*  Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyRetailClinic()),
                        );*/
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  'Retail Clinic',
                                  style: TextStyle(
                                      fontSize: 18, color: Color(0xff7e7e7e)),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text('0',
                                  style: TextStyle(
                                      fontSize: 18, color: Color(0xff7e7e7e))),
                              Icon(Icons.keyboard_arrow_right)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.16,
                  child: Card(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        /*  Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HealthAdvisor()),
                        );*/
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  'Health Advisor',
                                  style: TextStyle(
                                      fontSize: 18, color: Color(0xff7e7e7e)),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text('0',
                                  style: TextStyle(
                                      fontSize: 18, color: Color(0xff7e7e7e))),
                              Icon(Icons.keyboard_arrow_right)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                /* missingProfile
                    ? Container(
                  padding: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    color: Color(0xFFFFF9E7),
                    child: InkWell(
                      onTap: () {
                        final BottomNavigationBar navigationBar =
                            Utils.globalKey.currentWidget;
                        navigationBar.onTap(3);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            height: 25,
                            width: 25,
                            child: Image.asset(
                              "images/old/missing_info.png",
                            ),
                          ),
                          Container(
                              child: Expanded(
                                  child: Text(
                                    Utils.tr(context,
                                        'string_homescreen_profile_missing_information'),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                          Icon(Icons.keyboard_arrow_right)
                        ],
                      ),
                    ),
                  ),
                )
                    : Container(),*/
              ],
            ),
          ),
        ));
  }
}
