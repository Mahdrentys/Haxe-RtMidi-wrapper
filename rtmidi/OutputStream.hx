package rtmidi;

import rtmidi.externs.CppImport;
import rtmidi.externs.AbstractOutput;
import cpp.vm.Thread;

class OutputStream
{
    static private var _api:Api;
    static public var api(get, set):Api;

    private var instance:Int;
    public var id(default, null):Null<Int>;
    public var name(default, null):String;
    public var virtual(default, null):Bool;

    private static function get_api():Api
    {
        return _api;
    }

    private static function set_api(__api:Api):Api
    {
        _api = __api;

        if (_api == Api.Alsa)
        {
            AbstractOutput.setApi("alsa");
        }
        else if (_api == Api.Jack)
        {
            AbstractOutput.setApi("jack");
        }

        return _api;
    }

    public function new(value:{virtual: Bool, ?id: Int, ?name: String})
    {
        new CppImport();

        if (value.virtual)
        {
            virtual = true;
            id = null;
            name = value.name;
            instance = AbstractOutput.create(name);
        }
        else
        {
            virtual = false;
            id = value.id;
            instance = AbstractOutput.get(id);
            name = AbstractOutput.getName(instance);
        }
    }

    public function sendMessage(message:RawMessage):Void
    {
        for (byte in message)
        {
            AbstractOutput.sendMessageByte(instance, byte);
        }

        AbstractOutput.sendMessage(instance);
    }

    public function close():Void
    {
        AbstractOutput.close(instance);
    }
}