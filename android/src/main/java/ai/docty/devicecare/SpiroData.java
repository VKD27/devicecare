package ai.docty.devicecare;

import android.bluetooth.BluetoothDevice;
import android.bluetooth.le.ScanResult;
import android.content.Context;
import android.util.Log;

import com.contec.sp.code.bean.UserParams;
import com.contec.sp.code.callback.BleScanCallback;
import com.contec.sp.code.callback.ConnectCallback;
import com.contec.sp.code.callback.OnOperateListener;
import com.contec.sp.code.connect.ContecSdk;
import com.contec.sp.code.tools.Utils;

import java.util.Map;

import io.flutter.plugin.common.MethodChannel.Result;

public class SpiroData {

    private Context context;

    private ContecSdk contecSdk;

    SpiroData(Context context) {
        this.context = context;
    }

    public void initData() {
        contecSdk = new ContecSdk(context);
        contecSdk.init(false);
        //clearDeviceData();
    }

    public void startDeviceSearch(BleScanCallback bleScanCallback) {
        //clearDeviceData();
        contecSdk.startLeScan(bleScanCallback, 10000);
    }

    public void stopDeviceSearch() {
        //clearDeviceData();
        contecSdk.stopLeScan();
    }

    public void getDeviceData() {
        contecSdk.getData();
    }

    public void deleteData() {
        contecSdk.deleteData();
    }

    public void connectDevice(BluetoothDevice bluetoothDevice, Result result, ConnectCallback connectCallback, OnOperateListener onOperateListener) {

        contecSdk.setOnOperateListener(onOperateListener);

        if (bluetoothDevice.getName().startsWith("PULMO80B") || bluetoothDevice.getName().startsWith("PULMO70B")
                || bluetoothDevice.getName().startsWith("PULMO80A") || bluetoothDevice.getName().startsWith("PULMO70A")
                || bluetoothDevice.getName().startsWith("PULMO80BEXP") || bluetoothDevice.getName().startsWith("PULMO70BEXP")
                || bluetoothDevice.getName().startsWith("PULMO01")) {
            contecSdk.connect(bluetoothDevice, connectCallback);
            result.success(true);
        } else {
            result.success(false);
        }
    }

    public void disconnectDevice() {
        contecSdk.disconnect();
    }

    public void setUserParams(Map<String, String> parameters) {

        Log.e("userParams: ", parameters.toString());

        String measureMode = parameters.get("measureMode");
        String sex = parameters.get("sex");
        String smoke = parameters.get("smoke");
        // String standard = parameters.get("standard");
        String weight = parameters.get("weight");
        String height = parameters.get("height");
        String age = parameters.get("age");

        UserParams userParams = new UserParams();

        assert measureMode != null;
        userParams.setMeasureMode(getMeasureMode(measureMode.toUpperCase()));

        assert sex != null;
        userParams.setSex(getUserSex(sex.toUpperCase()));

        assert smoke != null;
        userParams.setSmoke(getUserSmoke(smoke.toUpperCase()));

//        assert standard != null;
//        userParams.setStandard(getUserStandard(standard.toUpperCase()));

        assert weight != null;
        int wt = Integer.parseInt(weight);
        userParams.setWeight(wt);

        assert height != null;
        int ht = Integer.parseInt(height);
        userParams.setHeight(ht);

        assert age != null;
        int userAge = Integer.parseInt(age);
        userParams.setAge(userAge);


        contecSdk.setUserParams(userParams);
    }

    private UserParams.MeasureMode getMeasureMode(String measureMode) {
        switch (measureMode) {
            case "FVC":
                return UserParams.MeasureMode.FVC;
            case "VC":
                return UserParams.MeasureMode.VC;
            case "MVV":
                return UserParams.MeasureMode.MVV;
            case "MV":
                return UserParams.MeasureMode.MV;
            case "ALL":
            default:
                return UserParams.MeasureMode.ALL;
        }
    }

    private UserParams.Sex getUserSex(String sex) {
        switch (sex) {
            case "FEMALE":
                return UserParams.Sex.FEMALE;
            case "MALE":
            default:
                return UserParams.Sex.MALE;
        }
    }

    private UserParams.Smoke getUserSmoke(String smoke) {
        switch (smoke) {
            case "SMOKE":
                return UserParams.Smoke.SMOKE;
            case "NOSMOKE":
            default:
                return UserParams.Smoke.NOSMOKE;
        }
    }

    private UserParams.Standard getUserStandard(String standard) {
        switch (standard) {
            case "ECCS":
                return UserParams.Standard.ECCS;
            case "KNUDSON":
                return UserParams.Standard.KNUDSON;
            case "USA":
            default:
                return UserParams.Standard.USA;
        }
    }


    public String getManufactureDeviceData(ScanResult result) {

        StringBuilder stringBuffer = new StringBuilder();
        String manufactureSpecificString = "";

        byte[] scanData = result.getScanRecord().getBytes();

        Log.e("Callbacks", "Calling invokeMethod with: " + Utils.bytesToHexString(scanData));


        if (scanData != null) {
            byte[] manufactorSpecificBytes = getManufacturerSpecificData(scanData);
            if (manufactorSpecificBytes != null) {
                manufactureSpecificString = new String(manufactorSpecificBytes);


                Log.e("manufacture_data", manufactureSpecificString);

                if (manufactureSpecificString.contains("DT") && manufactureSpecificString.contains("DATA")) {
                    int index = manufactureSpecificString.indexOf("DT");
                    String date = manufactureSpecificString.substring(index + 2, index + 8);
                    stringBuffer.append(manufactureSpecificString).append("\n").append("Have data, ").append("The current time is ").append(date);
                } else if (manufactureSpecificString.contains("DT")) {
                    int index = manufactureSpecificString.indexOf("DT");
                    String date = manufactureSpecificString.substring(index + 2, index + 8);
                    stringBuffer.append(manufactureSpecificString).append("\n").append("No data, ").append("The current time is ").append(date);
                } else if (manufactureSpecificString.contains("DATA")) {
                    stringBuffer.append(manufactureSpecificString).append("\n").append("Have data，No time");
                } else {
                    stringBuffer.append(manufactureSpecificString).append("\n").append("No Data Found");
                }
            }


        }
        return stringBuffer.toString();
    }

    private byte[] getManufacturerSpecificData(byte[] bytes) {

        byte[] msd = null;
        for (int i = 0; i < bytes.length - 1; ++i) {
            byte len = bytes[i];
            byte type = bytes[i + 1];

            if ((byte) 0xFF == type) {
                // Intercept vendor-defined fields
                msd = new byte[len - 1];
                for (int j = 0; j < len - 1; ++j) {
                    msd[j] = bytes[i + j + 2];
                }
                return msd;
            } else {
                // Skip other fields
                i += len;
            }
        }

        return msd;
    }

}
