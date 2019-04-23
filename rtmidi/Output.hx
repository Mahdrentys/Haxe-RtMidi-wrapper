package rtmidi;

import rtmidi.externs.AbstractOutput;
import rtmidi.Codes.MessageType;
import rtmidi.Codes.Control;
import rtmidi.Message;

class Output
{
    public static var api(get, set):Api;
    public var virtual(default, null):Bool;
    public var id(default, null):Null<Int>;
    public var name(default, null):String;
    private var outputStream:OutputStream;

    inline private static function get_api():Api
    {
        return OutputStream.api;
    }

    inline private static function set_api(_api:Api):Api
    {
        OutputStream.api = _api;
        return _api;
    }

    private function new(_outputStream:OutputStream)
    {
        outputStream = _outputStream;
    }

    inline public static function count():Int
    {
        return AbstractOutput.count();
    }

    public static function all():Array<Output>
    {
        var outputs:Array<Output> = [];
        var count = count();

        for (id in 0...count)
        {
            outputs.push(get(id));
        }

        return outputs;
    }

    public static function get(id:Int):Output
    {
        var outputStream = new OutputStream({virtual: false, id: id});
        var output = new Output(outputStream);
        output.virtual = false;
        output.id = id;
        output.name = outputStream.name;
        return output;
    }

    public static function create(name:String):Output
    {
        var output = new Output(new OutputStream({virtual: true, name: name}));
        output.virtual = true;
        output.id = null;
        output.name = name;
        return output;
    }

    public function send(message:Message):Void
    {
        outputStream.sendMessage(message.toRaw());
    }

    public function close():Void
    {
        outputStream.close();
    }
}