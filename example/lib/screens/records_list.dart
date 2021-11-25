import 'package:devicecare_example/model/data_list_model.dart';
import 'package:devicecare_example/screens/detail_page.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:devicecare_example/global/constants.dart';


class RecordsList extends StatefulWidget{

  final String authToken;

  RecordsList({required this.authToken});

  @override
  State<StatefulWidget> createState() {
    return RecordsListState();
  }
  
}
class RecordsListState extends State<RecordsList>{

  // String fetchRegularData = Global.baseUrl + "patient/contecmed-api/general-xml";
  // String fetchEcgData = Global.baseUrl + "patient/contecmed-api/sync-ecgs";


  List<DataListModel> regularDataList = [];
  List<DataListModel> ecgDataList = [];

  bool showLoading = true;

  List<bool> isSelected = [true, false];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiateData();

  }

  void initiateData() async{
    await fetchRegularDataList();
    await fetchECGListData();
  }

  Future<void> fetchRegularDataList() async {

    String fetchRegularData = VersionControl.instance!.getServerUrl  + "patient/contecmed-api/general-xml";


    final http.Response response = await http.get(
      Uri.parse(fetchRegularData),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'auth_token': widget.authToken,
      },
    );
    print('fetchRegularDataUrl >>> $fetchRegularData');
    print('resultRegData>>> ${response.body}');
    if (response.statusCode == 200) {
     Map<String, dynamic> responseBody = jsonDecode(response.body);
    //  Map<String, dynamic> responseBody = tempData;

      var resultData = responseBody['data'];
      print('resultData>> $resultData');
      if (resultData != null) {
        List<DataListModel> dataList =[];
        for(int i=0;i< resultData.length;i++){
          DataListModel dataListModel = DataListModel.fromJson(resultData[i]);
          dataList.add(dataListModel);
        }
        setState(() {
          regularDataList = dataList;
          showLoading = false;
        });
      }else{
        // no data found
        setState(() {
          showLoading =false;
        });
      }

    }else{
      // no data found
      setState(() {
        showLoading =false;
      });
    }
  }

  Future<void> fetchECGListData() async {

    String fetchEcgData = VersionControl.instance!.getServerUrl  + "patient/contecmed-api/sync-ecgs";


    final http.Response response = await http.get(
      Uri.parse(fetchEcgData),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'auth_token': widget.authToken,
      },
    );

    print('fetchEcgDataUrl>>> $fetchEcgData');
    print('resultEcgData>>> ${response.body}');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
   // Map<String, dynamic> responseBody = tempData;
      var resultData = responseBody['data'];
      print('resultData>> $resultData');

      if (resultData != null) {
        List<DataListModel> dataList =[];
        for(int i=0;i< resultData.length;i++){
          DataListModel dataListModel = DataListModel.fromJson(resultData[i]);
          dataList.add(dataListModel);
        }
        setState(() {
          ecgDataList = dataList;
          showLoading =false;
        });
      }else{
        // no data found
        setState(() {
          showLoading =false;
        });
      }

    }else{
      // no data found
      setState(() {
        showLoading =false;
      });
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  toggleButtonForUpcomingOrPastAppointments() {
    return ToggleButtons(
      borderColor: Colors.blue,
      fillColor: Colors.blue,
      selectedColor: Colors.white,
      borderRadius: BorderRadius.circular(5),
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            child: Text('Regular'),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Text('ECG'),
          ),
        ),
      ],
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            isSelected[i] = i == index;
          }
        });
      },
      isSelected: isSelected,
    );
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        /*appBar: AppBar(
          title: const Text('Device Records'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Reg. Data'),
              Tab(text: 'ECG Data'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black38,
            indicatorColor: Colors.amberAccent,
          ),
        ),*/
        appBar: AppBar(
          title: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text('Reports',
                style: TextStyle(fontSize: 16, color: Colors.blue[800]),
              )),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(38.0),
            child: Theme(
              data: Theme.of(context).copyWith(primaryColor: Colors.white),
              child: Container(
                height: 38.0,
                margin: EdgeInsets.fromLTRB(30, 5, 30, 10),
                alignment: Alignment.center,
                child: toggleButtonForUpcomingOrPastAppointments(),
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xfff0f6f9),
        body: showLoading
            ? Center(
          child: CircularProgressIndicator(),
        ):Container(
            color: Colors.grey[300],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: checkAppointmentType(),
              /*child: TabBarView(
                children: [
                  regularContainer(),
                  ecgContainer()
                ],
              ),*/
            )),
      ),
    );
  }
  checkAppointmentType() {
    if (isSelected[0] == true) {
      return regularContainer();
    } else {
      return ecgContainer();
    }
  }

  Widget regularContainer() {
    return (regularDataList.length == 0)
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('No regular data found', textAlign: TextAlign.center),
        ],
      ),
    ) : RefreshIndicator(
      onRefresh: fetchRegularDataList,
      child: ListView.builder(
        itemCount: regularDataList.length,
        itemBuilder: (context, index) {
          DataListModel dataItem = regularDataList[index];

          //nextAvailSlot = DateFormat.jm().format(DateTime.parse(dataItem.timestamp).toLocal()).toString();

          return GestureDetector(
            onTap: () {
              Get.to(()=>DetailPage(isEcgData: false,dataId: dataItem.id, authToken: widget.authToken));
            },
            /*color: Colors.white,
            margin: EdgeInsets.all (2.0),
            padding:EdgeInsets.all (2.0),*/
            child: Card(
              color: Colors.white,
              margin: EdgeInsets.all (2.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [

                  Container(
                    child: ListTile(
                      leading: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            image: DecorationImage(
                              image:NetworkImage("https://www.concordmonitor.com/getattachment/04e0e875-c294-4d50-80e4-356c40969347/myturndouglas-cmforum-110119-ph01"),
                            ),
                            borderRadius: BorderRadius.circular(50),
                            border:
                            Border.all(color: Colors.blue, width: 2)),
                      ),
                      title: Text(dataItem.userData!.userName.toString()),
                      subtitle: Text('#'+dataItem.roomId,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      /*trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              cancelBooking(appointment);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                        ],
                      ),*/
                    ),
                  ),
                 /* Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Text('User: '),
                        Text(dataItem.userData!.userName.toString(), style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
                        Spacer(),
                        Expanded(child: Text('#'+dataItem.roomId, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),*/
                  Divider(
                    thickness: 1.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        padding: EdgeInsets.all(5.0),
                        child: Text('Date & Time',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5.0),
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Text('Executed By',
                          style: TextStyle(fontSize: 10),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5.0),
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 7),
                        child: Text(
                          dataItem.timestamp,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5.0),
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 7),
                        child: Text(dataItem.providerData!.userName.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 13),
                        ),
                      )
                    ],
                  ),
                  /*Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       // Expanded(child: Text('#'+dataItem.roomId, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),)),
                        Text('Dated on: '+dataItem.timestamp),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Text('Executed/Done By: '),
                        Text(dataItem.providerData!.userName.toString(), style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),*/
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget ecgContainer() {
    return (ecgDataList.length == 0)
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('No ecg data found', textAlign: TextAlign.center),
        ],
      ),
    ) : RefreshIndicator(
      onRefresh: fetchECGListData,
      child: ListView.builder(
        itemCount: ecgDataList.length,
        itemBuilder: (context, index) {
          DataListModel dataItem = ecgDataList[index];

          //nextAvailSlot = DateFormat.jm().format(DateTime.parse(dataItem.timestamp).toLocal()).toString();
          /*color: Colors.white,
          margin: EdgeInsets.all (2.0),
          padding:EdgeInsets.all (2.0),*/
          return GestureDetector(
            onTap: () {
              Get.to(()=>DetailPage(isEcgData: true,dataId: dataItem.id, authToken: widget.authToken));
            },
            child: Card(
              color: Colors.white,
              margin: EdgeInsets.all (2.0),
              //padding:EdgeInsets.all (2.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [

                  Container(
                    child: ListTile(
                      leading: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            image: DecorationImage(
                              image:NetworkImage("https://www.concordmonitor.com/getattachment/04e0e875-c294-4d50-80e4-356c40969347/myturndouglas-cmforum-110119-ph01"),
                            ),
                            borderRadius: BorderRadius.circular(50),
                            border:
                            Border.all(color: Colors.blue, width: 2)),
                      ),
                      title: Text(dataItem.userData!.userName.toString()),
                      subtitle: Text('#'+dataItem.roomId,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        padding: EdgeInsets.all(5.0),
                        child: Text('Date & Time',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5.0),
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Text('Executed By',
                          style: TextStyle(fontSize: 10),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5.0),
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 7),
                        child: Text(
                          dataItem.timestamp,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5.0),
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 7),
                        child: Text(dataItem.providerData!.userName.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 13),
                        ),
                      )
                    ],
                  ),
                 /* Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Text('User: '),
                        Text(dataItem.userData!.userName.toString(), style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
                        Spacer(),
                        Expanded(child: Text('#'+dataItem.roomId, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),*/
                  /*Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Expanded(child: Text('#'+dataItem.roomId, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),)),
                        Text('Dated on: '+dataItem.timestamp),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Text('Executed/Done By: '),
                        Text(dataItem.providerData!.userName.toString(), style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),*/
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  
}