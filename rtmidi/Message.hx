package rtmidi;

import rtmidi.Codes;
import rtmidi.Codes.MessageType;
import rtmidi.Codes.Control;
import haxe.ds.Either;

class Message
{
    public var type:MessageType;
    public var channel:Int;
    public var data:Null<Array<Int>> = null;

    private function checkChannel(value:Int):Void
    {
        if (value < 0 || value > 15)
        {
            throw "RtMidi: Message channel must be between 0 and 15!";
        }
    }

    private function checkInt(value:Int):Void
    {
        if (value < 0 || value > 127)
        {
            throw "RtMidi: Int message parameters must be between 0 and 127!";
        }
    }

    private function checkFloat(value:Float):Void
    {
        if (value < 0 || value > 1)
        {
            throw "RtMidi: Float message parameters must be between 0 and 1!";
        }
    }

    public static function fromRaw(rawMessage:Array<Int>):Message
    {
        var messageClasses:Array<Class<Message>> = [NoteOnMessage, NoteOffMessage, PitchBendMessage, MonoAftertouchMessage, PolyAftertouchMessage, ProgramChangeMessage, ControlChangeMessage];
        var message:Message = Type.createEmptyInstance(Message);

        for (messageClass in messageClasses)
        {
            message = (cast messageClass).fromRaw(rawMessage);

            if (message != null)
            {
                break;
            }
        }

        if (message == null)
        {
            var status = Codes.getStatus(rawMessage[0]);
            message = Type.createEmptyInstance(Message);
            message.type = status.type;
            message.channel = status.channel;
            message.data = rawMessage;
            message.data.shift();
        }

        return message;
    }

    public function toRaw():Array<Int>
    {
        return [];
    }
}

class NoteOnMessage extends Message
{
    public var note:Int;
    public var velocity:Float;

    public function new(_note:Int, _velocity:Float, _channel:Int = 0)
    {
        type = MessageType.NoteOn;
        checkInt(_note);
        checkFloat(_velocity);
        checkChannel(_channel);
        note = _note;
        velocity = _velocity;
        channel = _channel;
    }

    public static function fromRaw(message:Array<Int>):NoteOnMessage
    {
        var status = Codes.getStatus(message[0]);

        if (!Type.enumEq(status.type, MessageType.NoteOn))
        {
            return null;
        }

        return new NoteOnMessage(message[1], message[2] / 127, status.channel);
    }

    override public function toRaw():Array<Int>
    {
        return [Codes.types.get("NoteOn") + channel, note, Std.int(velocity * 127)];
    }
}

class NoteOffMessage extends Message
{
    public var note:Int;

    public function new(_note:Int, _channel:Int = 0)
    {
        type = MessageType.NoteOff;
        checkInt(_note);
        checkChannel(_channel);
        note = _note;
        channel = _channel;
    }

    public static function fromRaw(message:Array<Int>):NoteOffMessage
    {
        var status = Codes.getStatus(message[0]);

        if (!Type.enumEq(status.type, MessageType.NoteOff))
        {
            return null;
        }

        return new NoteOffMessage(message[1], status.channel);
    }

    override public function toRaw():Array<Int>
    {
        return [Codes.types.get("NoteOff") + channel, note, 0];
    }
}

class PitchBendMessage extends Message
{
    public var value:Float;

    public function new(_value:Float, _channel:Int = 0)
    {
        type = MessageType.PitchBend;
        
        if (_value > 1 && _value < 1.1)
        {
            _value = 1;
        }
        if (_value < -1 || _value > 1.1)
        {
            throw "RtMidi: Pitch bends must be between -1 and 1!";
        }

        checkChannel(_channel);
        value = _value;
        channel = _channel;
    }

    public static function fromRaw(message:Array<Int>):PitchBendMessage
    {
        var status = Codes.getStatus(message[0]);

        if (!Type.enumEq(status.type, MessageType.PitchBend))
        {
            return null;
        }
        
        var value = (message[2] + message[1] / 127) / 127 * 2 - 1;
        return new PitchBendMessage(value, status.channel);
    }

    override public function toRaw():Array<Int>
    {
        var value127 = (value / 2 + 0.5) * 127;
        var msb = Std.int(value127);
        var lsb = Std.int((value127 - msb) * 127);
        return [Codes.types.get("PitchBend") + channel, lsb, msb];
    }
}

class MonoAftertouchMessage extends Message
{
    public var value:Float;

    public function new(_value:Float, _channel:Int = 0)
    {
        type = MessageType.MonoAftertouch;
        checkFloat(_value);
        checkChannel(_channel);
        value = _value;
        channel = _channel;
    }

    public static function fromRaw(message:Array<Int>):MonoAftertouchMessage
    {
        var status = Codes.getStatus(message[0]);

        if (!Type.enumEq(status.type, MessageType.MonoAftertouch))
        {
            return null;
        }
        
        return new MonoAftertouchMessage(message[1] / 127, status.channel);
    }

    override public function toRaw():Array<Int>
    {
        return [Codes.types.get("MonoAftertouch") + channel, Std.int(value * 127)];
    }
}

class PolyAftertouchMessage extends Message
{
    public var note:Int;
    public var value:Float;

    public function new(_note:Int, _value:Float, _channel:Int = 0)
    {
        type = MessageType.PolyAftertouch;
        checkInt(_note);
        checkFloat(_value);
        checkChannel(_channel);
        note = _note;
        value = _value;
        channel = _channel;
    }

    public static function fromRaw(message:Array<Int>):PolyAftertouchMessage
    {
        var status = Codes.getStatus(message[0]);

        if (!Type.enumEq(status.type, MessageType.PolyAftertouch))
        {
            return null;
        }
        
        return new PolyAftertouchMessage(message[1], message[2] / 127, status.channel);
    }

    override public function toRaw():Array<Int>
    {
        return [Codes.types.get("MonoAftertouch") + channel, note, Std.int(value * 127)];
    }
}

class ProgramChangeMessage extends Message
{
    public var program:Int;

    public function new(_program:Int, _channel:Int = 0)
    {
        type = MessageType.ProgramChange;
        checkInt(_program);
        checkChannel(_channel);
        program = _program;
        channel = _channel;
    }

    public static function fromRaw(message:Array<Int>):ProgramChangeMessage
    {
        var status = Codes.getStatus(message[0]);

        if (!Type.enumEq(status.type, MessageType.ProgramChange))
        {
            return null;
        }

        return new ProgramChangeMessage(message[1], status.channel);
    }

    override public function toRaw():Array<Int>
    {
        return [Codes.types.get("ProgramChange") + channel, program];
    }
}

class ControlChangeMessage extends Message
{
    public var control:Control;
    public var value:Float;

    public function new(_control:Control, _value:Float, _channel:Int = 0)
    {
        type = MessageType.ControlChange;

        switch (_control)
        {
            case Control.Code(code):
                if (code < 0 || code > 127)
                {
                    throw "RtMidi: Midi cc control numbers must be between 0 and 127!";
                }

            case _:
        }

        checkFloat(_value);
        checkChannel(_channel);

        control = _control;
        value = _value;
        channel = _channel;
    }

    public static function fromRaw(message:Array<Int>):ControlChangeMessage
    {
        var status = Codes.getStatus(message[0]);

        if (!Type.enumEq(status.type, MessageType.ControlChange))
        {
            return null;
        }

        var control = Codes.getControl(message[1]);
        return new ControlChangeMessage(control != null ? control : Control.Code(message[1]), message[2] / 127, status.channel);
    }

    override public function toRaw():Array<Int>
    {
        var controlCode:Int;

        switch (control)
        {
            case Control.Code(code): controlCode = code;
            case _: controlCode = Codes.controls.get(Type.enumConstructor(control));
        }

        return [Codes.types.get("ControlChange") + channel, controlCode, Std.int(value * 127)];
    }
}