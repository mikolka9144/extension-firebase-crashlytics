package org.haxe.extension;

import android.app.AlertDialog;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Rect;
import android.media.AudioManager;
import android.media.MediaCodecList;
import android.media.MediaFormat;
import android.net.Uri;
import android.os.BatteryManager;
import android.os.Build;
import android.util.ArrayMap;
import android.util.Log;
import com.google.firebase.crashlytics.FirebaseCrashlytics;
import com.google.firebase.crashlytics.CustomKeysAndValues;
import androidx.core.content.FileProvider;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;
import java.util.Map;
import org.haxe.extension.Extension;

public class Firebase extends Extension
{
	public static final String LOG_TAG = "Firebase";
	/**
	 * Launches an application package by its package name.
	 *
	 * @param packageName The package name of the application to launch.
	 * @param requestCode The request code to identify the request.
	 */
	public static void sendCrash(final String message,final String[] classes)
	{
		try
		{
		    StackTraceElement[] frames = Arrays.stream(classes).map(s -> {
				String[] split = s.split(";");
				if(split.length==4)
					return new StackTraceElement(split[0],split[1],split[2],Integer.parseInt(split[3]));
				else 
					return new StackTraceElement("Unknown class","Malfolded frame","",0);
			}).toArray(StackTraceElement[]::new);
			Throwable throwable = new Throwable(message);
			throwable.setStackTrace(frames);
			FirebaseCrashlytics.getInstance().recordException(throwable);
		}
		catch (Exception e)
		{
			Log.e(LOG_TAG, e.toString());
		}
	}

}
