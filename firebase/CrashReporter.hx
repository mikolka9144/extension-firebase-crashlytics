package firebase;

import haxe.CallStack;
import haxe.Exception;
#if android
import extension.androidtools.jni.JNICache;
#end


class CrashReporter {
    #if android
    private static function _nativeSendCrash(message:String,stack:Array<String>) {
        final sendCrashJNI:Null<Dynamic> = JNICache.createStaticMethod('org/haxe/extension/Firebase', 'sendCrash', '(Ljava/lang/String;[Ljava/lang/String;)V');

		if(sendCrashJNI != null) sendCrashJNI(message,stack);
    }
    #end
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
        _nativeSendCrash(message,native_stack);
    }
    public static function sendException(ex:Exception) {
        @:privateAccess
        sendCrashData(ex.message,ex.stack.asArray());
    }
}