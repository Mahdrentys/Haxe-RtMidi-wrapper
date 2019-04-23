package rtmidi.externs;

import cpp.Int32;
import cpp.StdString;
import cpp.StdStringRef;

class AbstractOutput
{
    private static function checkForErrors(instance:Null<Int> = null):Void
    {
        var stdStaticError:StdStringRef = ExternOutput.getStaticError();
        var staticError:String = stdStaticError.toString();

        if (staticError != "null")
        {
            ExternOutput.resetStaticError();
            throw staticError;
        }

        if (instance != null)
        {
            var externInstance:Int32 = instance;
            var stdError:StdStringRef = ExternOutput.getError(instance);
            var error:String = stdError.toString();

            if (error != "null")
            {
                ExternOutput.resetError(instance);
                throw error;
            }
        }
    }

    inline public static function setApi(api:String):Void
    {
        ExternOutput.setApi(StdString.ofString(api));
        checkForErrors();
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
        checkForErrors(i);
        return i;
    }

    public static function create(name:String):Int
    {
        var i:Int = ExternOutput.create(StdString.ofString(name));
        checkForErrors(i);
        return i;
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
        checkForErrors(instance);
    }

    static public function close(instance:Int):Void
    {
        var externInstance:Int32 = instance;
        ExternOutput.close(externInstance);
        checkForErrors(instance);
    }
}