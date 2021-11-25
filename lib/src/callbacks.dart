part of spiro_sdk;
// import 'dart:async';
// import 'dart:convert';
// import 'package:devicecare/spiro_sdk.dart';
// import 'package:flutter/services.dart';

const _channel = MethodChannel('deviceCallbacks');

typedef MultiUseCallback = void Function(dynamic msg);
typedef CancelListening = void Function();

Map<String, MultiUseCallback> _callbacksById = <String, void Function(dynamic)> {};

Future<void> _methodCallHandler(MethodCall call) async {

  print('methodCallHandler method: ${call.method}');
  print('methodCallHandler argument : ${jsonDecode(call.arguments)}');

  switch (call.method) {
    case 'callListener':
      try {
        dynamic callMap = jsonDecode(call.arguments);
        switch (callMap["id"].toString()) {
          case SpiroSDKConstants.DC_DEVICE_CALLBACK:
            String status = callMap["status"];
            if (status == SpiroSDKConstants.DC_COMPLETE) {
              // get device list
              var devices = callMap["devices"];
              print('devices >> $devices');
              _callbacksById[callMap["id"]]!(callMap);
            }
            
            break;

          case SpiroSDKConstants.DC_DEVICE_CONNECT:
            print("inside device connect");
            _callbacksById[callMap["id"]]!(callMap);
            break;

          case SpiroSDKConstants.DC_DEVICE_OPERATIONS:
            print("inside device operations");
            _callbacksById[callMap["id"]]!(callMap);
            break;
        }
      }on Exception catch (e) {
        print(e);
      }
      break;
    default:
      print('Ignoring invoke from native. This normally shouldn\'t happen.');
  }

  /*switch (call.method) {
    case 'callListener':
      try {
        dynamic callMap = jsonDecode(call.arguments);
        switch (callMap["id"]) {
          case "onAppOpenAttribution":
          case "onInstallConversionData":
          case "onDeepLinking":
          case "validatePurchase":
          case "generateInviteLinkSuccess":
            String data = callMap["data"];
            Map? decodedData = jsonDecode(data);
            Map fullResponse = {
              "status": callMap['status'],
              "payload": decodedData
            };
            _callbacksById[callMap["id"]]!(fullResponse);
            break;
          default:
            _callbacksById[callMap["id"]]!(callMap["data"]);
            break;
        }
      } on Exception catch (e) {
        print(e);
      }
      break;
    default:
      print('Ignoring invoke from native. This normally shouldn\'t happen.');
  }*/
}

Future<CancelListening> startListening(MultiUseCallback callback, String callbackName) async {

  _channel.setMethodCallHandler(_methodCallHandler);

  _callbacksById[callbackName] = callback;

  await _channel.invokeMethod("startListening", callbackName);

  return () {
    _channel.invokeMethod("cancelListening", callbackName);
    _callbacksById.remove(callbackName);
  };
}
