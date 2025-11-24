package extension.firebase;

#if android
import extension.firebase.native.android.NativeCrashlytics;
#end
#if ios
import extension.firebase.native.ios.NativeCrashlytics;
#end
import haxe.Exception;
import haxe.CallStack.StackItem;
import extension.firebase.CrashReporter;

/**
 * Haxe extern for the Firebase Crashlytics NDK API.
 * * This class provides bindings to the public C++ API defined in 'crashlytics.h'
 *
 * @see <a href="https://firebase.google.com/docs/crashlytics">Firebase Crashlytics Docs</a>
 */
#if !display
@:buildXml("<include name=\"${haxelib:extension-firebase-crashlytics}/hxcpp_include.xml\" />")
#end
@:keep
class Crashlytics {

    /**
     * Initialize the Crashlytics NDK API, for Android apps using native code.
     *
     * On iOS, **YOU MUST** call this function as early as possible
     * in your code to make sure no crashes get past the Firebase Crashlytics.
     *
     * On Android, it allows for finer grained control when the native API is initialized. Calling this
     * function is not not strictly necessary as the API will be initialized on the first call
     * to any of the functions within this class.
     *
     * @return true if initialization was successful or already completed.
     */
    public static function initialize(): Bool{
        return NativeCrashlytics.Initialize();
    }

    /**
     * Logs a message to be included in the next fatal or non-fatal report.
     *
     * @param msg The message to be logged.
     */
    public static function log(msg: String): Void{
        NativeCrashlytics.Log(msg);
    }

    /**
     * Records a custom key and boolean value to be associated with subsequent
     * fatal and non-fatal reports.
     *
     * @param key The custom key.
     * @param value The custom string/int/float/bool value.
     */
    public static function setCustomKey(key: String, value: Any): Void{
        if(Std.isOfType(value,String))
            NativeCrashlytics.SetCustomKey(key,cast (value,String));
        if(Std.isOfType(value,Int))
            NativeCrashlytics.SetCustomKey(key,cast (value,Int));
        if(Std.isOfType(value,Float))
            NativeCrashlytics.SetCustomKey(key,cast (value,Float));
        if(Std.isOfType(value,Bool))
            NativeCrashlytics.SetCustomKey(key,cast (value,Bool));
        else
            NativeCrashlytics.SetCustomKey(key,Std.string(value));
        
    }

    /**
     * Records a user ID (identifier) that's associated with subsequent
     * fatal and non-fatal reports.
     *
     * @param id The user identifier string.
     */
    public static function setUserId(id: String): Void{
        NativeCrashlytics.SetUserId(id);
    }

    /**
     * Creates and sends the exceptio data to the Firebase.
     * This will include add the keys  logs 
     *
     * @param id The user identifier string.
     */
    public static function sendCrashData(message:String,stack:Array<StackItem>):Void {
        CrashReporter.sendCrashData(message,stack);
    }

    public static function sendException(ex:Exception): Void {
         CrashReporter.sendException(ex);
    }
}