package rtmidi;

import rtmidi.externs.CppImport;
import rtmidi.externs.AbstractInput;
import cpp.vm.Thread;

class InputStream
{
    static private var _api:Api;
    static public var api(get, set):Api;

    private var instance:Int;
    private var thread:Null<Thread> = null;
    private var callbacks:Array<RawCallback> = [];

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
            AbstractInput.setApi("alsa");
        }
        else if (_api == Api.Jack)
        {
            AbstractInput.setApi("jack");
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
            instance = AbstractInput.create(name);
        }
        else
        {
            virtual = false;
            id = value.id;
            instance = AbstractInput.get(id);
            name = AbstractInput.getName(instance);
        }
    }

    public function onMessage(callback:RawCallback):Void
    {
        callbacks.push(callback);
    }

    public function listen():Void
    {
        if (thread != null)
        {
            return;
        }

        thread = Thread.create(function():Void
        {
            while (true)
            {
                var size = AbstractInput.getMessageSize(instance);
                
                if (size > 0)
                {
                    var message:Array<Int> = [];

                    for (i in 0...size)
                    {
                        message.push(AbstractInput.getMessageByte(instance, i));
                    }

                    for (callback in callbacks)
                    {
                        callback(message);
                    }
                }

                if (Thread.readMessage(false) == "stop")
                {
                    break;
                }
            }

            AbstractInput.close(instance);
        });
    }

    public function stop():Void
    {
        thread.sendMessage("stop");
        thread = null;
    }
}