package ai.docty.devicecare;
import android.content.Context;
import android.content.IntentFilter;

import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import io.flutter.plugin.common.EventChannel;

public class DeviceStreamHandler implements EventChannel.StreamHandler {
    
    private final Context mContext;
    private DeviceBroadcastReceiver deviceBroadcastReceiver;

    DeviceStreamHandler(Context context){
        this.mContext = context;
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        deviceBroadcastReceiver = new DeviceBroadcastReceiver(eventSink);
        LocalBroadcastManager.getInstance(mContext).registerReceiver(deviceBroadcastReceiver, new IntentFilter(DeviceCareConstants.DC_BROADCAST_ACTION_NAME));
    }

    @Override
    public void onCancel(Object o) {
        LocalBroadcastManager.getInstance(mContext).unregisterReceiver(deviceBroadcastReceiver);
        deviceBroadcastReceiver = null;
    }
}