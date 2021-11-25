package ai.docty.devicecare;

import android.app.Activity;
import android.app.Application;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.le.ScanResult;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.contec.sp.code.bean.DeviceType;
import com.contec.sp.code.bean.FVCData_B;
import com.contec.sp.code.bean.FVCData_BEXP;
import com.contec.sp.code.bean.FVCData_SP10;
import com.contec.sp.code.bean.PredictedValues_B;
import com.contec.sp.code.bean.PredictedValues_BEXP;
import com.contec.sp.code.bean.PredictedValues_SP10;
import com.contec.sp.code.bean.ResultData;
import com.contec.sp.code.bean.SdkConstants;
import com.contec.sp.code.bean.WaveData;
import com.contec.sp.code.callback.BleScanCallback;
import com.contec.sp.code.callback.ConnectCallback;
import com.contec.sp.code.callback.OnOperateListener;
import com.contec.sp.code.tools.Utils;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import static ai.docty.devicecare.DeviceCareConstants.DC_EVENTS_CHANNEL;

/**
 * DeviceCarePlugin
 */
public class DeviceCarePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity

    private Context mContext;
    private Activity activity;
    private Application mApplication;
    private Intent mIntent;


    // private static boolean saveCallbacks;

    //  private MethodChannel mMethodChannel;
    private MethodChannel mCallbackChannel;

    private EventChannel mEventChannel;

    private Boolean validateDeviceListCallback = false;

    final Handler uiThreadHandler = new Handler(Looper.getMainLooper());

    private MethodChannel channel;
    private SpiroData spiroData;

   // private ArrayList<BluetoothDevice> deviceArrayList = new ArrayList<>();

    public ArrayList<SearchDeviceData> searchDeviceDataArrayList = new ArrayList<>();


    //  private ContecSdk contecSdk;

    //private static final String channelName = "devicecare";

    private Map<String, Map<String, Object>> mCallbacks = new HashMap<>();

    MethodCallHandler callbacksHandler = new MethodCallHandler() {
        @Override
        public void onMethodCall(MethodCall call, Result result) {
            final String method = call.method;
            Log.e("calling_method", method);

            if ("startListening".equals(method)) {
                startListening(call.arguments, result);
            } else {
                result.notImplemented();
            }
        }
    };

    private void setup(DeviceCarePlugin plugin, BinaryMessenger binaryMessenger, Context context) {

        plugin.mEventChannel = new EventChannel(binaryMessenger, DC_EVENTS_CHANNEL);
        plugin.mEventChannel.setStreamHandler(new DeviceStreamHandler(mContext));

        plugin.channel = new MethodChannel(binaryMessenger, DeviceCareConstants.DC_METHOD_CHANNEL);
        plugin.channel.setMethodCallHandler(plugin);



        plugin.mCallbackChannel = new MethodChannel(binaryMessenger, DeviceCareConstants.DC_DEVICE_CALLBACK);
        plugin.mCallbackChannel.setMethodCallHandler(callbacksHandler);

        spiroData = new SpiroData(context);

        //plugin.spiroData.initData(context);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        mContext = flutterPluginBinding.getApplicationContext();

        setup(this, flutterPluginBinding.getBinaryMessenger(), flutterPluginBinding.getApplicationContext());
//    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "devicecare");
//    channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        final String method = call.method;
        Log.e("in_method: ",method);
        switch (method) {
            case DeviceCareConstants.SPIRO_INITIALIZE:
                initSdk(call, result);
                break;
            case DeviceCareConstants.SPIRO_START_SEARCH:
                searchForBTDevices(call, result);
                break;
            case DeviceCareConstants.SPIRO_STOP_SEARCH:
                stopSearchingBTDevices(call, result);
                break;
            case DeviceCareConstants.SPIRO_SET_USER_DATA:
                setUserData(call, result);
                break;

            case DeviceCareConstants.SPIRO_CONNECT_DEVICE:
                connectWithDevice(call, result);
                break;

            case DeviceCareConstants.SPIRO_DISCONNECT_DEVICE:
                disconnectWithDevice(call, result);
                break;

            case DeviceCareConstants.SPIRO_DELETE_DATA:
                deleteData(call, result);
                break;

            case DeviceCareConstants.SPIRO_GET_DATA:
                getDeviceData(call, result);
                break;

            case DeviceCareConstants.SPIRO_DISPOSE_ALL:
                disposeAll(call, result);
                break;

            default:
                result.notImplemented();
                break;
        }
    /*if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }

    if (call.method.equals("initializeSDK")) {
      boolean status = initializeSDK();
      Log.e("initializeSDK", "status = " + status);
      result.success(status);
    }


    if (call.method.equals("startDeviceSearch")) {
      boolean status = startDeviceSearch();
      Log.e("startDeviceSearch", "startDeviceSearch = " + status);
      result.success(status);
    }

    if (call.method.equals("stopDeviceSearch")) {
      boolean status = stopDeviceSearch();
      Log.e("stopDeviceSearch", "stopDeviceSearch = " + status);
      result.success(status);
    }

    else if (call.method.equals("setUserParams")) {
      HashMap<String, Object> map = (HashMap<String, Object>) call.arguments;
      Log.e("arguments", "map = " + map); // {key=value}
      result.success(true);
    }else {
      result.notImplemented();
    }*/
    }


    private void initSdk(MethodCall call, Result result) {

        spiroData.initData();
   /* String afDevKey = (String) call.argument(DeviceCareConstants.DC_DEV_KEY);
    if (afDevKey == null || afDevKey.equals("")) {
      result.error(null, "AF Dev Key is empty", "AF dev key cannot be empty");
    }*/
        /*if (saveCallbacks) {
            saveCallbacks = false;
            //sendCachedCallbacksToDart();
        }*/
        clearDeviceData();
        result.success(true);
    }


    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        // mMethodChannel = null;
        mEventChannel.setStreamHandler(null);
        mEventChannel = null;
        channel = null;
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        activity = binding.getActivity();
        mIntent = binding.getActivity().getIntent();
        mApplication = binding.getActivity().getApplication();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        //sendCachedCallbacksToDart();
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
       // saveCallbacks = true;
    }

    private void startListening(Object arguments, Result rawResult) {
        // Get callback id
        String callbackName = (String) arguments;
        
        Log.e("callbackName", callbackName);

        if (callbackName.equals(DeviceCareConstants.DC_DEVICE_CALLBACK)) {
            validateDeviceListCallback = true;
        }
        Map<String, Object> args = new HashMap<>();
        args.put("id", callbackName);
        mCallbacks.put(callbackName, args);

        rawResult.success(null);
    }

    private void searchForBTDevices(MethodCall call, Result result) {
        registerDeviceListListener();
        result.success(true);
    }

    private void setUserData(MethodCall call, Result result) {
        Map<String, String> parameters = (Map<String, String>) call.argument("userParameters");
        spiroData.setUserParams(parameters);
        result.success(true);
    }

    private void stopSearchingBTDevices(MethodCall call, Result result) {
        spiroData.stopDeviceSearch();
        //clearDeviceData();
        result.success(true);
    }

    private void connectWithDevice(MethodCall call, Result result){
        /*ConnectCallback connectCallback = new ConnectCallback() {
            @Override
            public void onConnectStatus(final int status) {
                String deviceStatus ="";
                switch (status) {
                    case SdkConstants.CONNECT_CONNECTED:
                        //connection succeeded
                        deviceStatus = "connected";
                        break;
                    case SdkConstants.CONNECT_DISCONNECTED:
                    case SdkConstants.CONNECT_DISCONNECT_EXCEPTION:
                    case SdkConstants.CONNECT_DISCONNECT_SERVICE_UNFOUND:
                    case SdkConstants.CONNECT_DISCONNECT_NOTIFY_FAIL:
                        //Disconnect
                        deviceStatus = "disconnected";
                        break;
                    default:
                        break;
                }

                JSONObject jsonObject = new JSONObject();
                runOnUIThread(jsonObject, DeviceCareConstants.DC_DEVICE_CONNECT, deviceStatus);
            }
        };*/

        String index = (String) call.argument("index");
        String name = (String) call.argument("name");
        String alias = (String) call.argument("alias");
        String address = (String) call.argument("address");
        String type = (String) call.argument("type");
        
        if (searchDeviceDataArrayList.size()>0) {

            Log.e("connect_device_index: ", index);

            int inputIndex = Integer.parseInt(index);

            BluetoothDevice bluetoothDevice = searchDeviceDataArrayList.get(inputIndex).getBluetoothDevice();
            Log.e("device_data_name: ", bluetoothDevice.getName());

            spiroData.connectDevice(bluetoothDevice, result, connectCallback, onOperateListener);

        }else{
            result.success(false);
        }
    }

    private void disconnectWithDevice(MethodCall call, Result result){
        spiroData.disconnectDevice();
        result.success(true);
    }

    private void deleteData(MethodCall call, Result result){
        spiroData.deleteData();
        result.success(true);
    }

    private void getDeviceData(MethodCall call, Result result){
        spiroData.getDeviceData();
        result.success(true);
    }


    private void disposeAll(MethodCall call, Result result){
        spiroData.stopDeviceSearch();
        clearDeviceData();
        spiroData.disconnectDevice();
        result.success(null);
    }


    private final OnOperateListener onOperateListener = new OnOperateListener() {
        @Override
        public void onSuccess(int operate, ResultData resultData) {

            JSONObject jsonObject = new JSONObject();
            try{
                switch (operate){
                    case SdkConstants.OPERATE_SET_PARAMS:
                        //tvSetParams.setText("set params success");
                        jsonObject.put("setParams","true");
                        jsonObject.put("deleteData","false");
                        jsonObject.put("getData","false");
                        break;
                    case SdkConstants.OPERATE_DELETE_DATA:
                       // tvDeleteData.setText("delete data success");
                        jsonObject.put("setParams","false");
                        jsonObject.put("deleteData","true");
                        jsonObject.put("getData","false");
                        break;
                    case SdkConstants.OPERATE_GET_DATA:
                        jsonObject.put("setParams","false");
                        jsonObject.put("deleteData","false");
                        jsonObject.put("getData","true");

                        if (resultData != null) {
                            //showResultData(data);
                            JSONObject jsonResult = getDeviceResultData(resultData);
                            jsonObject.put("data",jsonResult);
                        }
                        break;
                    default:
                        break;
                }

                runOnUIThread(jsonObject, DeviceCareConstants.DC_DEVICE_OPERATIONS, DeviceCareConstants.DC_SUCCESS);
            }catch (Exception exp){
                Log.e("operation_success_exp:", exp.getMessage());
                runOnUIThread(jsonObject, DeviceCareConstants.DC_DEVICE_OPERATIONS, DeviceCareConstants.DC_FAILURE);
            }

        }

        @Override
        public void onFail(int operate, int errorCode) {

            JSONObject jsonObject = new JSONObject();
            try{
                switch (operate) {
                    case SdkConstants.OPERATE_SET_PARAMS:
                        jsonObject.put("setParams","false");

                        //tvSetParams.setText("errorCode = " + errorCode);
                        break;
                    case SdkConstants.OPERATE_DELETE_DATA:
                        jsonObject.put("deleteData","false");
                        //tvDeleteData.setText("errorCode = " + errorCode);
                        break;
                    case SdkConstants.OPERATE_GET_DATA:
                        //tvGetData.setText("errorCode = " + errorCode);
                        jsonObject.put("getData","false");
                        break;
                    default:
                        break;
                }
                jsonObject.put("errorCode",""+errorCode);

            }catch (Exception exp){
                Log.e("operation_success_exp:", exp.getMessage());
                runOnUIThread(jsonObject, DeviceCareConstants.DC_DEVICE_OPERATIONS, DeviceCareConstants.DC_FAILURE);
            }

        }
    };

    private final ConnectCallback connectCallback = new ConnectCallback() {
        @Override
        public void onConnectStatus(final int status) {

            String deviceStatus ="";
            switch (status) {

                case SdkConstants.CONNECT_UNSUPPORT_DEVICETYPE:
                    //deviceStatus = "unSupportedDevice";
                    deviceStatus = DeviceCareConstants.CONNECT_UNSUPPORT_DEVICETYPE;
                    break;

                case SdkConstants.CONNECT_UNSUPPORT_BLUETOOTHTYPE:
                    //deviceStatus = "unSupportedBluetooth";
                    deviceStatus = DeviceCareConstants.CONNECT_UNSUPPORT_BLUETOOTHTYPE;
                    break;

                case SdkConstants.CONNECT_CONNECTING:
                   // deviceStatus = "connecting";
                    deviceStatus =  DeviceCareConstants.CONNECT_CONNECTING;
                    break;

                case SdkConstants.CONNECT_CONNECTED:
                    //connection succeeded
                    // deviceStatus = "connected";
                    deviceStatus =  DeviceCareConstants.CONNECT_CONNECTED;
                    break;
                case SdkConstants.CONNECT_DISCONNECTED:
                case SdkConstants.CONNECT_DISCONNECT_EXCEPTION:
                case SdkConstants.CONNECT_DISCONNECT_SERVICE_UNFOUND:
                case SdkConstants.CONNECT_DISCONNECT_NOTIFY_FAIL:
                    //Disconnect
                    //deviceStatus = "disconnected";
                    deviceStatus = DeviceCareConstants.CONNECT_DISCONNECTED;
                    break;
                default:
                    break;
            }

            JSONObject jsonObject = new JSONObject();
            runOnUIThread(jsonObject, DeviceCareConstants.DC_DEVICE_CONNECT, deviceStatus);
        }
    };

    private void registerDeviceListListener() {
        clearDeviceData();
        final ScanResult[] scanResult = {null};
        BleScanCallback bleScanCallback = new BleScanCallback() {
            @Override
            public void onScanResult(final ScanResult result) {
                try {
                    scanResult[0] = result;
                    byte[] scanData = result.getScanRecord().getBytes();

                    Log.e("BlueScan", "BYTE = " + Utils.bytesToHexString(scanData));
                    Log.e("searchArrayList", "BYTE = " + searchDeviceDataArrayList.isEmpty());

                    String deviceManufacture = spiroData.getManufactureDeviceData(result);

                    if (searchDeviceDataArrayList.isEmpty()){

                        searchDeviceDataArrayList.add(new SearchDeviceData(result.getDevice(),deviceManufacture));
                    }else{
                       boolean resultExists = findDeviceIsAvailable(result.getDevice(), searchDeviceDataArrayList);
                       Log.e("resultExists",""+resultExists);
                       if (!resultExists){
                           // if not exists then add
                           searchDeviceDataArrayList.add(new SearchDeviceData(result.getDevice(),deviceManufacture));
                       }
                    }

                    // adding the scanned devices list in array
                   /* if (!deviceArrayList.contains(result.getDevice())) {
                        deviceArrayList.add(result.getDevice());
                    }*/
                  //  ArrayList<BluetoothDevice> deviceArrayList = spiroData.getDeviceArrayList();
                    /*if (validateDeviceListCallback) {
                        runOnUIDeviceScanThread(result, DeviceCareConstants.DC_DEVICE_CALLBACK, DeviceCareConstants.DC_SUCCESS);
                    } else {
                        JSONObject obj = new JSONObject();
                        obj.put("status", DeviceCareConstants.DC_SUCCESS);
                        sendEventToDart(obj, DeviceCareConstants.DC_EVENTS_CHANNEL);
                    }*/

                } catch (Exception e) {
                    Log.e("scan_result_exp: ", e.getMessage());
                    //e.printStackTrace();
                }
            }

            @Override
            public void onScanError(int errorCode) {
                String errorStatus = "";

                if (errorCode == SdkConstants.SCAN_FAIL_BT_UNSUPPORT) {
                    Log.e("BlueScan", "this no bluetooth");
                    errorStatus = "SCAN_FAIL_BT_UNSUPPORT";
                } else if (errorCode == SdkConstants.SCAN_FAIL_BT_DISABLE) {
                    Log.e("BlueScan", "bluetooth not enable");
                    errorStatus = "SCAN_FAIL_BT_DISABLE";
                }

                try {
                    JSONObject obj = new JSONObject();
                    obj.put("error", errorStatus);

                    if (validateDeviceListCallback) {

                        runOnUIThread(obj, DeviceCareConstants.DC_DEVICE_CALLBACK, DeviceCareConstants.DC_FAILURE);

                    } else {
                        obj.put("status", DeviceCareConstants.DC_FAILURE);
                        sendEventToDart(obj, DeviceCareConstants.DC_EVENTS_CHANNEL);
                    }
                } catch (Exception e) {
                    Log.e("scan_errort_exp: ", e.getMessage());
                    //e.printStackTrace();
                }

            }

            @Override
            public void onScanComplete() {
                Log.e("BlueScan", "search complete");
                try {
                 /*   JSONObject obj = new JSONObject();
                    obj.put("status", DeviceCareConstants.DC_COMPLETE);
                    sendEventToDart(obj, DeviceCareConstants.DC_EVENTS_CHANNEL);*/
                    Log.e("BlueScanComplete", ""+scanResult[0]);

                    runOnUIDeviceScanThread( DeviceCareConstants.DC_DEVICE_CALLBACK, DeviceCareConstants.DC_COMPLETE);

                   /* JSONObject obj = new JSONObject();
                    obj.put("status", DeviceCareConstants.DC_COMPLETE);
                    sendEventToDart(obj, DeviceCareConstants.DC_EVENTS_CHANNEL);*/

                } catch (Exception e) {
                    Log.e("scan_complete_exp: ", e.getMessage());
                    //e.printStackTrace();
                }
            }
        };

        spiroData.startDeviceSearch(bleScanCallback);
    }

    private boolean findDeviceIsAvailable(BluetoothDevice device, ArrayList<SearchDeviceData> searchDeviceArrayList) {

        boolean flag = false;

        String filterName = device.getName();
        String filterAddress = device.getAddress();

        Log.e("filterName", filterName);
        Log.e("filterAddress", filterAddress);

        for (SearchDeviceData searchDeviceData :searchDeviceArrayList){
            BluetoothDevice bluetoothDevice = searchDeviceData.getBluetoothDevice();
            if (filterName.equalsIgnoreCase(bluetoothDevice.getName())){
                if (filterAddress.equalsIgnoreCase(bluetoothDevice.getAddress())){
                    flag =true;
                    break;
                }
            }

        }

        /*for (int i =0; i< searchDeviceArrayList.size(); i++){
            BluetoothDevice inBluetooth = searchDeviceArrayList.get(i).getBluetoothDevice();
            if (inBluetooth == device){
                flag = true;
                break;
            }
        }*/
        return flag;
    }

    private void runOnUIDeviceScanThread( final String callbackName, final String status) {
        uiThreadHandler.post(
                new Runnable() {
                    @Override
                    public void run() {
                        Log.e("runOnUIDeviceScanThread", "Calling with: " + callbackName);

                        try {
                            JSONArray jsonArray = convertDevicesToJSONArray(searchDeviceDataArrayList);
                            JSONObject args = new JSONObject();
                            args.put("id", callbackName);
                            args.put("status", status);
                            args.put("devices", jsonArray);
                            //args.put("deviceManufacture", deviceManufacture);

                            mCallbackChannel.invokeMethod("callListener", args.toString());

                        } catch (Exception e) {
                           // e.printStackTrace();
                            Log.e("data_exp:" , e.getMessage());
                        }

                    }
                }
        );
    }

    private void runOnUIThread(final JSONObject data, final String callbackName, final String status) {
        uiThreadHandler.post(
                new Runnable() {
                    @Override
                    public void run() {
                        Log.d("runOnUIThread", "Calling runOnUIThread with: " + data);

                        try {
                            JSONObject args = new JSONObject();
                            args.put("id", callbackName);
                            args.put("status", status);
                            args.put("data", data);

                            mCallbackChannel.invokeMethod("callListener", args.toString());

                        } catch (Exception e) {
                            // e.printStackTrace();
                            Log.e("data_run_exp:" , e.getMessage());
                        }
                    }
                }
        );
    }

    private void sendEventToDart(final JSONObject params, String channel) {
        Intent intent = new Intent();
        intent.addFlags(Intent.FLAG_INCLUDE_STOPPED_PACKAGES);
        intent.setAction(DeviceCareConstants.DC_BROADCAST_ACTION_NAME);
        intent.putExtra("params", params.toString());
        intent.putExtra("channel", channel);
        LocalBroadcastManager.getInstance(mContext).sendBroadcast(intent);
    }

    private JSONArray convertDevicesToJSONArray(ArrayList<SearchDeviceData> deviceList) {

        Log.e("deviceArrayList", ""+deviceList.size());

        JSONArray jsonArray = new JSONArray();
        try {
            if (deviceList.size() > 0) {
                for (int i = 0; i < deviceList.size(); i++) {

                    JSONObject jsonObject = new JSONObject();
                    jsonObject.put("index", "" + i);

                    BluetoothDevice bluetoothDevice = deviceList.get(i).getBluetoothDevice();
                    String manufacture = deviceList.get(i).getDeviceManufactureData();

                    jsonObject.put("name", bluetoothDevice.getName());
                    jsonObject.put("alias", bluetoothDevice.getAlias());
                    jsonObject.put("address",bluetoothDevice.getAddress());
                    jsonObject.put("type", "" + bluetoothDevice.getType());
                    jsonObject.put("bondState", "" + bluetoothDevice.getBondState());

                    if (manufacture !=null && !manufacture.isEmpty()){
                        jsonObject.put("manufacture", manufacture);
                    }else{
                        jsonObject.put("manufacture", "");
                    }

                    jsonArray.put(jsonObject);
                }
            }

            return jsonArray;
        } catch (Exception exp) {
            //exp.printStackTrace();
            Log.e("data_bind_exp: ", exp.getMessage());
            return jsonArray;
        }
    }

    private JSONObject getDeviceResultData(ResultData resultData) {
        JSONObject jsonObject = new JSONObject();
        try {

            DeviceType deviceType = resultData.getDeviceType();
            JSONObject predictedJson = getPredictedJson(deviceType, resultData);
            JSONArray fvcDataArray = getFVCData(deviceType, resultData);

            String deviceName = getDeviceTypeName(deviceType);
            jsonObject.put("deviceType", deviceName);
            jsonObject.put("predictedData", predictedJson);
            jsonObject.put("fvcData", fvcDataArray);

            if (resultData.getWaveDatas() != null && resultData.getWaveDatas().size() >0) {
                JSONArray waveData = getWaveData(resultData.getWaveDatas());
                jsonObject.put("waveData", waveData);
            }

        } catch (Exception exp) {
            Log.e("get_fvc_data_exp: ", exp.getMessage());
        }
        return jsonObject;
    }

    private JSONArray getWaveData(ArrayList<WaveData> waveDataList) {
        JSONArray jsonArray = new JSONArray();
        try{
            for (WaveData waveData :waveDataList){
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("count", ""+waveData.getWaveCount());

             /*   String times =  Arrays.toString(waveData.getTimes());
                String speeds =  Arrays.toString(waveData.getSpeeds());
                String volumes =  Arrays.toString(waveData.getVolumes());

                jsonObject.put("time", times);
                jsonObject.put("speed", speeds);
                jsonObject.put("volume", volumes);*/

                float[] times = waveData.getTimes();
                float[] speeds = waveData.getSpeeds();
                float[] volumes = waveData.getVolumes();

                ArrayList<Double> timerList = new ArrayList<>();
                ArrayList<Double> speedList = new ArrayList<>();
                ArrayList<Double> volumesList = new ArrayList<>();

                for (float value : times){
                    ///Log.e("value", ""+value);
                    timerList.add(Double.parseDouble(String.valueOf(value)));
                }
                for (float value : speeds){
                    ///Log.e("value", ""+value);
                    speedList.add(Double.parseDouble(String.valueOf(value)));
                }

                for (float value : volumes){
                    ///Log.e("value", ""+value);
                    volumesList.add(Double.parseDouble(String.valueOf(value)));
                }

                jsonObject.put("time", new JSONArray(timerList));
                jsonObject.put("speed", new JSONArray(speedList));
                jsonObject.put("volume", new JSONArray(volumesList));

                jsonArray.put(jsonObject);
            }

        }catch (Exception exp){
            Log.e("get_wave_data_exp: ", exp.getMessage());
        }
        return jsonArray;
    }

    private String getDeviceTypeName(DeviceType deviceType) {
        String name ="";
        switch (deviceType){
            case SP10:
                name = "SP10";
                break;
            case SP70B:
                name = "SP70B";
                break;
            case SP80B:
                name = "SP80B";
                break;
            case SP70BEXP:
                name = "SP70BEXP";
                break;
            case SP80BEXP:
                name = "SP80BEXP";
                break;
            default:
                name ="NO DEVICE";
                break;
        }
        return name;
    }

    private JSONArray getFVCData(DeviceType deviceType, ResultData data) {

        JSONArray jsonArray = new JSONArray();
        try{
            if (deviceType == (DeviceType.SP70B) || deviceType == (DeviceType.SP80B)) {

                if (data.getFVCDatas_B() != null) {

                    for ( FVCData_B fvcData_B : data.getFVCDatas_B()) {
                        //FVCData_B fvcData_B = data.getFVCDatas_B().get(i);
                        
                        String date = fvcData_B.getYear() + "-" + fvcData_B.getMonth() + "-" + fvcData_B.getDay()
                                + " " + fvcData_B.getHour() + ":" + fvcData_B.getMinute() + ":" + fvcData_B.getSecond();
//
                        JSONObject jsonObject = new JSONObject();
                        //jsonObject.put("id",""+i);
                        jsonObject.put("fvc",fvcData_B.getFVC());
                        jsonObject.put("fev1",fvcData_B.getFEV1());
                        jsonObject.put("fev1Fvc",fvcData_B.getFEV1_FVC());
                        jsonObject.put("pef",fvcData_B.getPEF());

                        /*JSONObject dateObject = new JSONObject();
                        dateObject.put("year",""+fvcData_B.getYear());
                        dateObject.put("month",""+fvcData_B.getMonth());
                        dateObject.put("day",""+fvcData_B.getDay());
                        dateObject.put("hour",""+fvcData_B.getHour());
                        dateObject.put("minute",""+fvcData_B.getMinute());
                        dateObject.put("second",""+fvcData_B.getSecond());
                        
                        jsonObject.put("date",dateObject);*/
                        
                        jsonObject.put("date",date);
                        jsonArray.put(jsonObject);
                    }

                }


            }else if (deviceType == DeviceType.SP70BEXP || deviceType == DeviceType.SP80BEXP) {

                if (data.getFVCDatas_BEXP() != null) {

                    for (FVCData_BEXP fvcData_BEXP : data.getFVCDatas_BEXP()) {

                        //FVCData_BEXP fvcData_BEXP = data.getFVCDatas_BEXP().get(i);
                        String date = fvcData_BEXP.getYear() + "-" + fvcData_BEXP.getMonth() + "-" +
                                fvcData_BEXP.getDay() + " " + fvcData_BEXP.getHour() + ":" + fvcData_BEXP.getMinute()
                                + ":" + fvcData_BEXP.getSecond();


                        JSONObject jsonObject = new JSONObject();
                        //jsonObject.put("id",""+i);
                        jsonObject.put("fvc",fvcData_BEXP.getFVC());
                        jsonObject.put("fev1",fvcData_BEXP.getFEV1());
                        jsonObject.put("fev1Fvc",fvcData_BEXP.getFEV1_FVC());
                        jsonObject.put("pef",fvcData_BEXP.getPEF());


                        jsonObject.put("fev3",fvcData_BEXP.getFEV3());
                        jsonObject.put("fev6",fvcData_BEXP.getFEV6());
                        jsonObject.put("fev05",fvcData_BEXP.getFEV05());

                        jsonObject.put("fef25",fvcData_BEXP.getFEF25());
                        jsonObject.put("fef50",fvcData_BEXP.getFEF50());
                        jsonObject.put("fef75",fvcData_BEXP.getFEF75());
                        jsonObject.put("fef2575",fvcData_BEXP.getFEF2575());

                        jsonObject.put("peft",fvcData_BEXP.getPEFT());
                        jsonObject.put("evol",fvcData_BEXP.getEVOL());




                       /* JSONObject dateObject = new JSONObject();
                        dateObject.put("year",""+fvcData_BEXP.getYear());
                        dateObject.put("month",""+fvcData_BEXP.getMonth());
                        dateObject.put("day",""+fvcData_BEXP.getDay());
                        dateObject.put("hour",""+fvcData_BEXP.getHour());
                        dateObject.put("minute",""+fvcData_BEXP.getMinute());
                        dateObject.put("second",""+fvcData_BEXP.getSecond());

                        jsonObject.put("date",dateObject);*/
                        
                        jsonObject.put("date",date);

                        jsonArray.put(jsonObject);
                    }
                }

            }else if (deviceType == DeviceType.SP10) {

                if (data.getFVCDatas_SP10() != null) {

                    for (FVCData_SP10 fvcData_SP10 : data.getFVCDatas_SP10()) {
                      //  FVCData_SP10 fvcData_SP10 = data.getFVCDatas_SP10().get(i);
                        String date = fvcData_SP10.getYear() + "-" + fvcData_SP10.getMonth() + "-" +
                                fvcData_SP10.getDay() + " " + fvcData_SP10.getHour() + ":" + fvcData_SP10.getMinute()
                                + ":" + fvcData_SP10.getSecond();


                        JSONObject jsonObject = new JSONObject();
                        //jsonObject.put("id",""+i);
                        jsonObject.put("fvc",fvcData_SP10.getFVC());
                        jsonObject.put("fev1",fvcData_SP10.getFEV1());
                        jsonObject.put("fev1Fvc",fvcData_SP10.getFEV1_FVC());
                        jsonObject.put("pef",fvcData_SP10.getPEF());


                        jsonObject.put("fev3",fvcData_SP10.getFEV3());
                        jsonObject.put("fev6",fvcData_SP10.getFEV6());
                        jsonObject.put("fev05",fvcData_SP10.getFEV05());

                        jsonObject.put("fef25",fvcData_SP10.getFEF25());
                        jsonObject.put("fef50",fvcData_SP10.getFEF50());
                        jsonObject.put("fef75",fvcData_SP10.getFEF75());
                        jsonObject.put("fef2575",fvcData_SP10.getFEF2575());

                        jsonObject.put("peft",fvcData_SP10.getPEFT());
                        jsonObject.put("evol",fvcData_SP10.getEVOL());


                        /*JSONObject dateObject = new JSONObject();
                        dateObject.put("year",""+fvcData_SP10.getYear());
                        dateObject.put("month",""+fvcData_SP10.getMonth());
                        dateObject.put("day",""+fvcData_SP10.getDay());
                        dateObject.put("hour",""+fvcData_SP10.getHour());
                        dateObject.put("minute",""+fvcData_SP10.getMinute());
                        dateObject.put("second",""+fvcData_SP10.getSecond());

                        jsonObject.put("date",dateObject);*/
                        jsonObject.put("date",date);

                        jsonArray.put(jsonObject);
                    }

                }
            }

        }catch (Exception exp){
            Log.e("get_fvc_data_exp: ", exp.getMessage());
        }

        return jsonArray;
    }

    private JSONObject getPredictedJson(DeviceType deviceType, ResultData resultData) {
        JSONObject jsonObject = new JSONObject();
        try {
            if (deviceType == (DeviceType.SP70B) || deviceType == (DeviceType.SP80B)) {

                if (resultData.getPredictedValues_B() != null) {
                    PredictedValues_B predictedValues_B = resultData.getPredictedValues_B();
                    jsonObject.put("fvc", predictedValues_B.getFVC());
                    jsonObject.put("fev1", predictedValues_B.getFEV1());
                    jsonObject.put("fev1Fvc", predictedValues_B.getFEV1_FVC());
                    jsonObject.put("pef", predictedValues_B.getPEF());
                }

            } else if (deviceType == DeviceType.SP70BEXP || deviceType == DeviceType.SP80BEXP) {

                if (resultData.getPredictedValues_BEXP() != null) {

                    PredictedValues_BEXP predictedValues_BEXP = resultData.getPredictedValues_BEXP();
                    //common for all devices
                    jsonObject.put("fvc", predictedValues_BEXP.getFVC());
                    jsonObject.put("fev1", predictedValues_BEXP.getFEV1());
                    jsonObject.put("fev1Fvc", predictedValues_BEXP.getFEV1_FVC());
                    jsonObject.put("pef", predictedValues_BEXP.getPEF());


                    jsonObject.put("fef25", predictedValues_BEXP.getFEF25());
                    jsonObject.put("fef50", predictedValues_BEXP.getFEF50());
                    jsonObject.put("fef75", predictedValues_BEXP.getFEF75());
                    jsonObject.put("fef2575", predictedValues_BEXP.getFEF2575());
                    jsonObject.put("fev3", predictedValues_BEXP.getFEV3());
                    jsonObject.put("fev6", predictedValues_BEXP.getFEV6());
                    

                }
            }else if (deviceType == DeviceType.SP10) {
                if (resultData.getPredictedValues_SP10() != null) {

                    PredictedValues_SP10 sp10ExpPredictedValues = resultData.getPredictedValues_SP10();

                    //common for all devices
                    jsonObject.put("fvc", sp10ExpPredictedValues.getFVC());
                    jsonObject.put("fev1", sp10ExpPredictedValues.getFEV1());
                    jsonObject.put("fev1Fvc", sp10ExpPredictedValues.getFEV1_FVC());
                    jsonObject.put("pef", sp10ExpPredictedValues.getPEF());

                    jsonObject.put("fef25", sp10ExpPredictedValues.getFEF25());
                    jsonObject.put("fef50", sp10ExpPredictedValues.getFEF50());
                    jsonObject.put("fef75", sp10ExpPredictedValues.getFEF75());
                    jsonObject.put("fef2575", sp10ExpPredictedValues.getFEF2575());
                    jsonObject.put("fev3", sp10ExpPredictedValues.getFEV3());
                    jsonObject.put("fev6", sp10ExpPredictedValues.getFEV6());
                }
            }
        }catch (Exception exp){
            Log.e("get_predicted_exp: ", exp.getMessage());
        }
        return jsonObject;
    }

    private void clearDeviceData(){
        if (searchDeviceDataArrayList != null && searchDeviceDataArrayList.size()> 0) {
            Log.e("list", "data clear");
            searchDeviceDataArrayList.clear();
        }
    }
    
}