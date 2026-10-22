// Masjid TV — Copyright 2026 Pokka99 — Apache License 2.0 (see LICENSE and NOTICE)
package my.masjid.tv;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

/** Opens the display when the TV powers on, so it comes back by itself after a power cut. */
public class BootReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context ctx, Intent intent) {
        Intent i = new Intent(ctx, MainActivity.class);
        i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        try {
            ctx.startActivity(i);
        } catch (RuntimeException ignored) {
            // Blocked on Android 10+ unless the SYSTEM_ALERT_WINDOW app-op was granted over adb.
        }
    }
}
