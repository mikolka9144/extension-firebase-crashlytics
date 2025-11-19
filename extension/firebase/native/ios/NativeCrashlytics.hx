package extension.firebase.native.ios;

#if ios
@:include('Crashlytics.hpp')
extern class NativeCrashlytics {
    
    /**
     * Initialises the core Firebase framework.
     * You need to call this as early as possible in your code!
     */ 
    @:native("crashlytics_Initialize")
    public static function Initialize(): Bool;

    @:native("crashlytics_Log")
    public static function Log(msg:cpp.ConstCharStar): Void;

    /** SetCustomKey(key, bool) */
    @:native("crashlytics_SetCustomKey_Bool")
    public overload static function SetCustomKey(key: cpp.ConstCharStar, value: Bool): Void;

    /** SetCustomKey(key, string) */
    @:native("crashlytics_SetCustomKey_String")
    public overload static function SetCustomKey(key: String, value: String): Void;

    /** SetCustomKey(key, float) */
    @:native("crashlytics_SetCustomKey_Float")
    public overload static function SetCustomKey(key: cpp.ConstCharStar, value: Float): Void;

    /** SetCustomKey(key, int) */
    @:native("crashlytics_SetCustomKey_Int")
    public overload static function SetCustomKey(key: cpp.ConstCharStar, value: Int): Void;

    @:native("crashlytics_SetUserId")
    public static function SetUserId(id: cpp.ConstCharStar): Void;

    /**
     * Records a non-fatal exception.
     * NOTE: The 'native_stack' Array must be joined into a single String
     * (e.g. stack.join("\n")) before calling this function!
     */
    @:native("crashlytics_SendCrash")
    public static function nativeSendCrash(message:cpp.ConstCharStar, native_stack_string:cpp.ConstCharStar):Void;
}
#end