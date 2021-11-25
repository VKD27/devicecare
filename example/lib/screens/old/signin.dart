import 'package:devicecare_example/screens/old/profile_main.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:devicecare_example/global/constants.dart';


class SignIn extends StatefulWidget {
  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  final mobileController = TextEditingController();
  final passwordFieldController = TextEditingController();

 // String signInURL = Global.baseUrl + "users/wpUserLogin";

  // String userInfoURL = Settings.apiUrl + "users/user-info";

  bool passwordFieldObscureTextVisible = false;
  final _formKey = GlobalKey<FormState>();

  late String stEnteredMobileNum;
  var stRoleId;

  String appVersion = '';

  var options = ['Legal', 'Terms and Conditions', 'Support'];


  List<Environment> _environments = Environment.values;


  late Environment dropdownValue;

  @override
  void initState() {
    //dropdownValue = _environments[0];
    //VersionControl.instance!.getEnvironment.name;
    dropdownValue = VersionControl.instance!.getEnvironment;
    getEnvPrinted();
    super.initState();
  }

  loginUser(mobile, password) async {
   // VersionControl.instance!.isIndia()
   // String signInURL = VersionControl.instance!.getServerUrl + "users/wpUserLogin";
    String signInURL = VersionControl.instance!.getServerUrl + "users/signin";
    //VersionControl.instance!.getServerUrl +
    // print('fcm_token>> $fcm_token');
    var _body = <String, dynamic>{
      'login_id': mobile,
      'password': password,
    };

    print('login_url>> $signInURL');
    print('lodin_data>> $_body');

    final http.Response response = await http.post(
      Uri.parse(signInURL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        //'fcm_token': fcm_token,
        'platform': Platform.isIOS ? 'ios' : 'android'
      },
      body: jsonEncode(_body),
    );

    print('qwertyu>>> ${response.body}');

    if (response.statusCode == 200) {
      var authToken = response.headers['auth-token'];

      var responseBody = json.decode(utf8.decode(response.bodyBytes));

      stRoleId = responseBody['user']['user_role']['role_id'];
      print("stRoleId>> $stRoleId");
      /*if (responseBody['user'] != null &&
          responseBody['user']['isSeconday'] != null) {
        await Utils.setSecondaryAccount(responseBody['user']['isSeconday']);
      } else {
        await Utils.setSecondaryAccount(false);
      }*/

      /*if (stRoleId == 2) {
        authToken = authToken;
      } else {
        authToken = "Incorrect ID or Password";
      }*/

      return ['success', authToken];
    } else {
      return ['fail', "Incorrect ID or Password"];
    }
  }

  /* saveUserDetails(auth_token, fullName, pictureURL, userId, gender, email,
      mobileNum) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', auth_token);
    await prefs.setString('full_name', fullName);
    await prefs.setString('picture_url', pictureURL);
    await prefs.setInt('user_id', userId);
    await prefs.setString('gender', gender);
    await prefs.setInt('counter', 1);
    await prefs.setString('user_email', email);
    await prefs.setString('user_mobileNum', mobileNum);
  }*/

  /*fetchUserDetails(auth_token) async {
    String lang = await Utils.getLanguage();
    final http.Response response = await http.get(
      userInfoURL,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'auth_token': auth_token,
        'lang': lang
      },
    );

    print('userInfoURL >> $userInfoURL');

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody =
          json.decode(utf8.decode(response.bodyBytes));
      print('responseBody>> $responseBody');
      UserModel userDetails = new UserModel(responseBody);

      print("user> " + userDetails.corporate_id);
      if (userDetails.corporate_id.isEmpty ||
          userDetails.corporate_id == 'null') {
        // normal user
        userDetails.saveInfo();

        if (userDetails.parent != null) {
          Provider.of<FamilyMemberDetailsProvider>(context, listen: false)
              .setPrimaryUser(userDetails.parent);
        }

        String fullName = responseBody['fullName'] ?? '';
        String pictureURL = responseBody['picture'] ?? '';
        String gender = responseBody['gender'] ?? '';
        String mobileNumber = responseBody['phone_number'] ?? '';
        int userID = responseBody['id'] ?? 0;
        String email = responseBody['email'] ?? '';

        return [
          'Success',
          auth_token,
          fullName,
          pictureURL,
          userID,
          gender,
          email,
          mobileNumber
        ];
      } else {
        // corporate user
        return null;
      }
    } else {
      return ['Failed', response.statusCode.toString(), ''];
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('Login'),

        */ /*iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,*/ /*
      ),*/
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Sign In',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            /*child: Image.asset(
              'images/old/india_flag.png',
              height: 35,
              width: 35,
            ),*/
            child: DropdownButton<Environment>(
              value: dropdownValue,
              icon: Visibility(visible: false, child: Icon(Icons.arrow_downward)),
              iconSize: 0.0,
              //iconSize: 24,
              elevation: 12,
              style: const TextStyle(color: Colors.deepPurple),
              /*underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),*/
              underline: SizedBox(),
              onChanged: (Environment? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  VersionControl.instance!.setEnvironment(dropdownValue);
                });
                FocusScope.of(context).unfocus();
                print('after drop down changes');
                getEnvPrinted();
              },
              items: _environments.map<DropdownMenuItem<Environment>>((Environment value) {
                return DropdownMenuItem<Environment>(
                  value: value,
                  //child: Text(value.name),
                  child: Image.asset(
                    value.flag,
                    height: 35,
                    width: 35,
                  ),
                );
              }).toList(),
            ),
          )
        ],
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Enter your login credentials',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontFamily: 'TofinoPersonal-Book',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                top: 40,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'Mobile Number',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: TextFormField(
                                      controller: mobileController,
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        hintText: 'Enter Your Mobile Number',
                                      ),
                                      //maxLength: 10,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter mobile number to proceed';
                                        } /*else if (value.length < 10) {
                                          return 'Invalid mobile number';
                                        }*/

                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      'Password',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: TextFormField(
                                      controller: passwordFieldController,
                                      obscureText:
                                          !passwordFieldObscureTextVisible,
                                      decoration: InputDecoration(
                                        border: UnderlineInputBorder(),
                                        hintText: 'Enter your password',
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                              passwordFieldObscureTextVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Colors.black),
                                          onPressed: () {
                                            setState(() {
                                              passwordFieldObscureTextVisible =
                                                  !passwordFieldObscureTextVisible;
                                            });
                                          },
                                        ),
                                      ),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please provide password';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Global.showWaiting(context, false);
                        var mobile = mobileController.text.trim();
                        var password = passwordFieldController.text.trim();

                        FocusScope.of(context).unfocus();
                        var status = await loginUser(mobile, password);

                        print('status>> ${status[0]}');
                        print('auth_token>> ${status[1]}');

                        if (status[0].toString().trim() == 'success') {
                          String authToken = status[1].toString();

                          Navigator.pop(context);
                          //Get.to(()=>RecordsList(authToken: authToken));
                          Get.to(
                            () => ProfileMain(
                                authToken: authToken,
                                userName: '',
                                userPictureURL: '',
                                userGender: ''),
                          );
                        } else {
                          Navigator.pop(context);
                          Global.showAlertDialog(context, "Incorrect Details",
                              status[1].toString());
                        }
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF0BB8FC), // background
                      onPrimary: Colors.white, // foreground
                      onSurface: Color(0xFFCCCCCC),
                      textStyle: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 40),
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordView()),
                        );*/
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    )),
                Container(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpSA()),
                        );*/
                      },
                      child: Text(
                        "Don't have account? Sign up now",
                        style: TextStyle(
                          color: Colors.red[300],
                        ),
                      ),
                    )),
                Container(
                  height: 50.0,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        switch (index) {
                          case 0:
                            return InkWell(
                              onTap: () {
                                /* Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LegalScreen()),
                                );*/
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  options[index],
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            );
                          case 1:
                            return InkWell(
                              onTap: () {
                                /*Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoadOptionsContent(
                                        option: 'terms_and_condition',
                                        title: options[index],
                                      )),
                                );*/
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  options[index],
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            );
                          case 2:
                            return InkWell(
                              onTap: () {
                                //launch('https://docty.ai/support');
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  options[index],
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            );
                          default:
                            return Container();
                        }
                      },
                      separatorBuilder: (context, index) {
                        if (index < options.length - 1) {
                          return Text('|',
                              style: TextStyle(color: Colors.blue));
                        }
                        return Container();
                      },
                      itemCount: options.length),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Image.asset(VersionControl.instance!.getFlagPath,
                      height: 40,
                      width: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "V 1.0.0",
                        style:
                        TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void getEnvPrinted() {
    print('name: ${VersionControl.instance!.getEnvironment.name}');
    print('path: ${VersionControl.instance!.getFlagPath}');
    print('name: ${VersionControl.instance!.getServerUrl}');
  }
}
