part of spiro_sdk;


class SpiroDeviceList{

  String? status;
  List<SpiroDeviceType>? data;

  SpiroDeviceList({required this.status, required this.data});

  SpiroDeviceList.fromMap(Map<String, dynamic> json) {
    this.status = json['status'].toString();

    if (json['devices'] != null && json['devices'].length >0) {
      this.data = [];
      json['devices'].forEach((v) {
        print("in device>> $v");
        this.data!.add(SpiroDeviceType.fromJson(v));
      });
    } else {
      this.data = [];
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> formData = new Map<String, dynamic>();
    formData['status'] = this.status;
    formData['data'] = this.data!.map((v) => v.toJson()).toList();
    return formData;
  }

}


class SpiroDeviceType {
  final String index;
  final String name;
  final String alias;
  final String address;
  final String type;
  final String bondState;
  final String manufacture;

  const SpiroDeviceType({
    required this.index,
    required this.name,
    required this.alias,
    required this.address,
    required this.type,
    required this.bondState,
    required this.manufacture,
  });

  factory SpiroDeviceType.fromJson(Map<String, dynamic> data) => SpiroDeviceType(
      index: data['index'].toString(),
      name: data['name'].toString(),
      alias: data['alias'].toString(),
      address: data['address'].toString(),
      type: data['type'].toString(),
      bondState: data['bondState'].toString(),
      manufacture: data['manufacture'].toString(),
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> formData = new Map<String, dynamic>();
    formData['index'] = this.index;
    formData['name'] = this.name;
    formData['alias'] = this.alias;
    formData['address'] = this.address;
    formData['type'] = this.type;
    formData['bondState'] = this.bondState;
    formData['manufacture'] = this.manufacture;
    return formData;
  }

 /* @override
  // TODO: implement props
  List<Object> get props => [index, name, alias, address, type, bondState];

  @override
  bool get stringify => false;*/
}
