import 'package:devicecare_example/screens/old/home_screen.dart';
import 'package:flutter/material.dart';

class ProfileMain extends StatefulWidget{

  final String userName;
  final String userGender;
  final String userPictureURL, authToken;

  ProfileMain({required this.userName,required this.userPictureURL,required this.userGender,required this.authToken});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileMainState();
  }
  
}
class ProfileMainState extends State<ProfileMain>{

  int selectedPageIndex = 0;


  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  getPage(BuildContext context) {
    if (selectedPageIndex == 0) {
      return HomeScreen(userName: widget.userName, userPictureURL: widget.userPictureURL, userGender: widget.userGender, authToken: widget.authToken);
    } else if (selectedPageIndex == 1) {
      return HomeScreen(userName: widget.userName, userPictureURL: widget.userPictureURL, userGender: widget.userGender, authToken: widget.authToken);
    } else if (selectedPageIndex == 2) {
      return HomeScreen(userName: widget.userName, userPictureURL: widget.userPictureURL, userGender: widget.userGender, authToken: widget.authToken);
    } else if (selectedPageIndex == 3) {
      return HomeScreen(userName: widget.userName, userPictureURL: widget.userPictureURL, userGender: widget.userGender, authToken: widget.authToken);
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: getPage(context),
      bottomNavigationBar: BottomNavigationBar(
         // key: Utils.globalKey,
          onTap: selectPage,
          backgroundColor: Colors.white,
          currentIndex: selectedPageIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: selectedPageIndex == 0 ? Image.asset('images/old/home_page/ic_home_selected.png',
                scale: 1.4,
              )
                  : Image.asset('images/old/home_page/ic_home.png', scale: 1.4),

              title: Text(
                // Utils.tr(context, 'string_main_home') == null ? "string_main_home" : Utils.tr(context, 'string_main_home'),
                'Home',
                style: TextStyle(
                    color: selectedPageIndex == 0
                        ? Colors.deepOrangeAccent
                        : Colors.black),
              ),
            ),
            BottomNavigationBarItem(
              icon: selectedPageIndex == 1
                  ? Image.asset('images/old/home_page/ic_doctors_selected.png',
                  scale: 1.4)
                  : Image.asset('images/old/home_page/ic_doctors.png', scale: 1.4),
              title: Text(
                'Search',
                style: TextStyle(
                    color: selectedPageIndex == 1
                        ? Colors.deepOrangeAccent
                        : Colors.black),
              ),
            ),
            BottomNavigationBarItem(
              icon: selectedPageIndex == 2
                  ? Image.asset('images/old/home_page/ic_appts_selected.png',
                  scale: 1.4)
                  : Image.asset('images/old/home_page/ic_appts.png', scale: 1.4),
              title: Text(
                'My Appts',
                style: TextStyle(
                    color: selectedPageIndex == 2
                        ? Colors.deepOrangeAccent
                        : Colors.black),
              ),
            ),
            BottomNavigationBarItem(
              icon: selectedPageIndex == 3
                  ? Image.asset('images/old/home_page/ic_profile_selected.png',
                  scale: 1.4)
                  : Image.asset('images/old/home_page/ic_profile.png', scale: 1.4),
              title: Text(
                'Profile',
                style: TextStyle(
                    color: selectedPageIndex == 3
                        ? Colors.deepOrangeAccent
                        : Colors.black),
              ),
            ),
          ]),
    );
  }
  
}