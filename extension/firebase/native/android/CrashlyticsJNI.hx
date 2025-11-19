package extension.firebase.native.android;

#if android
import extension.androidtools.jni.JNICache;

class CrashlyticsJNI {

    public static function _nativeSendCrash(message:String,stack:Array<String>) {
        final sendCrashJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Firebase', 'sendCrash', '(Ljava/lang/String;[Ljava/lang/String;)V');

		if(sendCrashJNI != null) sendCrashJNI(message,stack);
    }

}
#end