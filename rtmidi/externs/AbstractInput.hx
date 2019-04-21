package rtmidi.externs;

import cpp.Int32;
import cpp.StdString;
import cpp.StdStringRef;

class AbstractInput
{
    inline public static function setApi(api:String):Void
    {
        ExternInput.setApi(StdString.ofString(api));
    }

    public static function count():Int
    {
        var count:Int = ExternInput.count();
        return count;
    }

    public static function get(id:Int):Int
    {
        var externId:Int32 = id;
        var i:Int = ExternInput.get(externId);
        return i;
    }

    public static function create(name:String):Int
    {
        var i:Int = ExternInput.create(StdString.ofString(name));
        return i;
    }

    public static function getStaticError():String
    {
        var error:StdStringRef = ExternInput.getStaticError();
        return error.toString();
    }

    inline public static function resetStaticError():Void
    {
        ExternInput.resetStaticError();
    }

    public static function isVirtual(instance:Int):Bool
    {
        var externInstance:Int32 = instance;
        var isVirtualInt:Int = ExternInput.isVirtual(externInstance);
        return isVirtualInt == 1 ? true : false;
    }

    public static function getName(instance:Int):String
    {
        var externInstance:Int32 = instance;
        var name:StdStringRef = ExternInput.getName(externInstance);
        return name.toString();
    }

    public static function getMessageSize(instance:Int):Int
    {
        var externInstance:Int32 = instance;
        var size:Int = ExternInput.getMessageSize(externInstance);
        return size;
    }

    public static function getMessageByte(instance:Int, i:Int):Int
    {
        var externInstance:Int32 = instance;
        var externI:Int32 = i;
        var byte:Int = ExternInput.getMessageByte(externInstance, externI);
        return byte;
    }

    static public function close(instance:Int):Void
    {
        var externInstance:Int32 = instance;
        ExternInput.close(externInstance);
    }

    static public function getError(instance:Int):String
    {
        var externInstance:Int32 = instance;
        var error:StdStringRef = ExternInput.getError(externInstance);
        return error.toString();
    }

    static public function resetError(instance:Int):Void
    {
        var externInstance:Int32 = instance;
        ExternInput.resetError(externInstance);
    }
}