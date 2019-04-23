package rtmidi.externs;

import cpp.Int32;
import cpp.StdString;
import cpp.StdStringRef;

class AbstractInput
{
    private static function checkForErrors(instance:Null<Int> = null):Void
    {
        var stdStaticError:StdStringRef = ExternInput.getStaticError();
        var staticError:String = stdStaticError.toString();

        if (staticError != "null")
        {
            ExternInput.resetStaticError();
            throw staticError;
        }

        if (instance != null)
        {
            var externInstance:Int32 = instance;
            var stdError:StdStringRef = ExternInput.getError(instance);
            var error:String = stdError.toString();

            if (error != "null")
            {
                ExternInput.resetError(instance);
                throw error;
            }
        }
    }

    inline public static function setApi(api:String):Void
    {
        ExternInput.setApi(StdString.ofString(api));
        checkForErrors();
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
        checkForErrors(i);
        return i;
    }

    public static function create(name:String):Int
    {
        var i:Int = ExternInput.create(StdString.ofString(name));
        checkForErrors(i);
        return i;
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
        checkForErrors(instance);
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
        checkForErrors(instance);
    }
}