package extension.firebase.native.android;

#if android
/**
 * Haxe extern for the Firebase Crashlytics NDK API.
 * * This class provides bindings to the public C++ API defined in 'crashlytics.h'
 *
 * @see <a href="https://firebase.google.com/docs/crashlytics">Firebase Crashlytics Docs</a>
 */
@:native("firebase::crashlytics")
@:include("firebase/crashlytics.h")
extern class NativeCrashlytics {

    /**
     * Initialize the Crashlytics NDK API, for Android apps using native code.
     *
     * This allows finer grained control of when the native API is initialized. Calling this
     * function is not not strictly necessary as the API will be initialized on the first call
     * to any of the functions within this class.
     *
     * @return true if initialization was successful or already completed.
     */
    @:native("::firebase::crashlytics::Initialize")
    public static function Initialize(): Bool;

    // /**
    //  * Deprecated; now a no-op and does not need to be called.
    //  */
    // @:native("firebase::crashlytics::Terminate")
    // public static function Terminate(): Void;

    /**
     * Logs a message to be included in the next fatal or non-fatal report.
     *
     * @param msg The message to be logged.
     */
    @:native("::firebase::crashlytics::Log")
    public static function Log(msg: String): Void;

    /**
     * Records a custom key and boolean value to be associated with subsequent
     * fatal and non-fatal reports.
     *
     * @param key The custom key.
     * @param value The boolean value.
     */
    @:native("::firebase::crashlytics::SetCustomKey")
    public overload static function SetCustomKey(key: String, value: Bool): Void;

    /**
     * Records a custom key and string value to be associated with subsequent
     * fatal and non-fatal reports.
     *
     * @param key The custom key.
     * @param value The string value.
     */
    @:native("::firebase::crashlytics::SetCustomKey")
    public overload static function SetCustomKey(key: String, value: String): Void;

    /**
     * Records a custom key and floating-point value (maps to C++ float/double)
     * to be associated with subsequent fatal and non-fatal reports.
     *
     * @param key The custom key.
     * @param value The numeric value.
     */
    @:native("::firebase::crashlytics::SetCustomKey")
    public overload static function SetCustomKey(key: String, value: Float): Void;

    /**
     * Records a custom key and integer value (maps to C++ int/long)
     * to be associated with subsequent fatal and non-fatal reports.
     *
     * @param key The custom key.
     * @param value The numeric value.
     */
    @:native("::firebase::crashlytics::SetCustomKey")
    public overload static function SetCustomKey(key: String, value: Int): Void;

    /**
     * Records a user ID (identifier) that's associated with subsequent
     * fatal and non-fatal reports.
     *
     * @param id The user identifier string.
     */
    @:native("::firebase::crashlytics::SetUserId")
    public static function SetUserId(id: String): Void;
}
#end