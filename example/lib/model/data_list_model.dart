class DataListModel {
  final String id, userId, roomId, timestamp, phoneNumber;
  ProviderData? providerData;
  UserData? userData;

  DataListModel(
      {required this.id,
      required this.userId,
      required this.roomId,
      required this.timestamp,
      required this.phoneNumber,
      required this.providerData,
      required this.userData
      });

  factory DataListModel.fromJson(Map<String, dynamic> data) {
    //print('each data >>> $data');
    return DataListModel(
      id: data['id'].toString().trim(),
      userId: data['user_id'].toString().trim(),
      roomId: data['room_id'].toString().trim(),
      timestamp: data['timestamp'].toString().trim(),
      phoneNumber: data['phone_number'].toString().trim(),
      providerData: ProviderData.fromJson(data['provider']),
      userData: UserData.fromJson(data['user']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> formData = new Map<String, dynamic>();
    formData['id'] = this.id;
    formData['user_id'] = this.userId;
    formData['room_id'] = this.roomId;
    formData['timestamp'] = this.timestamp;
    formData['phone_number'] = this.phoneNumber;
    formData['provider'] = this.providerData!.toJson();
    formData['user'] = this.userData!.toJson();
    return formData;
  }
}

class ProviderData {
  final String id, userName;

  const ProviderData({required this.id, required this.userName});

  factory ProviderData.fromJson(Map<String, dynamic> data) {
    return ProviderData(
      id: data['id'].toString().trim(),
      userName: data['UserName'].toString().trim(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> formData = new Map<String, dynamic>();
    formData['id'] = this.id;
    formData['UserName'] = this.userName;
    return formData;
  }
}

class UserData {
  final String id, userName;
  const UserData({required this.id, required this.userName});

  factory UserData.fromJson(Map<String, dynamic> data) {
    return UserData(
      id: data['id'].toString().trim(),
      userName: data['first_name'].toString().trim()+' '+data['last_name'].toString().trim(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> formData = new Map<String, dynamic>();
    formData['id'] = this.id;
    formData['UserName'] = this.userName;
    return formData;
  }
}