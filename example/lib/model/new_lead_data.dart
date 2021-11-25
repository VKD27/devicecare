class NewLeadECGData {

  final String leadType;
  final List<String> leadData;
  final List<num> leadIntegerData;
  final String rangeMin;
  final String rangeMax;
  final String adAccuracy;
  final String heartValue;

  const NewLeadECGData({required this.leadType, required this.leadData, required this.rangeMin, required this.rangeMax, required this.leadIntegerData,  required this.adAccuracy, required this.heartValue,});
//required this.leadIntegerData
  factory NewLeadECGData.fromJson(Map<String, dynamic> data) {

    if(data['LeadData']!=null){

      String dataString = data['LeadData'][0].toString();

      List<String> dataList =  dataString.split(',');

      final List<num> newDataList = dataList.map((e){
        //String number = e.trim().replaceAll(' ', '');
        //return e as num;
        return num.parse(e);
      }).toList();


      print("dataList_length>> ${dataList.length}");
      print("dataList>> $dataList");

      return NewLeadECGData(
        leadType: data['LeadType'][0].toString(),
        leadData: dataList,
        leadIntegerData: newDataList,
        rangeMin: data['RangeMin'][0].toString(),
        rangeMax: data['RangeMax'][0].toString(),
        adAccuracy: data['AdAccuracy'][0].toString(),
        heartValue: data['HeartValue'][0].toString(),
      );
    }else{
      return NewLeadECGData(
        leadType: '',
        leadData: [],
        leadIntegerData: [],
        rangeMin: '',
        rangeMax: '',
        adAccuracy: '',
        heartValue: '',
      );
    }



  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> formData = new Map<String, dynamic>();
    formData['leadType'] = this.leadType;
    return formData;
  }

}
