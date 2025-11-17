/*
 * Crashlytics.hpp
 *
 * C-style function declarations for bridging Haxe C++ to the
 * native iOS Firebase Crashlytics SDK.
 *
 * This file is included by Haxe-generated C++ code via `@:headerInclude`.
 * The functions are implemented in an Objective-C++ file (e.g., FirebaseCrashlyticsBridge.mm).
 */

// Standard header guard to prevent multiple inclusions
#pragma once

// We must wrap these in extern "C" to tell the C++ compiler
// to use C-style linkage (no name mangling). This ensures
// Haxe can find the functions by their exact names.
#ifdef __cplusplus
extern "C" {
#endif

// Include <cstdbool> or just use 'bool' if your C++ env supports it.
// 'bool' is standard in C++, so no include is needed.

/**
 * @from Haxe: NativeCrashlytics.Initialize()
 *
 * On iOS, this is mostly a no-op as init is handled by [FIRApp configure].
 * @return true if initialization was successful or already completed.
 */
bool crashlytics_Initialize();

/**
 * @from Haxe: NativeCrashlytics.Log()
 *
 * Logs a message to be included in the next fatal or non-fatal report.
 * @param msg The message to be logged (must be a UTF-8 C-string).
 */
void crashlytics_Log(const char* msg);

/**
 * @from Haxe: NativeCrashlytics.SetCustomKey(key, bool)
 *
 * Records a custom key and boolean value.
 * @param key The custom key (UTF-8 C-string).
 * @param value The boolean value.
 */
void crashlytics_SetCustomKey_Bool(const char* key, bool value);

/**
 * @from Haxe: NativeCrashlytics.SetCustomKey(key, string)
 *
 * Records a custom key and string value.
 * @param key The custom key (UTF-8 C-string).
 * @param value The string value (UTF-8 C-string).
 */
void crashlytics_SetCustomKey_String(const char* key, const char* value);

/**
 * @from Haxe: NativeCrashlytics.SetCustomKey(key, float)
 *
 * Records a custom key and floating-point value.
 * @param key The custom key (UTF-8 C-string).
 * @param value The numeric value (maps from Haxe Float, typically a 64-bit double).
 */
void crashlytics_SetCustomKey_Float(const char* key, double value);

/**
 * @from Haxe: NativeCrashlytics.SetCustomKey(key, int)
 *
 * Records a custom key and integer value.
 * @param key The custom key (UTF-8 C-string).
 * @param value The numeric value (maps from Haxe Int).
 */
void crashlytics_SetCustomKey_Int(const char* key, int value);

/**
 * @from Haxe: NativeCrashlytics.SetUserId()
 *
 * Records a user ID (identifier).
 * @param id The user identifier string (UTF-8 C-string).
 */
void crashlytics_SetUserId(const char* id);

/**
 * @from Haxe: NativeCrashlytics.nativeSendCrash()
 *
 * Records a non-fatal exception to the firebase console
 *
 * @param message The exception message (UTF-8 C-string).
 * @param native_stack_string A single string representing the stack trace,
 * e.g., joined by newlines (UTF-8 C-string).
 */
void crashlytics_SendCrash(const char* message, const char* native_stack_string);


#ifdef __cplusplus
} // extern "C"
#endif