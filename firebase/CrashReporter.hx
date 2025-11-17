package firebase;


import haxe.CallStack;
import haxe.Exception;
#if android import native.android.CrashlyticsJNI;#end
#if ios import firebase.native.ios.NativeCrashlytics;#end


class CrashReporter {

    private static inline final NATIVE_METHOD:Int = -2;
    private static inline final UNKNOWN_LINE:Int = -1;

    private static inline function makeLine(className:String,method:String,fileName:String,line:Int ):String{
        return className+";"+method+";"+fileName+";"+Std.string(line);
    }
    private static function parseStackItem(stackItem:StackItem,file:String = null,line:Int = UNKNOWN_LINE):String{
        return switch (stackItem)
			{
				case FilePos(s, pos_file, pos_line, column):
                     s == null ? makeLine("???","???",pos_file,pos_line) : parseStackItem(s,pos_file,pos_line);
                case Module(m):
					 makeLine("Module",m,file,line);
				case CFunction:
					 makeLine("Native Function","???",file,NATIVE_METHOD);
				case Method(classname, method):
					 makeLine(classname,method,file,line);
				case LocalFunction(v):
					 makeLine("local",v == null ? "???" : Std.string(v),file,line);
            }
    }
    public static function sendCrashData(message:String,stack:Array<StackItem>) {
        var native_stack = stack.map(s -> parseStackItem(s));
        #if android CrashlyticsJNI._nativeSendCrash(message,native_stack); #end
        #if ios NativeCrashlytics.nativeSendCrash(message,native_stack.join("\n")); #end
    }
    public static function sendException(ex:Exception) {
        @:privateAccess
        sendCrashData(ex.message,ex.stack.asArray());
    }
}