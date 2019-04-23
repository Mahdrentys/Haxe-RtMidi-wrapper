package rtmidi;

import rtmidi.externs.AbstractInput;
import rtmidi.Codes.MessageType;
import rtmidi.Codes.Control;
import rtmidi.Message;

class Input
{
    public static var api(get, set):Api;
    public var virtual(default, null):Bool;
    public var id(default, null):Null<Int>;
    public var name(default, null):String;

    private var callbacks:Array<Callback> = [];
    private var inputStream:InputStream;

    inline private static function get_api():Api
    {
        return InputStream.api;
    }

    inline private static function set_api(_api:Api):Api
    {
        InputStream.api = _api;
        return _api;
    }

    private function new(_inputStream:InputStream)
    {
        inputStream = _inputStream;
    }

    inline public static function count():Int
    {
        return AbstractInput.count();
    }

    public static function all():Array<Input>
    {
        var inputs:Array<Input> = [];
        var count = count();

        for (id in 0...count)
        {
            inputs.push(get(id));
        }

        return inputs;
    }

    public static function get(id:Int):Input
    {
        var inputStream = new InputStream({virtual: false, id: id});
        var input = new Input(inputStream);
        input.virtual = false;
        input.id = id;
        input.name = inputStream.name;
        return input;
    }

    public static function create(name:String):Input
    {
        var input = new Input(new InputStream({virtual: true, name: name}));
        input.virtual = true;
        input.id = null;
        input.name = name;
        return input;
    }

    public function onMessage(callback:Callback):Void
    {
        callbacks.push(callback);
    }

    public function on<T>(type:Class<T>, callback:T->Void):Void
    {
        onMessage(function(message:Message):Void
        {
            if (Type.getClassName(Type.getClass(message)) == Type.getClassName(type))
            {
                callback(cast message);
            }
        });
    }

    dynamic public function errorHandler(e:Dynamic):Void
    {
        throw e;
    }

    public function listen():Void
    {
        inputStream.onMessage(function(message:Array<Int>):Void
        {
            for (callback in callbacks)
            {
                callback(Message.fromRaw(message));
            }
        });

        inputStream.errorHandler = function(e:Dynamic):Void
        {
            errorHandler(e);
        };

        inputStream.listen();
    }

    public function stop():Void
    {
        inputStream.stop();
        inputStream.resetListeners();
    }
}