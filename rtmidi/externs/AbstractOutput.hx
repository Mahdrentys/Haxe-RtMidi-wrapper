package rtmidi.externs;

import cpp.Int32;
import cpp.StdString;
import cpp.StdStringRef;

class AbstractOutput
{
    inline public static function setApi(api:String):Void
    {
        ExternOutput.setApi(StdString.ofString(api));
    }

    public static function count():Int
    {
        var count:Int = ExternOutput.count();
        return count;
    }

    public static function get(id:Int):Int
    {
        var externId:Int32 = id;
        var i:Int = ExternOutput.get(externId);
        return i;
    }

    public static function create(name:String):Int
    {
        var i:Int = ExternOutput.create(StdString.ofString(name));
        return i;
    }

    public static function getStaticError():String
    {
        var error:StdStringRef = ExternOutput.getStaticError();
        return error.toString();
    }

    inline public static function resetStaticError():Void
    {
        ExternOutput.resetStaticError();
    }

    public static function isVirtual(instance:Int):Bool
    {
        var externInstance:Int32 = instance;
        var isVirtualInt:Int = ExternOutput.isVirtual(externInstance);
        return isVirtualInt == 1 ? true : false;
    }

    public static function getName(instance:Int):String
    {
        var externInstance:Int32 = instance;
        var name:StdStringRef = ExternOutput.getName(externInstance);
        return name.toString();
    }

    public static function sendMessageByte(instance:Int, byte:Int):Void
    {
        var externInstance:Int32 = instance;
        var externByte:Int32 = byte;
        ExternOutput.sendMessageByte(externInstance, externByte);
    }

    public static function sendMessage(instance:Int):Void
    {
        var externInstance:Int32 = instance;
        ExternOutput.sendMessage(externInstance);
    }

    static public function close(instance:Int):Void
    {
        var externInstance:Int32 = instance;
        ExternOutput.close(externInstance);
    }

    static public function getError(instance:Int):String
    {
        var externInstance:Int32 = instance;
        var error:StdStringRef = ExternOutput.getError(externInstance);
        return error.toString();
    }

    static public function resetError(instance:Int):Void
    {
        var externInstance:Int32 = instance;
        ExternOutput.resetError(externInstance);
    }
}