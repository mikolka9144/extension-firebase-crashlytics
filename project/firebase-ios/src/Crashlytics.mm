//
//  FirebaseCrashlyticsBridge.mm
//  YourProjectName
//
//  This file implements the C-style functions defined in the Haxe extern
//  `firebase.native.ios.NativeCrashlytics`.
//
//  It bridges calls from Haxe/C++ to the native Objective-C
//  Firebase Crashlytics SDK.
//
//  **Remember to add this file to your Xcode project's "Compile Sources"**
//  **and link the FirebaseCrashlytics framework.**
//

// Import the native Firebase iOS SDK header
#import <FirebaseCrashlytics.h>
#import <FirebaseCore.h>
// --- Helper Functions ---

/**
 * Utility function to convert a C-style string (UTF-8) to an Objective-C
 * NSString. Returns nil if the input is null.
 */
static inline NSString* CStringToNSString(const char* cstr) {
    if (cstr == nullptr) {
        return nil;
    }
    return [NSString stringWithUTF8String:cstr];
}

/**
 * Utility function to convert a C-style string (UTF-8) to an Objective-C
 * NSString. Returns an empty string @"" if the input is null.
 */
static inline NSString* CStringToNSStringSafe(const char* cstr) {
    if (cstr == nullptr) {
        return @"";
    }
    return [NSString stringWithUTF8String:cstr];
}


// --- Haxe Bridge Implementation ---

// We wrap all functions in extern "C" to prevent C++ name mangling,
// ensuring Haxe can find them by the names specified in `@:native`.
extern "C" {

    /**
     * @native("crashlytics_Initialize")
     * On iOS, Firebase is initialized globally via [FIRApp configure].
     * This function is mostly for parity with the Android C++ SDK.
     * We just return true to signal it's "ready".
     */
    bool crashlytics_Initialize() {
        // Initialization is handled by [FIRApp configure] in the AppDelegate.
        // We can check if Crashlytics is configured, but for simplicity,
        // we just return true.
        [FIRApp configure];
        return true;
    }

    /**
     * @native("crashlytics_Log")
     */
    void crashlytics_Log(const char* msg) {
        // Use the safe converter in case the message is null
        NSString* logMessage = CStringToNSStringSafe(msg);
        
        // Send log to Firebase Crashlytics
        [[FIRCrashlytics crashlytics] log:logMessage];
    }

    /**
     * @native("crashlytics_SetCustomKey")
     * Overload for Boolean (Bool)
     */
    void crashlytics_SetCustomKey_Bool(const char* key, bool value) {
        NSString* nsKey = CStringToNSString(key);
        if (nsKey == nil) {
            return;
        }
        
        // Crashlytics requires objects. We wrap the bool in an NSNumber.
        [[FIRCrashlytics crashlytics] setCustomValue:@(value) forKey:nsKey];
    }

    /**
     * @native("crashlytics_SetCustomKey")
     * Overload for String (const char*)
     * NOTE: This single C++ function handles both Haxe extern overloads:
     * - SetCustomKey(key: cpp.ConstCharStar, value: String)
     * - SetCustomKey(key: String, value: String)
     */
    void crashlytics_SetCustomKey_String(const char* key, const char* value) {
        NSString* nsKey = CStringToNSString(key);
        if (nsKey == nil) {
            return;
        }
        
        // Use the safe converter for the value, as Crashlytics
        // can handle a non-nil string.
        NSString* nsValue = CStringToNSStringSafe(value);
        [[FIRCrashlytics crashlytics] setCustomValue:nsValue forKey:nsKey];
    }

    /**
     * @native("crashlytics_SetCustomKey")
     * Overload for Float (double)
     */
    void crashlytics_SetCustomKey_Float(const char* key, double value) {
        NSString* nsKey = CStringToNSString(key);
        if (nsKey == nil) {
            return;
        }
        
        // Wrap the double in an NSNumber
        [[FIRCrashlytics crashlytics] setCustomValue:@(value) forKey:nsKey];
    }

    /**
     * @native("crashlytics_SetCustomKey")
     * Overload for Int (int)
     */
    void crashlytics_SetCustomKey_Int(const char* key, int value) {
        NSString* nsKey = CStringToNSString(key);
        if (nsKey == nil) {
            return;
        }
        
        // Wrap the int in an NSNumber
        [[FIRCrashlytics crashlytics] setCustomValue:@(value) forKey:nsKey];
    }

    /*
    * NOTE ON SETCUSTOMKEY:
    * Your Haxe extern defines 4 overloads all named "crashlytics_SetCustomKey".
    * This will cause a C++ link-time "symbol already defined" error.
    * You MUST change your Haxe `@:native` tags to have unique names.
    *
    * I have implemented them here with unique suffixes (e.g., _Bool, _String).
    * You must update your Haxe extern to match, like this:
    *
    * @:native("crashlytics_SetCustomKey_Bool")
    * public overload static function SetCustomKey(key: cpp.ConstCharStar, value: Bool): Void;
    *
    * @:native("crashlytics_SetCustomKey_String")
    * public overload static function SetCustomKey(key: String, value: String): Void;
    *
    * @:native("crashlytics_SetCustomKey_Float")
    * public overload static function SetCustomKey(key: cpp.ConstCharStar, value: Float): Void;
    *
    * @:native("crashlytics_SetCustomKey_Int")
    * public overload static function SetCustomKey(key: cpp.ConstCharStar, value: Int): Void;
    */

    /**
     * @native("crashlytics_SetUserId")
     */
    void crashlytics_SetUserId(const char* id) {
        // Use safe converter, setting user ID to "" is valid.
        NSString* nsId = CStringToNSStringSafe(id);
        [[FIRCrashlytics crashlytics] setUserID:nsId];
    }

    /**
     * @native("crashlytics_SendCrash")
     *
     * Records a non-fatal exception.
     *
     * ASSUMPTION: The Haxe `Array<cpp.ConstCharStar>` has been joined into a
     * single `const char*` string (e.g., separated by newlines) before
     * being passed to this function.
     */
    void crashlytics_SendCrash(const char* message, const char* native_stack) {
        NSString* nsMessage = CStringToNSStringSafe(message);
        NSString* nsStack = CStringToNSStringSafe(native_stack);

        // To record a non-fatal, we create a custom NSError
        // and add the stack trace as user info.
        NSDictionary* userInfo = @{
            NSLocalizedDescriptionKey: nsMessage,
            @"native_stack_trace": nsStack
        };

        NSError* error = [NSError errorWithDomain:@"HaxeNativeCrash"
                                             code:-1001
                                         userInfo:userInfo];

        [[FIRCrashlytics crashlytics] recordError:error];
    }

} // extern "C"