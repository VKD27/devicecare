class ECGLeadData {

  final String leadType;
  final List<String> leadData;
  final List<num> leadIntegerData;
  final String rangeMin;
  final String rangeMax;
  final String adAccuracy;
  final String heartValue;

  const ECGLeadData({required this.leadType, required this.leadData, required this.rangeMin, required this.rangeMax, required this.leadIntegerData,  required this.adAccuracy, required this.heartValue,});
//required this.leadIntegerData
  factory ECGLeadData.fromJson(Map<String, dynamic> data) {
    String dataString = data['LeadData'].toString();
    List<String> dataList = dataString.split(',');

    final List<num> newDataList = dataList.map((e){
     //String number = e.trim().replaceAll(' ', '');
      //return e as num;
      return num.parse(e);
    }).toList();

    print("dataList_length>> ${dataList.length}");
    print("dataList>> $dataList");

    return ECGLeadData(
      leadType: data['LeadType'].toString(),
      leadData: dataList,
      leadIntegerData: newDataList,
      rangeMin: data['RangeMin'].toString(),
      rangeMax: data['RangeMax'].toString(),
      adAccuracy: data['AdAccuracy'].toString(),
      heartValue: data['HeartValue'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> formData = new Map<String, dynamic>();
    formData['leadType'] = this.leadType;
    return formData;
  }
}
