import 'package:devicecare_example/model/predicted_data.dart';

class CallBackResultList {
  PredictedData? predictedData;
  List<PredictedData>? actualData;
  List<WaveData>? waveData;

  CallBackResultList({required this.predictedData, required this.actualData});

  CallBackResultList.fromMap(Map<String, dynamic> json) {
    this.predictedData = PredictedData.fromJson(json['predictedData']);

    if (json['fvcData'] != null && json['fvcData'].length > 0) {
      this.actualData = [];
      json['fvcData'].forEach((v) {
        // print("in fvc device>> $v");
        this.actualData!.add(PredictedData.fromJson(v));
      });
    } else {
      this.actualData = [];
    }

    if (json['waveData'] != null && json['waveData'].length > 0) {
      this.waveData = [];
      json['waveData'].forEach((v) {
        print("in waveData device>> $v");
        this.waveData!.add(WaveData.fromJson(v));
        print('wave list ${this.waveData}');
      });
    } else {
      this.waveData = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> formData = new Map<String, dynamic>();
    formData['predictedData'] = this.predictedData;
    formData['fvcData'] = this.actualData!.map((v) => v.toJson()).toList();
    return formData;
  }
}
