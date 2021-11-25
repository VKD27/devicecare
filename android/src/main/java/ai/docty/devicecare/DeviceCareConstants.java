package ai.docty.devicecare;

public class DeviceCareConstants {

    final static String DC_BROADCAST_ACTION_NAME = "ai.docty.devicecare";

    final static String DC_DEVICE_CALLBACK = "deviceCallbacks";
    
    final static String DC_EVENTS_CHANNEL = "deviceEvents";

    final static String DC_METHOD_CHANNEL = "deviceMethods";
    
    final static String DC_DEVICE_CONNECT = "deviceConnect";

    final static String DC_DEVICE_OPERATIONS = "deviceOperations";


    final static String DC_SUCCESS = "success";
    final static String DC_FAILURE = "failure";
    final static String DC_COMPLETE = "complete";


    //device init methods calls
    final static String SPIRO_INITIALIZE = "initializeSDK";
    final static String SPIRO_START_SEARCH = "startDeviceSearch";
    final static String SPIRO_STOP_SEARCH = "stopDeviceSearch";
    final static String SPIRO_SET_USER_DATA = "setUserParams";
    final static String SPIRO_CONNECT_DEVICE = "connectWithDevice";
    final static String SPIRO_DISCONNECT_DEVICE = "disconnectDevice";
    final static String SPIRO_DELETE_DATA = "deleteData";
    final static String SPIRO_GET_DATA = "getDeviceData";
    final static String SPIRO_DISPOSE_ALL = "disposeAll";

    //DEVICE_STATUS
    final static String CONNECT_UNSUPPORT_DEVICETYPE = "unSupportedDevice";
    final static String CONNECT_UNSUPPORT_BLUETOOTHTYPE = "unSupportedBluetooth";
    final static String CONNECT_CONNECTING = "connecting";
    final static String CONNECT_CONNECTED = "connected";
    final static String CONNECT_DISCONNECTED = "disconnected";
}
