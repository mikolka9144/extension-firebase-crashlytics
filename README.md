# Firebase Crashlytics extension

#### This extension adds support for reporting crashes to the "Firebase Crashlitycs".
#### So far this library is android only, but iOS support is something I might implement in the future.

## Installation

1. Download this extension
2. Patch the "hxcpp" compiler
   
    Hxcpp doesn't support build tagging by default 
    (which is required for the crashlytics to work)

    So Either:
    
    - Use this version: ``haxelib git hxcpp https://github.com/Psych-Slice/hxcpp.git 65b851f749a10c1df34f2ef55836bdec67ee81c2 `` 
    - Add the following part at the end of ``toolchain/android-toolchain-clang.xml``:
        ```xml
            <section if="HXCPP_ANDROID_BUILD_ID">
                <flag value='-Wl,--build-id=sha1'/>
            </section>
        <!-- The part below should correspond to the end of the file -->
          </linker>
        </xml>
        ```
3. Patch "lime" library
    
    By default this is handled for you, however you can disable this patches with ``NO_FIREBASE_GRADLE_PATCH`` flag.

    Useful if you want to retain your modifications to the gradle files.
    (this also disables ``lime_disable_assets_version`` for you to decide if you want to use it.)
4. Add ``google-services.json`` file

    You can do so with 
    ```xml 
    <template path="google-services.json" rename="app/google-services.json"/>
    ```
5. Compile your game for android
6. Add the symbol upload script

    This script will assist you with re-compiling your game (after ``lime build android`` obviously) to add the necessary debugging information.
    ```sh
    # Replace "export/android/"  with the path where the android build is stored
    cd export/android/obj
    rm libApplicationMain-64.so
    rm libApplicationMain-v7.so

    haxelib run hxcpp Build.xml -DHXCPP_DEBUG_LINK -options ./Options.
    # This part in only needed if you compile your game for armv7 in addition to arm64
    sed -i 's/HXCPP_ARM64=1/HXCPP_ARMV7=1/g' ./Options.
    haxelib run hxcpp Build.xml -DHXCPP_DEBUG_LINK -options ./Options.
    sed -i 's/HXCPP_ARMV7=1/HXCPP_ARM64=1/g' ./Options.txt
    ########
    cd -

    rm -r export/android/bin/unstrippedLibs/
    mkdir -p export/android/bin/unstrippedLibs/arm64-v8a/
    #armv7
    mkdir export/android/bin/unstrippedLibs/armeabi-v7a/
    #

    mv export/android/obj/libApplicationMain-64.so export/android/bin/unstrippedLibs/arm64-v8a/libApplicationMain.so
    mv export/android/obj/libApplicationMain-v7.so export/android/bin/unstrippedLibs/armeabi-v7a/libApplicationMain.so
    cd export/android/bin/

    JAVA_HOME="/usr/lib/jvm/java-17-openjdk/" ./gradlew app:uploadCrashlyticsSymbolFile
    cd -
    ```
    Here's how the output should look like:
    ```
    Link: libApplicationMain-64.so
    Link: libApplicationMain-v7.so
    ```

    And here's bad output (library got re-compiled, which will prevent you from uploading symbols for it):
    ```
    Link: libApplicationMain-64.so

    Compiling group: haxe (1 file)
    clang++ -Iinclude -I/run/media/mikolka/MES_drive/Master_Drive/Projects/Haxe/PsychMods/P-Slice/firebase-crash-test/firebase-crash//lib/firebase/include --target=armv7a-linux-androideabi21 -DHXCPP_ARMV7 -DHXCPP_VISIT_ALLOCS(haxe) -DHXCPP_CHECK_POINTER(haxe) -DHXCPP_STACK_TRACE(haxe) -DHXCPP_STACK_LINE(haxe) -DHX_SMART_STRINGS(haxe) -DHXCPP_CATCH_SEGV(haxe) -DHXCPP_API_LEVEL=430(haxe) -I/run/media/mikolka/MES_drive/Master_Drive/Projects/Haxe/PsychMods/P-Slice/firebase-crash-test/test/.haxelib/hxcpp/git/include -Iinclude -DANDROID=ANDROID -DHXCPP_CLANG -DHX_ANDROID -DHXCPP_ANDROID_PLATFORM=21 -fvisibility=hidden -ffunction-sections -fstack-protector -fexceptions -g -c -fpic -O2 -Wno-invalid-offsetof -Wno-return-type-c-linkage -Wno-parentheses ... tags=[haxe,static]
    - [100.0%] src/firebase/Crashlytics.cpp 

    Link: libApplicationMain-v7.so
    ```

    #### Now remember to run it after every "release" build

That's about it. Now you should see the crashes appear on your firebase console.

## Usage

All functionality is located in the ``Crashlytics`` class.

So far, you can add custom keys, add additional logs and send haxe exceptions to the console.

Any ANR crashes will be sent over automatically.
