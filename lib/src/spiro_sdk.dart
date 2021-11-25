part of spiro_sdk;

class SpiroSdk {

  // ignore: close_sinks
 /* StreamController? _afGCDStreamController;
  // ignore: close_sinks
  StreamController? _afUDLStreamController;
  // ignore: close_sinks
  StreamController? _afOpenAttributionStreamController;
  // ignore: close_sinks
  StreamController? _afValidtaPurchaseController;*/


  EventChannel _eventChannel;
  static SpiroSdk? _instance;
  final MethodChannel _methodChannel;

  Map? mapOptions;

  ///Returns the [SpiroSdk] instance, initialized with a custom options
  ///provided by the user
  factory SpiroSdk(options) {
    if (_instance == null) {
      MethodChannel methodChannel = const MethodChannel(SpiroSDKConstants.DC_METHOD_CHANNEL);

      EventChannel eventChannel = EventChannel(SpiroSDKConstants.DC_EVENTS_CHANNEL);

      //check if the option variable is AFOptions type or map type
      assert(options is Map);
      if (options is Map) {
        _instance = SpiroSdk.private(methodChannel, eventChannel, mapOptions: options);
      }
    }
    return _instance!;
  }

  @visibleForTesting
  SpiroSdk.private(this._methodChannel, this._eventChannel, { this.mapOptions});


  Future<dynamic> initializeSdk() async {

    return Future.delayed(Duration(seconds: 0)).then((_) {

      _registerCallBackListeners();
     /* Map<String, dynamic>? validatedOptions;
      if (mapOptions != null) {
        validatedOptions = _validateMapOptions(mapOptions!);
      }*/

      return _methodChannel.invokeMethod(SpiroSDKConstants.SPIRO_INITIALIZE);
    });
  }


  Future<dynamic> setUserParamsInfo(Map<String, String>? userParameters) {
    // mandatory fields
    // age - int - age(6-100)
    // weight - int - weight(15-250)kg
    // height - int - height(80-240)cm
    // sex - Sex (Enum) - MALE: male ; FEMALE: female;

    return _methodChannel.invokeMethod(SpiroSDKConstants.SPIRO_SET_USER_DATA, {
      'userParameters': userParameters
    });
  }

  Future<dynamic> startSearchingDevices() {
    return _methodChannel.invokeMethod(SpiroSDKConstants.SPIRO_START_SEARCH);
  }

  Future<dynamic> stopSearchingDevices() {
    return _methodChannel.invokeMethod(SpiroSDKConstants.SPIRO_STOP_SEARCH);
  }

  Future<dynamic> connectWithDevice(SpiroDeviceType device) {
   // String deviceName = "";
    var deviceParams ={'index': device.index, 'name': device.name, 'address': device.address};
    return _methodChannel.invokeMethod(SpiroSDKConstants.SPIRO_CONNECT_DEVICE, deviceParams);
  }


  Future<dynamic> disconnectDevice() {
    return _methodChannel.invokeMethod(SpiroSDKConstants.SPIRO_DISCONNECT_DEVICE);
  }

  Future<dynamic> deleteDeviceData() {
    return _methodChannel.invokeMethod(SpiroSDKConstants.SPIRO_DELETE_DATA);
  }

  Future<dynamic> getDeviceData() {
    return _methodChannel.invokeMethod(SpiroSDKConstants.SPIRO_GET_DATA);
  }


  Future<dynamic> getDisposeAll() {
    return _methodChannel.invokeMethod(SpiroSDKConstants.SPIRO_DISPOSE_ALL);
  }


  void _registerCallBackListeners() {
    _eventChannel.receiveBroadcastStream().listen((data) {
      var decodedJSON = jsonDecode(data);
      print('register_call_back: $decodedJSON');
      String? status = decodedJSON['status'];
      if (status == SpiroSDKConstants.DC_COMPLETE) {
        
      }  
      /*String? type = decodedJSON['type'];
      if (type == SpiroSDKConstants.AF_VALIDATE_PURCHASE) {
        _afValidtaPurchaseController!.sink.add(decodedJSON);
      }*/
    });
  }


  void onDeviceCallbackData(Function callback) async {
    startListening(callback as void Function(dynamic), SpiroSDKConstants.DC_DEVICE_CALLBACK);
    startListening(callback as void Function(dynamic), SpiroSDKConstants.DC_DEVICE_CONNECT);
    startListening(callback as void Function(dynamic), SpiroSDKConstants.DC_DEVICE_OPERATIONS);
  }


  Future<String?> getSDKVersion() async {
    return _methodChannel.invokeMethod("getSDKVersion");
  }

}
