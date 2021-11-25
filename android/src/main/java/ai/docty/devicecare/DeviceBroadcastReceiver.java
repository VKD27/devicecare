package ai.docty.devicecare;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import io.flutter.plugin.common.EventChannel;

public class DeviceBroadcastReceiver extends BroadcastReceiver {
    
    private final EventChannel.EventSink mEventSink;

    DeviceBroadcastReceiver(EventChannel.EventSink eventSink){
        this.mEventSink = eventSink;
    }
    @Override
    public void onReceive(Context context, Intent intent) {
        String paramsStr = intent.getStringExtra("params");
        mEventSink.success(paramsStr);
    }
}
