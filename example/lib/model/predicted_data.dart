
class ShowPredictedTitle {
  String fvc = 'FVC';
  String fev1 = 'FEV1';
  String fev1Fvc = 'FEV1/FVC';
  String pef = 'PEF';
  String fef25 = 'FEF25';
  String fef50 = 'FEF50';
  String fef75 = 'FEF75';
  String fef2575 = 'FEF2575';
  String peft = 'PEFT';
  String evol = 'EVOL';
  String date = 'date';
}

class PredictedData {

  final String fvc, fev1, fev1Fvc, pef, fef25, fef50, fef75, fef2575, fev3, fev6, peft, evol, date;

  const PredictedData({
    required this.fvc,
    required this.fev1,
    required this.fev1Fvc,
    required this.pef,
    required this.fef25,
    required this.fef50,
    required this.fef75,
    required this.fef2575,
    required this.fev3,
    required this.fev6,
    required this.peft,
    required this.evol,
    required this.date,
  });

  factory PredictedData.fromJson(Map<String, dynamic> data) => PredictedData(
        fvc: data['fvc'].toString(),
        fev1: data['fev1'].toString(),
        fev1Fvc: data['fev1Fvc'].toString(),
        pef: data['pef'].toString(),
        fef25: data['fef25'].toString(),
        fef50: data['fef50'].toString(),
        fef75: data['fef75'].toString(),
        fef2575: data['fef2575'].toString(),
        fev3: data['fev3'].toString(),
        fev6: data['fev6'].toString(),
        peft: data['peft'].toString(),
        evol: data['evol'].toString(),
        date: data['date'].toString(),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> formData = new Map<String, dynamic>();
    formData['fvc'] = this.fvc;
    formData['fev1'] = this.fev1;
    formData['fev1Fvc'] = this.fev1Fvc;
    formData['pef'] = this.pef;
    formData['fef25'] = this.fef25;
    formData['fef50'] = this.fef50;
    formData['fef75'] = this.fef75;
    formData['fef2575'] = this.fef2575;
    formData['fev3'] = this.fev3;
    formData['fev6'] = this.fev6;
    formData['peft'] = this.peft;
    formData['evol'] = this.evol;
    formData['date'] = this.date;
    return formData;
  }
}

class WaveData {
  final String count;
  final List<double> time;
  final List<double> speed;
  final List<double> volume;

  const WaveData({
    required this.count,
     required this.time,
     required this.speed,
     required this.volume
  });


  factory WaveData.fromJson(Map<String, dynamic> data) {

    String count = data['count'].toString();
    /*print('count>> ${count}');

    var times = data['time'];
    var speeds = data['speed'];
    var volumes = data['volume'];

    print('time>> $times');
    print('speed>> $speeds');
    print('volume>> $volumes');

    print('time length>> ${times.length}');
    print('times me>> ${List<double>.from(times)}');
*/
    return WaveData(
      count: count,
      // time:  data['time'].map((e)=>double.parse(e)).toList(),
      // speed:  data['speed'].map((e)=>double.parse(e)).toList(),
      // volume:  data['volume'].map((e)=>double.parse(e)).toList(),
      time: new List<double>.from(data['time']),
      speed: new List<double>.from(data['speed']),
      volume: new List<double>.from(data['volume']),
    );

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> formData = new Map<String, dynamic>();
    formData['count'] = this.count;
    // formData['time'] = this.time;
    // formData['speed'] = this.speed;
    // formData['volume'] = this.volume;
    return formData;
  }
}
