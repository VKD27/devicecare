package ai.docty.devicecare;

import android.bluetooth.BluetoothDevice;

public class SearchDeviceData { 
    
    private BluetoothDevice bluetoothDevice;
    private String deviceManufactureData;

    public SearchDeviceData(BluetoothDevice bluetoothDevice, String deviceManufactureData) {
        this.bluetoothDevice = bluetoothDevice;
        this.deviceManufactureData = deviceManufactureData;
    }

    public BluetoothDevice getBluetoothDevice() {
        return bluetoothDevice;
    }

    public void setBluetoothDevice(BluetoothDevice bluetoothDevice) {
        this.bluetoothDevice = bluetoothDevice;
    }

    public String getDeviceManufactureData() {
        return deviceManufactureData;
    }

    public void setDeviceManufactureData(String deviceManufactureData) {
        this.deviceManufactureData = deviceManufactureData;
    }
}
